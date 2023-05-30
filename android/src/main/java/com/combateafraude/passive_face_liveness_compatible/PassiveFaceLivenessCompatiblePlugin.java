package com.combateafraude.passive_face_liveness_compatible;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.combateafraude.passivefaceliveness.PassiveFaceLivenessActivity;
import com.combateafraude.passivefaceliveness.input.CafStage;
import com.combateafraude.passivefaceliveness.input.CaptureSettings;
import com.combateafraude.passivefaceliveness.input.ImageCapture;
import com.combateafraude.passivefaceliveness.input.MessageSettings;
import com.combateafraude.passivefaceliveness.input.PassiveFaceLiveness;
import com.combateafraude.passivefaceliveness.input.PreviewSettings;
import com.combateafraude.passivefaceliveness.input.SensorOrientationSettings;
import com.combateafraude.passivefaceliveness.input.SensorStabilitySettings;
import com.combateafraude.passivefaceliveness.input.VideoCapture;
import com.combateafraude.passivefaceliveness.output.PassiveFaceLivenessResult;
import com.combateafraude.passivefaceliveness.output.failure.SDKFailure;
import com.combateafraude.passivefaceliveness.input.MaskType;

import java.util.HashMap;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;

@SuppressWarnings("unchecked")
public class PassiveFaceLivenessCompatiblePlugin
        implements FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {

    private static final int REQUEST_CODE = 1002;

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

        PassiveFaceLiveness.Builder mPassiveFaceLivenessBuilder = new PassiveFaceLiveness.Builder(mobileToken);

        // People ID
        if (argumentsMap.get("peopleId") != null) {
            String peopleId = (String) argumentsMap.get("peopleId");
            mPassiveFaceLivenessBuilder.setPersonId(peopleId);
        }

        // Person Name
        if (argumentsMap.get("personName") != null) {
            String personName = (String) argumentsMap.get("personName");
            mPassiveFaceLivenessBuilder.setPersonName(personName);
        }

        // Person CPF
        if (argumentsMap.get("personCPF") != null) {
            String personCPF = (String) argumentsMap.get("personCPF");
            mPassiveFaceLivenessBuilder.setPersonCPF(personCPF);
        }

        // Use Analytics
        Boolean useAnalytics = (Boolean) argumentsMap.get("useAnalytics");
        if (useAnalytics != null)
            mPassiveFaceLivenessBuilder.setAnalyticsSettings(useAnalytics);

        HashMap<String, Object> showPreview = (HashMap<String, Object>) argumentsMap.get("showPreview");
        if (showPreview != null) {
            String title = (String) showPreview.get("title");
            String subTitle = (String) showPreview.get("subTitle");
            String confirmLabel = (String) showPreview.get("confirmLabel");
            String retryLabel = (String) showPreview.get("retryLabel");
            boolean show = (boolean) showPreview.get("show");

            mPassiveFaceLivenessBuilder
                    .setPreviewSettings(new PreviewSettings(show, title, subTitle, confirmLabel, retryLabel));
        }

        HashMap<String, Object> previewSettings = (HashMap<String, Object>) argumentsMap.get("previewSettings");
        if (previewSettings != null) {
            String title = (String) previewSettings.get("title");
            String subTitle = (String) previewSettings.get("subTitle");
            String confirmLabel = (String) previewSettings.get("confirmLabel");
            String retryLabel = (String) previewSettings.get("retryLabel");
            boolean show = (boolean) previewSettings.get("show");

            mPassiveFaceLivenessBuilder
                    .setPreviewSettings(new PreviewSettings(show, title, subTitle, confirmLabel, retryLabel));
        }

        HashMap<String, Object> messageSettingsParam = (HashMap<String, Object>) argumentsMap.get("messageSettings");
        if (messageSettingsParam != null) {
            String stepName = (String) messageSettingsParam.get("stepName");
            String waitMessage = (String) messageSettingsParam.get("waitMessage");
            String faceNotFoundMessage = (String) messageSettingsParam.get("faceNotFoundMessage");
            String faceTooFarMessage = (String) messageSettingsParam.get("faceTooFarMessage");
            String faceTooCloseMessage = (String) messageSettingsParam.get("faceTooCloseMessage");
            String faceNotFittedMessage = (String) messageSettingsParam.get("faceNotFittedMessage");
            String multipleFaceDetectedMessage = (String) messageSettingsParam.get("multipleFaceDetectedMessage");
            String verifyingLivenessMessage = (String) messageSettingsParam.get("verifyingLivenessMessage");
            String holdItMessage = (String) messageSettingsParam.get("holdItMessage");
            String invalidFaceMessage = (String) messageSettingsParam.get("invalidFaceMessage");
            String eyesClosedMessage = (String) messageSettingsParam.get("eyesClosedMessage");
            String notCenterXMessage = (String) messageSettingsParam.get("notCenterXMessage");
            String notCenterYMessage = (String) messageSettingsParam.get("notCenterYMessage");
            String notCenterZMessage = (String) messageSettingsParam.get("notCenterZMessage");

            String sensorLuminosityMessage = (String) messageSettingsParam.get("sensorLuminosityMessage");
            String sensorOrientationMessage = (String) messageSettingsParam.get("sensorOrientationMessage");
            String sensorStabilityMessage = (String) messageSettingsParam.get("sensorStabilityMessage");
            String captureProcessingErrorMessage = (String) messageSettingsParam.get("captureProcessingErrorMessage");

            MessageSettings messageSettings = new MessageSettings(
                    stepName,
                    waitMessage,
                    faceNotFoundMessage,
                    faceTooFarMessage,
                    faceTooCloseMessage,
                    faceNotFittedMessage,
                    multipleFaceDetectedMessage,
                    verifyingLivenessMessage,
                    holdItMessage,
                    invalidFaceMessage,
                    eyesClosedMessage,
                    notCenterXMessage,
                    notCenterYMessage,
                    notCenterZMessage,
                    sensorLuminosityMessage,
                    sensorOrientationMessage,
                    sensorStabilityMessage,
                    captureProcessingErrorMessage);

            mPassiveFaceLivenessBuilder.setMessageSettings(messageSettings);
        }

        // Android specific settings
        HashMap<String, Object> androidSettings = (HashMap<String, Object>) argumentsMap.get("androidSettings");
        if (androidSettings != null) {

            // Layout customization
            HashMap<String, Object> customizationAndroid = (HashMap<String, Object>) androidSettings
                    .get("customization");
            if (customizationAndroid != null) {
                Integer styleId = getResourceId((String) customizationAndroid.get("styleResIdName"), STYLE_RES);
                if (styleId != null)
                    mPassiveFaceLivenessBuilder.setStyle(styleId);

                Integer layoutId = getResourceId((String) customizationAndroid.get("layoutResIdName"), LAYOUT_RES);
                Integer greenMask = getResourceId((String) customizationAndroid.get("greenMaskResIdName"),
                        DRAWABLE_RES);
                Integer whiteMask = getResourceId((String) customizationAndroid.get("whiteMaskResIdName"),
                        DRAWABLE_RES);
                Integer redMask = getResourceId((String) customizationAndroid.get("redMaskResIdName"), DRAWABLE_RES);
                mPassiveFaceLivenessBuilder.setLayout(layoutId);
                mPassiveFaceLivenessBuilder.setMask(greenMask, whiteMask, redMask);

                String mask = (String) customizationAndroid.get("maskType");
                if (mask != null) {
                    mPassiveFaceLivenessBuilder.setMask(MaskType.valueOf(mask));
                }
            }

            // Sensor settings
            HashMap<String, Object> sensorSettings = (HashMap<String, Object>) androidSettings.get("sensorSettings");
            if (sensorSettings != null) {
                HashMap<String, Object> sensorStability = (HashMap<String, Object>) sensorSettings
                        .get("sensorStabilitySettings");
                if (sensorStability != null) {
                    Integer stabilityStabledMillis = (Integer) sensorStability.get("stabilityStabledMillis");
                    Double stabilityThreshold = (Double) sensorStability.get("stabilityThreshold");
                    if (stabilityStabledMillis != null && stabilityThreshold != null) {
                        mPassiveFaceLivenessBuilder.setStabilitySensorSettings(
                                new SensorStabilitySettings(stabilityStabledMillis, stabilityThreshold));
                    }
                } else {
                    mPassiveFaceLivenessBuilder.setStabilitySensorSettings(null);
                }

                HashMap<String, Object> sensorOrientation = (HashMap<String, Object>) sensorSettings
                        .get("sensorOrientationAndroid");
                if (sensorOrientation != null) {
                    Double orientationThreshold = (Double) sensorOrientation.get("orientationThreshold");
                    if (orientationThreshold != null) {
                        mPassiveFaceLivenessBuilder
                                .setOrientationSensorSettings(new SensorOrientationSettings(orientationThreshold));
                    }
                }

            }

            if (androidSettings.get("showButtonTime") != null) {
                int showButtonTime = (int) androidSettings.get("showButtonTime");
                mPassiveFaceLivenessBuilder.setShowButtonTime(showButtonTime);
            }

            if (androidSettings.get("enableSwitchCameraButton") != null) {
                boolean enableSwitchCameraButton = (boolean) androidSettings.get("enableSwitchCameraButton");
                mPassiveFaceLivenessBuilder.enableSwitchCameraButton(enableSwitchCameraButton);
            }

            if (androidSettings.get("enableGoogleServices") != null) {
                boolean enableGoogleServices = (boolean) androidSettings.get("enableGoogleServices");
                mPassiveFaceLivenessBuilder.enableGoogleServices(enableGoogleServices);
            }

            if (androidSettings.get("enableEmulator") != null) {
                boolean enableEmulator = (boolean) androidSettings.get("enableEmulator");
                mPassiveFaceLivenessBuilder.setUseEmulator(enableEmulator);
            }
            if (androidSettings.get("enableRootDevices") != null) {
                boolean enableRootDevices = (boolean) androidSettings.get("enableRootDevices");
                mPassiveFaceLivenessBuilder.setUseRoot(enableRootDevices);
            }
            if (androidSettings.get("enableBrightnessIncrease") != null) {
                boolean enableBrightnessIncrease = (boolean) androidSettings.get("enableBrightnessIncrease");
                mPassiveFaceLivenessBuilder.enableBrightnessIncrease(enableBrightnessIncrease);
            }
            if (androidSettings.get("useDeveloperMode") != null) {
                Boolean useDeveloperMode = (Boolean) androidSettings.get("useDeveloperMode");
                mPassiveFaceLivenessBuilder.setUseDeveloperMode(useDeveloperMode);
            }
            if (androidSettings.get("useAdb") != null) {
                Boolean useAdb = (Boolean) androidSettings.get("useAdb");
                mPassiveFaceLivenessBuilder.setUseAdb(useAdb);
            }
            if (androidSettings.get("useDebug") != null) {
                Boolean useDebug = (Boolean) androidSettings.get("useDebug");
                mPassiveFaceLivenessBuilder.setUseDebug(useDebug);
            }

        }

        // VideoCapture
        HashMap<String, Object> videoCapture = (HashMap<String, Object>) argumentsMap.get("videoCapture");
        if (videoCapture != null) {
            boolean use = (Boolean) videoCapture.get("use");
            Integer time = (Integer) videoCapture.get("time");

            if (use) {
                if (time != null) {
                    mPassiveFaceLivenessBuilder.setCaptureSettings(new VideoCapture(time));
                } else {
                    mPassiveFaceLivenessBuilder.setCaptureSettings(new VideoCapture());
                }
            }
        }

        // ImageCapture
        HashMap<String, Object> imageCapture = (HashMap<String, Object>) argumentsMap.get("imageCapture");
        if (imageCapture != null) {
            boolean use = (Boolean) imageCapture.get("use");
            Integer afterPictureMillis = (Integer) imageCapture.get("afterPictureMillis");
            Integer beforePictureMillis = (Integer) imageCapture.get("beforePictureMillis");

            if (use) {
                if (afterPictureMillis != null && beforePictureMillis != null) {
                    mPassiveFaceLivenessBuilder
                            .setCaptureSettings(new ImageCapture(afterPictureMillis, beforePictureMillis));
                } else {
                    mPassiveFaceLivenessBuilder.setCaptureSettings(new ImageCapture());
                }
            }
        }

        // Sound settings
        Boolean enableSound = (Boolean) argumentsMap.get("enableSound");
        if (enableSound != null)
            mPassiveFaceLivenessBuilder.setAudioSettings(enableSound);

        Integer soundResId = getResourceId((String) argumentsMap.get("sound"), RAW_RES);
        if (soundResId != null)
            mPassiveFaceLivenessBuilder.setAudioSettings(soundResId);

        // CurrentStepDoneDelay
        Boolean showDelay = (Boolean) argumentsMap.get("showDelay");
        if (showDelay != null) {
            if (argumentsMap.get("delay") != null) {
                int delay = (int) argumentsMap.get("delay");
                mPassiveFaceLivenessBuilder.setCurrentStepDoneDelay(showDelay, delay);
            }
        }

        String stage = (String) argumentsMap.get("stage");
        if (stage != null) {
            mPassiveFaceLivenessBuilder.setStage(CafStage.valueOf(stage));
        }

        // Network settings
        Integer requestTimeout = (Integer) argumentsMap.get("requestTimeout");
        if (requestTimeout != null)
            mPassiveFaceLivenessBuilder.setNetworkSettings(requestTimeout);

        Intent mIntent = new Intent(context, PassiveFaceLivenessActivity.class);
        mIntent.putExtra(PassiveFaceLiveness.PARAMETER_NAME, mPassiveFaceLivenessBuilder.build());
        activity.startActivityForResult(mIntent, REQUEST_CODE);
    }

    private Integer getResourceId(@Nullable String resourceName, String resourceType) {
        if (resourceName == null || activity == null)
            return null;
        int resId = activity.getResources().getIdentifier(resourceName, resourceType, activity.getPackageName());
        return resId == 0 ? null : resId;
    }

    private HashMap<String, Object> getSucessResponseMap(PassiveFaceLivenessResult mPassiveFaceLivenessResult) {
        HashMap<String, Object> responseMap = new HashMap<>();
        responseMap.put("success", Boolean.TRUE);
        responseMap.put("imagePath", mPassiveFaceLivenessResult.getImagePath());
        responseMap.put("capturePath", mPassiveFaceLivenessResult.getCapturePath());
        responseMap.put("imageUrl", mPassiveFaceLivenessResult.getImageUrl());
        responseMap.put("signedResponse", mPassiveFaceLivenessResult.getSignedResponse());
        responseMap.put("trackingId", mPassiveFaceLivenessResult.getTrackingId());
        responseMap.put("lensFacing", mPassiveFaceLivenessResult.getLensFacing());
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
                PassiveFaceLivenessResult mPassiveFaceLivenessResult = (PassiveFaceLivenessResult) data
                        .getSerializableExtra(PassiveFaceLivenessResult.PARAMETER_NAME);
                if (mPassiveFaceLivenessResult.wasSuccessful()) {
                    if (result != null) {
                        result.success(getSucessResponseMap(mPassiveFaceLivenessResult));
                        result = null;
                    }
                } else {
                    if (result != null) {
                        result.success(getFailureResponseMap(mPassiveFaceLivenessResult.getSdkFailure()));
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
        this.channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "passive_face_liveness");
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
