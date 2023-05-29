package com.combateafraude.document_detector_compatible;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.combateafraude.documentdetector.DocumentDetectorActivity;
import com.combateafraude.documentdetector.input.CaptureMode;
import com.combateafraude.documentdetector.input.CaptureStage;
import com.combateafraude.documentdetector.input.DetectionSettings;
import com.combateafraude.documentdetector.input.Document;
import com.combateafraude.documentdetector.input.DocumentDetector;
import com.combateafraude.documentdetector.input.DocumentDetectorStep;
import com.combateafraude.documentdetector.input.MaskType;
import com.combateafraude.documentdetector.input.PreviewSettings;
import com.combateafraude.documentdetector.input.QualitySettings;
import com.combateafraude.documentdetector.input.Resolution;
import com.combateafraude.documentdetector.input.SensorLuminositySettings;
import com.combateafraude.documentdetector.input.SensorOrientationSettings;
import com.combateafraude.documentdetector.input.SensorStabilitySettings;
import com.combateafraude.documentdetector.input.MessageSettings;
import com.combateafraude.documentdetector.input.UploadSettings;
import com.combateafraude.documentdetector.input.FileFormat;
import com.combateafraude.documentdetector.output.Capture;
import com.combateafraude.documentdetector.output.DocumentDetectorResult;
import com.combateafraude.documentdetector.output.failure.SDKFailure;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;

import java.util.ArrayList;
import java.util.HashMap;

