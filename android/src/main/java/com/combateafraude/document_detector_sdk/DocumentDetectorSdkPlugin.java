package com.combateafraude.document_detector_sdk;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;

import androidx.annotation.NonNull;

import com.combateafraude.documentdetector.DocumentDetector;
import com.combateafraude.documentdetector.DocumentDetectorActivity;
import com.combateafraude.documentdetector.DocumentDetectorResult;
import com.combateafraude.documentdetector.configuration.Document;
import com.combateafraude.documentdetector.configuration.DocumentDetectorStep;
import com.combateafraude.helpers.sdk.failure.InvalidTokenReason;
import com.combateafraude.helpers.sdk.failure.LibraryReason;
import com.combateafraude.helpers.sdk.failure.NetworkReason;
import com.combateafraude.helpers.sdk.failure.PermissionReason;
import com.combateafraude.helpers.sdk.failure.ServerReason;
import com.combateafraude.helpers.sdk.failure.StorageReason;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import static android.app.Activity.RESULT_OK;
import static com.combateafraude.documentdetector.configuration.Document.CNH_BACK;
import static com.combateafraude.documentdetector.configuration.Document.CNH_FRONT;
import static com.combateafraude.documentdetector.configuration.Document.CNH_FULL;
import static com.combateafraude.documentdetector.configuration.Document.OTHERS;
import static com.combateafraude.documentdetector.configuration.Document.RG_BACK;
import static com.combateafraude.documentdetector.configuration.Document.RG_FRONT;
import static com.combateafraude.documentdetector.configuration.Document.RG_FULL;

/**
 * DocumentDetectorSdkPlugin
 */
public class DocumentDetectorSdkPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {

    private static final String DEBUG_NAME = "DocumentDetectorSdk";
    private Activity activity;
    private Context context;
    private ActivityPluginBinding activityBinding;

    private MethodChannel methodChannel;
    private MethodChannel.Result pendingResult;

    private static final String MESSAGE_CHANNEL = "com.combateafraude.document_detector_sdk/message";

