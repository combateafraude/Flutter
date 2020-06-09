package com.combateafraude.document_detector_sdk;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;

import androidx.annotation.NonNull;

import com.combateafraude.documentdetector.DocumentDetector;
import com.combateafraude.documentdetector.DocumentDetectorActivity;
import com.combateafraude.documentdetector.DocumentDetectorResult;
import com.combateafraude.documentdetector.controller.Capture;
import com.combateafraude.helpers.sdk.failure.InvalidTokenReason;
import com.combateafraude.helpers.sdk.failure.LibraryReason;
import com.combateafraude.helpers.sdk.failure.NetworkReason;
import com.combateafraude.helpers.sdk.failure.PermissionReason;
import com.combateafraude.helpers.sdk.failure.ServerReason;
import com.combateafraude.helpers.sdk.failure.StorageReason;

import java.util.HashMap;
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

    private static final int REQUEST_CODE = 990;

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

    private void setupChannels(BinaryMessenger messenger, Context context) {
        this.context = context;
        methodChannel = new MethodChannel(messenger, MESSAGE_CHANNEL);
        methodChannel.setMethodCallHandler(this);
    }

    private void setActivity(Activity activity) {
        this.activity = activity;
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

        String mobileToken = (String) argsMap.get("mobileToken");
        String documentType = (String) argsMap.get("documentType");
        Boolean hasSound = (Boolean) argsMap.get("hasSound");
        Integer requestTimeout = (Integer) argsMap.get("requestTimeout");

        Integer idRedMask = null;
        if (argsMap.containsKey("nameRedMask")) {
            idRedMask = activity.getResources().getIdentifier((String) argsMap.get("nameRedMask"), "drawable", activity.getPackageName());

            if (idRedMask == 0) throw new IllegalArgumentException("Invalid RedMask name");
        }

        Integer idWhiteMask = null;
        if (argsMap.containsKey("nameWhiteMask")) {
            idWhiteMask = activity.getResources().getIdentifier((String) argsMap.get("nameWhiteMask"), "drawable", activity.getPackageName());

            if (idWhiteMask == 0) throw new IllegalArgumentException("Invalid WhiteMask name");
        }

        Integer idGreenMask = null;
        if (argsMap.containsKey("nameGreenMask")) {
            idGreenMask = activity.getResources().getIdentifier((String) argsMap.get("nameGreenMask"), "drawable", activity.getPackageName());

            if (idGreenMask == 0) throw new IllegalArgumentException("Invalid GreenMask name");
        }

        Integer idLayout = null;
        if (argsMap.containsKey("nameLayout")) {
            idLayout = activity.getResources().getIdentifier((String) argsMap.get("nameLayout"), "layout", activity.getPackageName());

            if (idLayout == 0) throw new IllegalArgumentException("Invalid Layout name");
        }

        Integer idStyle = null;
        if (argsMap.containsKey("nameStyle")) {
            idStyle = activity.getResources().getIdentifier((String) argsMap.get("nameStyle"), "style", activity.getPackageName());

            if (idStyle == 0) throw new IllegalArgumentException("Invalid Style name");
        }

        DocumentDetector mDocumentDetector;
        if (documentType == "RG") {
            mDocumentDetector = new DocumentDetector.Builder(mobileToken)
                    .setDocumentDetectorFlow(DocumentDetector.RG_FLOW)
                    .setMask(idGreenMask, idWhiteMask, idRedMask)
                    .setLayout(idLayout)
                    .hasSound(hasSound)
                    .setStyle(idStyle)
                    .setRequestTimeout(requestTimeout)
                    .build();
        } else {
            mDocumentDetector = new DocumentDetector.Builder(mobileToken)
                    .setDocumentDetectorFlow(DocumentDetector.CNH_FLOW)
                    .setMask(idGreenMask, idWhiteMask, idRedMask)
                    .setLayout(idLayout)
                    .hasSound(hasSound)
                    .setStyle(idStyle)
                    .setRequestTimeout(requestTimeout)
                    .build();
        }

        Intent mIntent = new Intent(context, DocumentDetectorActivity.class);
        mIntent.putExtra(DocumentDetector.PARAMETER_NAME, mDocumentDetector);
        activity.startActivityForResult(mIntent, REQUEST_CODE);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        teardownChannels();
    }

    private void teardownChannels() {
        this.activity = null;
        this.context = null;
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        setActivity(binding.getActivity());
        activityBinding = binding;
        activityBinding.addActivityResultListener(this);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        this.activity = null;
        activityBinding.removeActivityResultListener(this);
        activityBinding = null;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        onDetachedFromActivity();
    }

    @Override
    public void onDetachedFromActivity() {
        this.activity = null;
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        final Map<String, Object> response = new HashMap<>();
        if (requestCode == REQUEST_CODE) {
            if (resultCode == RESULT_OK && data != null) {
                DocumentDetectorResult documentDetectorResult = (DocumentDetectorResult) data.getSerializableExtra(DocumentDetectorResult.PARAMETER_NAME);
                if (documentDetectorResult.wasSuccessful()) {
                    response.put("success", Boolean.valueOf(true));
                    response.put("captureFront_imagePath", documentDetectorResult.getCaptures()[0].getImagePath());
                    response.put("captureFront_missedAttemps", documentDetectorResult.getCaptures()[0].getMissedAttemps());
                    response.put("captureBack_imagePath", documentDetectorResult.getCaptures()[1].getImagePath());
                    response.put("captureBack_missedAttemps", documentDetectorResult.getCaptures()[1].getMissedAttemps());
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
        response.put("success", Boolean.valueOf(false));
        response.put("cancel", Boolean.valueOf(true));
        pendingResult.success(response);
        return true;
    }
}