@SuppressWarnings("unchecked")
public class DocumentDetectorCompatiblePlugin
        implements FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {

    private static final int REQUEST_CODE = 1001;

    private static final String DRAWABLE_RES = "drawable";
    private static final String STYLE_RES = "style";
    private static final String STRING_RES = "string";
    private static final String RAW_RES = "raw";
    private static final String LAYOUT_RES = "layout";

    private MethodChannel channel;
    private Result result;
    private Activity activity;
    private ActivityPluginBinding activityBinding;
    private Context context;

    @Override
    public synchronized void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("start")) {
            this.result = result;
            start(call);
        } else {
            result.notImplemented();
            result = null;
        }
    }

    private synchronized void start(@NonNull MethodCall call) {
        HashMap<String, Object> argumentsMap = (HashMap<String, Object>) call.arguments;

        // Mobile token
        String mobileToken = (String) argumentsMap.get("mobileToken");

        DocumentDetector.Builder mDocumentDetectorBuilder = new DocumentDetector.Builder(mobileToken);

        // People ID
        String peopleId = (String) argumentsMap.get("peopleId");
        mDocumentDetectorBuilder.setPersonId(peopleId);

        // Use Analytics
        Boolean useAnalytics = (Boolean) argumentsMap.get("useAnalytics");
        if (useAnalytics != null)
            mDocumentDetectorBuilder.setAnalyticsSettings(useAnalytics);

        String expireTime = (String) argumentsMap.get("expireTime");
        if (expireTime != null) {
            mDocumentDetectorBuilder.setGetImageUrlExpireTime(expireTime);
        }

        // Document steps
        ArrayList<HashMap<String, Object>> paramSteps = (ArrayList<HashMap<String, Object>>) argumentsMap
                .get("documentSteps");
        DocumentDetectorStep[] documentDetectorSteps = new DocumentDetectorStep[paramSteps.size()];
        for (int i = 0; i < paramSteps.size(); i++) {
            HashMap<String, Object> step = paramSteps.get(i);

            Document document = Document.valueOf((String) step.get("document"));

            HashMap<String, Object> stepCustomization = (HashMap<String, Object>) step.get("android");
            if (stepCustomization != null) {
                Integer stepLabelId = getResourceId((String) stepCustomization.get("stepLabelStringResName"),
                        STRING_RES);
                Integer illustrationId = getResourceId((String) stepCustomization.get("illustrationDrawableResName"),
                        DRAWABLE_RES);
                Integer audioId = getResourceId((String) stepCustomization.get("audioRawResName"), RAW_RES);

                DocumentDetectorStep detectorStep = new DocumentDetectorStep(document);

                if (stepLabelId != null)
                    detectorStep.setStepLabel(stepLabelId);
                if (illustrationId != null)
                    detectorStep.setIllustration(illustrationId);
                if (audioId != null)
                    detectorStep.setStepAudio(audioId);

                documentDetectorSteps[i] = detectorStep;
            } else {
                documentDetectorSteps[i] = new DocumentDetectorStep(document);
            }
        }
        mDocumentDetectorBuilder.setDocumentSteps(documentDetectorSteps);

        // Integer layoutId = getResourceId((String)
        // customizationAndroid.get("layoutResIdName"), LAYOUT_RES);

        // Preview
        HashMap<String, Object> showPreview = (HashMap<String, Object>) argumentsMap.get("showPreview");
        if (showPreview != null) {
            boolean show = (boolean) showPreview.get("show");
            String title = (String) showPreview.get("title");
            String subtitle = (String) showPreview.get("subtitle");
            String confirmLabel = (String) showPreview.get("confirmLabel");
            String retryLabel = (String) showPreview.get("retryLabel");

            mDocumentDetectorBuilder
                    .setPreviewSettings(new PreviewSettings(show, title, subtitle, confirmLabel, retryLabel));
        }

        HashMap<String, Object> previewSettingsHashMap = (HashMap<String, Object>) argumentsMap.get("previewSettings");
        if (previewSettingsHashMap != null) {
            String title = (String) previewSettingsHashMap.get("title");
            String subTitle = (String) previewSettingsHashMap.get("subTitle");
            String confirmLabel = (String) previewSettingsHashMap.get("confirmLabel");
            String retryLabel = (String) previewSettingsHashMap.get("retryLabel");
            boolean show = (boolean) previewSettingsHashMap.get("show");

            PreviewSettings previewSettings = new PreviewSettings(
                    true,
                    title,
                    subTitle,
                    confirmLabel,
                    retryLabel);

            mDocumentDetectorBuilder.setPreviewSettings(previewSettings);
        }

        HashMap<String, Object> messageSettingsParam = (HashMap<String, Object>) argumentsMap.get("messageSettings");
        if (messageSettingsParam != null) {
            String waitMessage = (String) messageSettingsParam.get("waitMessage");
            String fitTheDocumentMessage = (String) messageSettingsParam.get("fitTheDocumentMessage");
            String holdItMessage = (String) messageSettingsParam.get("holdItMessage");
            String verifyingQualityMessage = (String) messageSettingsParam.get("verifyingQualityMessage");
            String lowQualityDocumentMessage = (String) messageSettingsParam.get("lowQualityDocumentMessage");
            String uploadingImageMessage = (String) messageSettingsParam.get("uploadingImageMessage");
            String openDocumentWrongMessage = (String) messageSettingsParam.get("openDocumentWrongMessage");
            String unsupportedDocumentMessage = (String) messageSettingsParam.get("unsupportedDocumentMessage");
            String documentNotFoundMessage = (String) messageSettingsParam.get("documentNotFoundMessage");
            String sensorLuminosityMessage = (String) messageSettingsParam.get("sensorLuminosityMessage");
            String sensorOrientationMessage = (String) messageSettingsParam.get("sensorOrientationMessage");
            String sensorStabilityMessage = (String) messageSettingsParam.get("sensorStabilityMessage");
            String popupDocumentSubtitleMessage = (String) messageSettingsParam.get("popupDocumentSubtitleMessage");
            String positiveButtonMessage = (String) messageSettingsParam.get("positiveButtonMessage");

            Document.RG_FRONT.wrongDocumentFoundMessage = (String) messageSettingsParam
                    .get("wrongDocumentMessage_RG_FRONT");
            Document.RG_BACK.wrongDocumentFoundMessage = (String) messageSettingsParam
                    .get("wrongDocumentMessage_RG_BACK");
            Document.RG_FULL.wrongDocumentFoundMessage = (String) messageSettingsParam
                    .get("wrongDocumentMessage_RG_FULL");
            Document.CNH_FRONT.wrongDocumentFoundMessage = (String) messageSettingsParam
                    .get("wrongDocumentMessage_CNH_FRONT");
            Document.CNH_BACK.wrongDocumentFoundMessage = (String) messageSettingsParam
                    .get("wrongDocumentMessage_CNH_BACK");
            Document.CNH_FULL.wrongDocumentFoundMessage = (String) messageSettingsParam
                    .get("wrongDocumentMessage_CNH_FULL");
            Document.CRLV.wrongDocumentFoundMessage = (String) messageSettingsParam.get("wrongDocumentMessage_CRLV");
            Document.RNE_FRONT.wrongDocumentFoundMessage = (String) messageSettingsParam
                    .get("wrongDocumentMessage_RNE_FRONT");
            Document.RNE_BACK.wrongDocumentFoundMessage = (String) messageSettingsParam
                    .get("wrongDocumentMessage_RNE_BACK");

            MessageSettings messageSettings = new MessageSettings(
                    waitMessage,
                    fitTheDocumentMessage,
                    holdItMessage,
                    verifyingQualityMessage,
                    lowQualityDocumentMessage,
                    uploadingImageMessage,
                    openDocumentWrongMessage,
                    unsupportedDocumentMessage,
                    documentNotFoundMessage,
                    sensorLuminosityMessage,
                    sensorOrientationMessage,
                    sensorStabilityMessage,
                    popupDocumentSubtitleMessage,
                    positiveButtonMessage,
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "");

            mDocumentDetectorBuilder.setMessageSettings(messageSettings);
        }

        HashMap<String, Object> uploadSettingsParam = (HashMap<String, Object>) argumentsMap.get("uploadSettings");
        if (uploadSettingsParam != null) {
            UploadSettings uploadSettings = new UploadSettings();

            Integer activityLayout = getResourceId((String) uploadSettingsParam.get("activityLayout"), LAYOUT_RES);
            Integer popUpLayout = getResourceId((String) uploadSettingsParam.get("popUpLayout"), LAYOUT_RES);
            Boolean compress = (Boolean) uploadSettingsParam.get("compress");
            ArrayList<String> fileFormatsParam = (ArrayList<String>) uploadSettingsParam.get("fileFormats");
            Integer maxFileSize = (Integer) uploadSettingsParam.get("maxFileSize");
            String intent = (String) uploadSettingsParam.get("intent");

            if (compress != null) {
                uploadSettings.setCompress(compress);
            }
            if (intent != null) {
                uploadSettings.setIntent(intent);
            }
            if (maxFileSize != null) {
                uploadSettings.setMaxFileSize(maxFileSize);
            }
            if (popUpLayout != null) {
                uploadSettings.setPopUpLayout(popUpLayout);
            }
            if (activityLayout != null) {
                uploadSettings.setActivityLayout(activityLayout);
            }
            if (fileFormatsParam != null) {
                FileFormat[] fileFormats = new FileFormat[fileFormatsParam.size()];
                for (int i = 0; i < fileFormats.length; i++) {
                    FileFormat fileFormat = FileFormat.valueOf(fileFormatsParam.get(i));
                    if (fileFormat != null)
                        fileFormats[i] = fileFormat;
                }
                uploadSettings.setFileFormats(fileFormats);
            }

            mDocumentDetectorBuilder.setUploadSettings(uploadSettings);
        }

        // Android specific settings
        HashMap<String, Object> androidSettings = (HashMap<String, Object>) argumentsMap.get("androidSettings");
        if (androidSettings != null) {

            // Capture stages
            ArrayList<HashMap<String, Object>> paramStages = (ArrayList<HashMap<String, Object>>) androidSettings
                    .get("captureStages");
            if (paramStages != null) {
                CaptureStage[] captureStages = new CaptureStage[paramStages.size()];
                for (int i = 0; i < paramStages.size(); i++) {
                    HashMap<String, Object> stage = paramStages.get(i);

                    Long durationMillis = ((Number) stage.get("durationMillis")).longValue();

                    Boolean wantSensorCheck = (Boolean) stage.get("wantSensorCheck");
                    if (wantSensorCheck == null)
                        wantSensorCheck = false;

                    QualitySettings qualitySettings = null;
                    HashMap<String, Object> qualitySettingsParam = (HashMap<String, Object>) stage
                            .get("qualitySettings");
                    if (qualitySettingsParam != null) {
                        Double threshold = (Double) qualitySettingsParam.get("threshold");
                        if (threshold == null)
                            threshold = QualitySettings.RECOMMENDED_THRESHOLD;
                        qualitySettings = new QualitySettings(threshold);
                    }

                    DetectionSettings detectionSettings = null;
                    HashMap<String, Object> detectionSettingsParam = (HashMap<String, Object>) stage
                            .get("detectionSettings");
                    if (detectionSettingsParam != null) {
                        Double threshold = (Double) detectionSettingsParam.get("threshold");
                        if (threshold == null)
                            threshold = DetectionSettings.RECOMMENDED_THRESHOLD;
                        Integer consecutiveFrames = (Integer) detectionSettingsParam.get("consecutiveFrames");
                        if (consecutiveFrames == null)
                            consecutiveFrames = 5;
                        detectionSettings = new DetectionSettings(threshold, consecutiveFrames);
                    }
                    CaptureMode captureMode = CaptureMode.valueOf((String) stage.get("captureMode"));

                    captureStages[i] = new CaptureStage(durationMillis, wantSensorCheck, qualitySettings,
                            detectionSettings, captureMode);
                }
                mDocumentDetectorBuilder.setCaptureStages(captureStages);
            }

            // Layout customization
            HashMap<String, Object> customizationAndroid = (HashMap<String, Object>) androidSettings
                    .get("customization");
            if (customizationAndroid != null) {
                Integer styleId = getResourceId((String) customizationAndroid.get("styleResIdName"), STYLE_RES);
                if (styleId != null)
                    mDocumentDetectorBuilder.setStyle(styleId);

                Integer layoutId = getResourceId((String) customizationAndroid.get("layoutResIdName"), LAYOUT_RES);
                if (layoutId != null) {
                    mDocumentDetectorBuilder.setLayout(layoutId);
                }

                Integer greenMaskId = getResourceId((String) customizationAndroid.get("greenMaskResIdName"),
                        DRAWABLE_RES);
                Integer whiteMaskId = getResourceId((String) customizationAndroid.get("whiteMaskResIdName"),
                        DRAWABLE_RES);
                Integer redMaskId = getResourceId((String) customizationAndroid.get("redMaskResIdName"), DRAWABLE_RES);
                mDocumentDetectorBuilder.setLayout(layoutId);

                mDocumentDetectorBuilder.setMask(greenMaskId, whiteMaskId, redMaskId);

                String maskType = (String) customizationAndroid.get("maskType");
                if (maskType != null) {
                    System.out.println("Mask: ");
                    mDocumentDetectorBuilder.setMask(MaskType.valueOf(maskType));
                }
            }

            if (androidSettings.get("enableSwitchCameraButton") != null) {
                boolean enableSwitchCameraButton = (boolean) androidSettings.get("enableSwitchCameraButton");
                mDocumentDetectorBuilder.enableSwitchCameraButton(enableSwitchCameraButton);
            }

            if (androidSettings.get("enableGoogleServices") != null) {
                boolean enableGoogleServices = (boolean) androidSettings.get("enableGoogleServices");
                mDocumentDetectorBuilder.enableGoogleServices(enableGoogleServices);
            }

            if (androidSettings.get("enableEmulator") != null) {
                boolean enableEmulator = (boolean) androidSettings.get("enableEmulator");
                mDocumentDetectorBuilder.setUseEmulator(enableEmulator);

            }
            if (androidSettings.get("enableRootDevices") != null) {
                boolean enableRootDevices = (boolean) androidSettings.get("enableRootDevices");
                mDocumentDetectorBuilder.setUseRoot(enableRootDevices);
            }

            if (androidSettings.get("useDeveloperMode") != null) {
                Boolean useDeveloperMode = (Boolean) androidSettings.get("useDeveloperMode");
                mDocumentDetectorBuilder.setUseDeveloperMode(useDeveloperMode);
            }

            if (androidSettings.get("useAdb") != null) {
                Boolean useAdb = (Boolean) androidSettings.get("useAdb");
                mDocumentDetectorBuilder.setUseAdb(useAdb);
            }

            if (androidSettings.get("useDebug") != null) {
                Boolean useDebug = (Boolean) androidSettings.get("useDebug");
                mDocumentDetectorBuilder.setUseDebug(useDebug);
            }

            String resolution = (String) androidSettings.get("resolution");
            if (resolution != null) {
                mDocumentDetectorBuilder.setResolutionSettings(Resolution.valueOf(resolution));
            }

            // Sensor settings
            HashMap<String, Object> sensorSettings = (HashMap<String, Object>) androidSettings.get("sensorSettings");
            if (sensorSettings != null) {
                HashMap<String, Object> sensorLuminosity = (HashMap<String, Object>) sensorSettings
                        .get("sensorLuminositySettings");
                if (sensorLuminosity != null) {
                    Integer luminosityThreshold = (Integer) sensorLuminosity.get("luminosityThreshold");
                    if (luminosityThreshold != null) {
                        mDocumentDetectorBuilder.setLuminositySensorSettings(
                                new SensorLuminositySettings(luminosityThreshold));
                    }
                } else {
                    mDocumentDetectorBuilder.setLuminositySensorSettings(null);
                }

                if (androidSettings.get("compressQuality") != null) {
                    int compressQuality = (int) androidSettings.get("compressQuality");
                    mDocumentDetectorBuilder.setCompressSettings(compressQuality);
                }

                HashMap<String, Object> sensorOrientation = (HashMap<String, Object>) sensorSettings
                        .get("sensorOrientationSettings");
                if (sensorOrientation != null) {
                    Double orientationThreshold = (Double) sensorOrientation.get("orientationThreshold");
                    if (orientationThreshold != null) {
                        mDocumentDetectorBuilder.setOrientationSensorSettings(
                                new SensorOrientationSettings(orientationThreshold));
                    }
                } else {
                    mDocumentDetectorBuilder.setOrientationSensorSettings(null);
                }

                HashMap<String, Object> sensorStability = (HashMap<String, Object>) sensorSettings
                        .get("sensorStabilitySettings");
                if (sensorStability != null) {
                    Integer stabilityStabledMillis = (Integer) sensorStability.get("stabilityStabledMillis");
                    Double stabilityThreshold = (Double) sensorStability.get("stabilityThreshold");
                    if (stabilityStabledMillis != null && stabilityThreshold != null) {
                        mDocumentDetectorBuilder.setStabilitySensorSettings(
                                new SensorStabilitySettings(stabilityStabledMillis, stabilityThreshold));
                    }
                } else {
                    mDocumentDetectorBuilder.setStabilitySensorSettings(null);
                }
            }
        }

        // Popup settings
        Boolean showPopup = (Boolean) argumentsMap.get("popup");
        if (showPopup != null)
            mDocumentDetectorBuilder.setPopupSettings(showPopup);

        // Sound settings
        Boolean enableSound = (Boolean) argumentsMap.get("sound");
        if (enableSound != null)
            mDocumentDetectorBuilder.setAudioSettings(enableSound);

        // Network settings
        Integer requestTimeout = (Integer) argumentsMap.get("requestTimeout");
        if (requestTimeout != null)
            mDocumentDetectorBuilder.setNetworkSettings(requestTimeout);

        // AutoDetection
        Boolean autoDetectionEnable = (Boolean) argumentsMap.get("autoDetection");
        if (autoDetectionEnable != null)
            mDocumentDetectorBuilder.setAutoDetection(autoDetectionEnable);

        // CurrentStepDoneDelay
        Boolean showDelay = (Boolean) argumentsMap.get("showDelay");
        if (showDelay != null) {
            if (argumentsMap.get("delay") != null) {
                int delay = (int) argumentsMap.get("delay");
                mDocumentDetectorBuilder.setCurrentStepDoneDelay(showDelay, delay);
            }
        }

        Intent mIntent = new Intent(context, DocumentDetectorActivity.class);
        mIntent.putExtra(DocumentDetector.PARAMETER_NAME, mDocumentDetectorBuilder.build());
        activity.startActivityForResult(mIntent, REQUEST_CODE);
    }

    private Integer getResourceId(@Nullable String resourceName, String resourceType) {
        if (resourceName == null || activity == null)
            return null;
        int resId = activity.getResources().getIdentifier(resourceName, resourceType, activity.getPackageName());
        return resId == 0 ? null : resId;
    }

    private HashMap<String, Object> getSucessResponseMap(DocumentDetectorResult mDocumentDetectorResult) {
        HashMap<String, Object> responseMap = new HashMap<>();
        responseMap.put("success", Boolean.TRUE);
        ArrayList<HashMap<String, Object>> captures = new ArrayList<>();
        for (Capture capture : mDocumentDetectorResult.getCaptures()) {
            HashMap<String, Object> captureResponse = new HashMap<>();
            captureResponse.put("imagePath", capture.getImagePath());
            captureResponse.put("imageUrl", capture.getImageUrl());
            captureResponse.put("label", capture.getLabel());
            captureResponse.put("quality", capture.getQuality());
            captures.add(captureResponse);
        }
        responseMap.put("captures", captures);
        responseMap.put("type", mDocumentDetectorResult.getType());
        responseMap.put("trackingId", mDocumentDetectorResult.getTrackingId());
        return responseMap;
    }

    private HashMap<String, Object> getFailureResponseMap(SDKFailure sdkFailure) {
        HashMap<String, Object> responseMap = new HashMap<>();
        responseMap.put("success", Boolean.FALSE);
        responseMap.put("message", sdkFailure.getMessage());
        responseMap.put("code", sdkFailure.getCode());
        responseMap.put("type", sdkFailure.getClass().getSimpleName());
        return responseMap;
    }

    private HashMap<String, Object> getClosedResponseMap() {
        HashMap<String, Object> responseMap = new HashMap<>();
        responseMap.put("success", null);
        return responseMap;
    }

    @Override
    public synchronized boolean onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        if (requestCode == REQUEST_CODE) {
            if (resultCode == Activity.RESULT_OK && data != null) {
                DocumentDetectorResult mDocumentDetectorResult = (DocumentDetectorResult) data
                        .getSerializableExtra(DocumentDetectorResult.PARAMETER_NAME);
                if (mDocumentDetectorResult.wasSuccessful()) {
                    if (result != null) {
                        result.success(getSucessResponseMap(mDocumentDetectorResult));
                        result = null;
                    }
                } else {
                    if (result != null) {
                        result.success(getFailureResponseMap(mDocumentDetectorResult.getSdkFailure()));
                        result = null;
                    }
                }
            } else {
                if (result != null) {
                    result.success(getClosedResponseMap());
                    result = null;
                }
            }
        }
        return false;
    }

    @Override
    public synchronized void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        this.context = flutterPluginBinding.getApplicationContext();
        this.channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "document_detector");
        this.channel.setMethodCallHandler(this);
    }

    @Override
    public synchronized void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        this.channel.setMethodCallHandler(null);
        this.context = null;
    }

    @Override
    public synchronized void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        this.activity = binding.getActivity();
        this.activityBinding = binding;
        this.activityBinding.addActivityResultListener(this);
    }

    @Override
    public synchronized void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public synchronized void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        this.activity = binding.getActivity();
    }

    @Override
    public synchronized void onDetachedFromActivity() {
        this.activity = null;
        this.activityBinding.removeActivityResultListener(this);
        this.activityBinding = null;
    }
}