    private static final int REQUEST_CODE_DOCUMENT_DETECTOR = 20981;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        setupChannels(binding.getFlutterEngine().getDartExecutor(), binding.getApplicationContext());
    }

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    public static void registerWith(Registrar registrar) {
        if (registrar.activity() == null) {
            // When a background flutter view tries to register the plugin, the registrar has no activity.
            // We stop the registration process as this plugin is foreground only.
            return;
        }

        DocumentDetectorSdkPlugin plugin = new DocumentDetectorSdkPlugin();
        plugin.setupChannels(registrar.messenger(), registrar.activity().getApplicationContext());
        plugin.setActivity(registrar.activity());
        registrar.addActivityResultListener(plugin);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        teardownChannels();
    }

    private void setupChannels(BinaryMessenger messenger, Context context) {
        this.context = context;
        methodChannel = new MethodChannel(messenger, MESSAGE_CHANNEL);
        methodChannel.setMethodCallHandler(this);
    }

    private void setActivity(Activity activity) {
        this.activity = activity;
    }

    private void teardownChannels() {
        this.activity = null;
        if (this.activityBinding != null) {
            this.activityBinding.removeActivityResultListener(this);
        }
        this.activityBinding = null;
        this.context = null;
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        this.activityBinding = binding;
        setActivity(binding.getActivity());
        this.activityBinding.addActivityResultListener(this);
    }

    @Override
    public void onDetachedFromActivity() {
        teardownChannels();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity();
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        onAttachedToActivity(binding);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        this.pendingResult = result;
        switch (call.method) {
            case "getDocuments":
                getDocuments(call, result);
                break;
            default:
                result.notImplemented();
        }
    }

    private void getDocuments(MethodCall call, final Result result) {
        HashMap<String, Object> argsMap = (HashMap<String, Object>) call.arguments;

        if (!(call.arguments instanceof Map)) {
            throw new IllegalArgumentException("Map argument expected");
        }

        final String mobileToken = (String) argsMap.get("mobileToken");
        final List<Map<String, Object>> flow = (List<Map<String, Object>>) argsMap.get("flow");
        final Boolean hasSound = (Boolean) argsMap.get("hasSound");
        final Integer requestTimeout = (Integer) argsMap.get("requestTimeout");
        final Boolean verify = (Boolean) argsMap.get("verify");
        final Double qualityThreshold = (Double) argsMap.get("qualityThreshold");
        final Boolean showPopup = (Boolean) argsMap.get("showPopup");

        DocumentDetectorStep[] documentDetectorSteps = new DocumentDetectorStep[flow.size()];

        int count = 0;
        for (Map<String, Object> docStep : flow) {
            final Document document = getDocumentType((String) docStep.get("document"));

            Integer stepLabelId = null;
            Integer illustrationId = null;
            Integer audioId = null;

            if (docStep.containsKey("androidStepLabelName")) {
                stepLabelId = activity.getResources().getIdentifier((String) docStep.get("androidStepLabelName"), "string", activity.getPackageName());
                if (stepLabelId == 0)
                    throw new IllegalArgumentException("Invalid 'Step Label Name in strings.xml");
            }

            if (docStep.containsKey("androidIllustrationName")) {
                illustrationId = activity.getResources().getIdentifier((String) docStep.get("androidIllustrationName"), "drawable", activity.getPackageName());
                if (illustrationId == 0)
                    throw new IllegalArgumentException("Invalid 'Illustration Name' in drawable folder");
            }

            if (docStep.containsKey("androidAudioName")) {
                audioId = activity.getResources().getIdentifier((String) docStep.get("androidAudioName"), "raw", activity.getPackageName());
                if (audioId == 0)
                    throw new IllegalArgumentException("Invalid 'Audio Name' in raw folder");
            }

            documentDetectorSteps[count] = new DocumentDetectorStep(document, stepLabelId, illustrationId, audioId);
            count++;
        }

        Integer redMaskId = null;
        Integer whiteMaskId = null;
        Integer greenMaskId = null;
        Integer layoutId = null;
        Integer styleResourceId = null;

        if (argsMap.containsKey("nameRedMask")) {
            redMaskId = activity.getResources().getIdentifier((String) argsMap.get("nameRedMask"), "drawable", activity.getPackageName());

            if (redMaskId == 0) throw new IllegalArgumentException("Invalid RedMask name in drawable folder");
        }
        if (argsMap.containsKey("nameWhiteMask")) {
            whiteMaskId = activity.getResources().getIdentifier((String) argsMap.get("nameWhiteMask"), "drawable", activity.getPackageName());

            if (whiteMaskId == 0) throw new IllegalArgumentException("Invalid WhiteMask name in drawable folder");
        }
        if (argsMap.containsKey("nameGreenMask")) {
            greenMaskId = activity.getResources().getIdentifier((String) argsMap.get("nameGreenMask"), "drawable", activity.getPackageName());

            if (greenMaskId == 0) throw new IllegalArgumentException("Invalid GreenMask name in drawable folder");
        }
        if (argsMap.containsKey("nameLayout")) {
            layoutId = activity.getResources().getIdentifier((String) argsMap.get("nameLayout"), "layout", activity.getPackageName());

            if (layoutId == 0) throw new IllegalArgumentException("Invalid Layout name in layout folder");
        }
        if (argsMap.containsKey("nameStyle")) {
            styleResourceId = activity.getResources().getIdentifier((String) argsMap.get("nameStyle"), "style", activity.getPackageName());

            if (styleResourceId == 0) throw new IllegalArgumentException("Invalid Style in style.xml");
        }

        Integer sensorLuminosityMessageId = null;
        Integer sensorOrientationMessageId = null;
        Integer sensorStabilityMessageId = null;

        if (argsMap.containsKey("aLuminosityMessage")) {
            sensorLuminosityMessageId = activity.getResources().getIdentifier((String) argsMap.get("aLuminosityMessage"), "string", activity.getPackageName());

            if (sensorLuminosityMessageId == 0) throw new IllegalArgumentException("Invalid SensorLuminosityMessage name in strings.xml file");
        }

        if (argsMap.containsKey("aOrientationMessage")) {
            sensorOrientationMessageId = activity.getResources().getIdentifier((String) argsMap.get("aOrientationMessage"), "string", activity.getPackageName());

            if (sensorOrientationMessageId == 0) throw new IllegalArgumentException("Invalid SensorOrientationMessage name in strings.xml file");
        }

        if (argsMap.containsKey("aStabilityMessage")) {
            sensorStabilityMessageId = activity.getResources().getIdentifier((String) argsMap.get("aStabilityMessage"), "string", activity.getPackageName());

            if (sensorStabilityMessageId == 0) throw new IllegalArgumentException("Invalid SensorStabilityMessage name in strings.xml file");
        }


        final DocumentDetector mDocumentDetector = new DocumentDetector.Builder(mobileToken)
                .setDocumentDetectorFlow(documentDetectorSteps)
                .showPopup(showPopup)
                .setLayout(layoutId, greenMaskId, whiteMaskId, redMaskId)
                .enableSound(hasSound)
                .setStyle(styleResourceId)
                .setRequestTimeout(requestTimeout)
                .setSensorMessages(sensorLuminosityMessageId, sensorOrientationMessageId, sensorStabilityMessageId)
                .verifyQuality(verify, qualityThreshold)
                .build();

        Intent mIntent = new Intent(context, DocumentDetectorActivity.class);
        mIntent.putExtra(DocumentDetector.PARAMETER_NAME, mDocumentDetector);
        activity.startActivityForResult(mIntent, REQUEST_CODE_DOCUMENT_DETECTOR);
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        final Map<String, Object> response = new HashMap<>();
        if (requestCode == REQUEST_CODE_DOCUMENT_DETECTOR) {
            if (resultCode == RESULT_OK && data != null) {
                DocumentDetectorResult documentDetectorResult = (DocumentDetectorResult) data.getSerializableExtra(DocumentDetectorResult.PARAMETER_NAME);
                if (documentDetectorResult.wasSuccessful()) {
                    response.put("success", Boolean.valueOf(true));
                    response.put("capture_type", documentDetectorResult.getType());

                    List<Map<String , Object>> captureList  = new ArrayList<>();

                    for (int i = 0; i < documentDetectorResult.getCaptures().length; i++) {
                        final Map<String, Object> capture = new HashMap<>();
                        capture.put("imagePath", documentDetectorResult.getCaptures()[i].getImagePath());
                        if (documentDetectorResult.getCaptures()[i].getImageUrl() != null) {
                            capture.put("imageUrl", documentDetectorResult.getCaptures()[i].getImageUrl());
                        } else {
                            capture.put("imageUrl", "");
                        }
                        capture.put("missedAttemps", documentDetectorResult.getCaptures()[i].getMissedAttemps());
                        capture.put("scannedLabel", documentDetectorResult.getCaptures()[i].getLabel());
                        captureList.add(capture);
                    }
                    response.put("capture", captureList);
                } else {
                    response.put("success", Boolean.valueOf(false));
                    if (documentDetectorResult.getSdkFailure() instanceof InvalidTokenReason) {
                        response.put("errorType", "InvalidTokenReason");
                        response.put("errorMessage", documentDetectorResult.getSdkFailure().getMessage());
                    } else if (documentDetectorResult.getSdkFailure() instanceof PermissionReason) {
                        response.put("errorType", "PermissionReason");
                        response.put("errorMessage", documentDetectorResult.getSdkFailure().getMessage());
                    } else if (documentDetectorResult.getSdkFailure() instanceof NetworkReason) {
                        response.put("errorType", "NetworkReason");
                        response.put("errorMessage", documentDetectorResult.getSdkFailure().getMessage());
                    } else if (documentDetectorResult.getSdkFailure() instanceof ServerReason) {
                        response.put("errorType", "ServerReason");
                        response.put("errorCode", ((ServerReason) documentDetectorResult.getSdkFailure()).getCode());
                        response.put("errorMessage", documentDetectorResult.getSdkFailure().getMessage());
                    } else if (documentDetectorResult.getSdkFailure() instanceof StorageReason) {
                        response.put("errorType", "StorageReason");
                        response.put("errorMessage", documentDetectorResult.getSdkFailure().getMessage());
                    } else if (documentDetectorResult.getSdkFailure() instanceof LibraryReason) {
                        response.put("errorType", "LibraryReason");
                        response.put("errorMessage", documentDetectorResult.getSdkFailure().getMessage());
                    } else {
                        response.put("errorType", "SDKFailure");
                        response.put("errorMessage", documentDetectorResult.getSdkFailure().getMessage());
                    }
                }
                pendingResult.success(response);
                return true;
            } else {
                // the user closes the activity
                response.put("success", Boolean.valueOf(false));
                response.put("cancel", Boolean.valueOf(true));
                pendingResult.success(response);
                return false;
            }
        }
        return true;
    }

    private Document getDocumentType(String type) {
        switch (type) {
            case "CNH_FRONT":
                return CNH_FRONT;
            case "CNH_BACK":
                return CNH_BACK;
            case "CNH_FULL":
                return CNH_FULL;
            case "RG_FRONT":
                return RG_FRONT;
            case "RG_BACK":
                return RG_BACK;
            case "RG_FULL":
                return RG_FULL;
            default:
                return OTHERS;
        }
    }
}
