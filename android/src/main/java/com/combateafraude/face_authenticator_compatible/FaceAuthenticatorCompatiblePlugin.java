package com.combateafraude.face_authenticator_compatible;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import androidx.annotation.Nullable;
import androidx.annotation.NonNull;

import com.combateafraude.faceauthenticator.FaceAuthenticatorActivity;
import com.combateafraude.faceauthenticator.input.CaptureSettings;
import com.combateafraude.faceauthenticator.input.FaceAuthenticator;
import com.combateafraude.faceauthenticator.input.ImageCapture;
import com.combateafraude.faceauthenticator.input.SensorStabilitySettings;
import com.combateafraude.faceauthenticator.input.VideoCapture;
import com.combateafraude.faceauthenticator.output.FaceAuthenticatorResult;
import com.combateafraude.faceauthenticator.output.failure.SDKFailure;

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

@SuppressWarnings("unchecked")
public class FaceAuthenticatorCompatiblePlugin implements FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {

    private static final int REQUEST_CODE = 1003;

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

        // People ID
        String peopleId = (String) argumentsMap.get("peopleId");

        FaceAuthenticator.Builder mFaceAuthenticatorBuilder = new FaceAuthenticator.Builder(mobileToken);
        mFaceAuthenticatorBuilder.setPeopleId(peopleId);

        // Use Analytics
        Boolean useAnalytics = (Boolean) argumentsMap.get("useAnalytics");
        if (useAnalytics != null) mFaceAuthenticatorBuilder.setAnalyticsSettings(useAnalytics);

        // Android specific settings
        HashMap<String, Object> androidSettings = (HashMap<String, Object>) argumentsMap.get("androidSettings");
        if (androidSettings != null) {

            // Layout customization
            HashMap<String, Object> customizationAndroid = (HashMap<String, Object>) androidSettings.get("customization");
            if (customizationAndroid != null) {
                Integer styleId = getResourceId((String) customizationAndroid.get("styleResIdName"), STYLE_RES);
                if (styleId != null) mFaceAuthenticatorBuilder.setStyle(styleId);

                Integer layoutId = getResourceId((String) customizationAndroid.get("layoutResIdName"), LAYOUT_RES);
                Integer greenMaskId = getResourceId((String) customizationAndroid.get("greenMaskResIdName"), DRAWABLE_RES);
                Integer whiteMaskId = getResourceId((String) customizationAndroid.get("whiteMaskResIdName"), DRAWABLE_RES);
                Integer redMaskId = getResourceId((String) customizationAndroid.get("redMaskResIdName"), DRAWABLE_RES);
                mFaceAuthenticatorBuilder.setLayout(layoutId);
                mFaceAuthenticatorBuilder.setMask(greenMaskId, whiteMaskId, redMaskId);
            }

            // Sensor settings
            HashMap<String, Object> sensorSettings = (HashMap<String, Object>) androidSettings.get("sensorSettings");
            if (sensorSettings != null) {
                HashMap<String, Object> sensorStability = (HashMap<String, Object>) sensorSettings.get("sensorStabilitySettings");
                if (sensorStability != null) {
                    Integer sensorMessageId = getResourceId((String) sensorStability.get("messageResourceIdName"), STRING_RES);
                    Integer stabilityStabledMillis = (Integer) sensorStability.get("stabilityStabledMillis");
                    Double stabilityThreshold = (Double) sensorStability.get("stabilityThreshold");
                    if (sensorMessageId != null && stabilityStabledMillis != null && stabilityThreshold != null) {
                        mFaceAuthenticatorBuilder.setStabilitySensorSettings(new SensorStabilitySettings(sensorMessageId, stabilityStabledMillis, stabilityThreshold));
                    }
                } else {
                    mFaceAuthenticatorBuilder.setStabilitySensorSettings(null);
                }
            }

            if(androidSettings.get("enableEmulator") != null){
                boolean enableEmulator = (boolean) androidSettings.get("enableEmulator");
                mFaceAuthenticatorBuilder.setUseEmulator(enableEmulator);
            }
            if(androidSettings.get("enableRootDevices") != null){
                boolean enableRootDevices = (boolean) androidSettings.get("enableRootDevices");
                mFaceAuthenticatorBuilder.setUseRoot(enableRootDevices);
            }
            if(androidSettings.get("useDeveloperMode") != null){
                Boolean useDeveloperMode = (Boolean) androidSettings.get("useDeveloperMode");
                mFaceAuthenticatorBuilder.setUseDeveloperMode(useDeveloperMode);
            }
            if(androidSettings.get("useAdb") != null){
                Boolean useAdb = (Boolean) androidSettings.get("useAdb");
                mFaceAuthenticatorBuilder.setUseAdb(useAdb);
            }            
            if(androidSettings.get("useDebug") != null){
                Boolean useDebug = (Boolean) androidSettings.get("useDebug");
                mFaceAuthenticatorBuilder.setUseDebug(useDebug);
            }
            if(androidSettings.get("enableBrightnessIncrease") != null){
                boolean enableBrightnessIncrease = (boolean) androidSettings.get("enableBrightnessIncrease");
                mFaceAuthenticatorBuilder.enableBrightnessIncrease(enableBrightnessIncrease);
            }
            if(androidSettings.get("enableSwitchCameraButton") != null){
                boolean enableSwitchCameraButton = (boolean) androidSettings.get("enableSwitchCameraButton");
                mFaceAuthenticatorBuilder.enableSwitchCameraButton(enableSwitchCameraButton);
            }
        }


        //VideoCapture
        HashMap<String, Object> videoCapture = (HashMap<String, Object>) argumentsMap.get("videoCapture");
        if(videoCapture != null){
            boolean use = (Boolean) videoCapture.get("use");
            Integer time = (Integer) videoCapture.get("time");

            if(use){
                if(time != null){
                    mFaceAuthenticatorBuilder.setCaptureSettings(new VideoCapture(time));
                }else{
                    mFaceAuthenticatorBuilder.setCaptureSettings(new VideoCapture());
                }
            }       
        }

        //ImageCapture
        HashMap<String, Object> imageCapture = (HashMap<String, Object>) argumentsMap.get("imageCapture");
        if(imageCapture != null){
            boolean use = (Boolean) imageCapture.get("use");
            Integer afterPictureMillis = (Integer) imageCapture.get("afterPictureMillis");
            Integer beforePictureMillis = (Integer) imageCapture.get("beforePictureMillis");

            if(use){
                if(afterPictureMillis != null && beforePictureMillis != null){
                    mFaceAuthenticatorBuilder.setCaptureSettings(new ImageCapture(afterPictureMillis, beforePictureMillis));
                }else{
                    mFaceAuthenticatorBuilder.setCaptureSettings(new ImageCapture());
                }
            } 
        } 

        // Sound settings
        Boolean enableSound = (Boolean) argumentsMap.get("enableSound");
        if (enableSound != null) mFaceAuthenticatorBuilder.setAudioSettings(enableSound);

        Integer soundResId = getResourceId((String) argumentsMap.get("sound"), RAW_RES);
        if (soundResId != null) mFaceAuthenticatorBuilder.setAudioSettings(soundResId);

        // Network settings
        Integer requestTimeout = (Integer) argumentsMap.get("requestTimeout");
        if (requestTimeout != null) mFaceAuthenticatorBuilder.setNetworkSettings(requestTimeout);

        Intent mIntent = new Intent(context, FaceAuthenticatorActivity.class);
        mIntent.putExtra(FaceAuthenticator.PARAMETER_NAME, mFaceAuthenticatorBuilder.build());
        activity.startActivityForResult(mIntent, REQUEST_CODE);

        Boolean useOpenEyeValidation = (Boolean) argumentsMap.get("useOpenEyeValidation");
        if(useOpenEyeValidation != null){
            Double openEyesThreshold = (Double) argumentsMap.get("openEyesThreshold");
            if(openEyesThreshold != null){
                mFaceAuthenticatorBuilder.setEyesClosedSettings(useOpenEyeValidation, openEyesThreshold);
            }else{
                mFaceAuthenticatorBuilder.setEyesClosedSettings(useOpenEyeValidation);
            }
        } 
    }

    private Integer getResourceId(@Nullable String resourceName, String resourceType) {
        if (resourceName == null || activity == null) return null;
        int resId = activity.getResources().getIdentifier(resourceName, resourceType, activity.getPackageName());
        return resId == 0 ? null : resId;
    }

    private HashMap<String, Object> getSucessResponseMap(FaceAuthenticatorResult mFaceAuthenticatorResult) {
        HashMap<String, Object> responseMap = new HashMap<>();
        responseMap.put("success", Boolean.TRUE);
        responseMap.put("authenticated", mFaceAuthenticatorResult.isAuthenticated());
        responseMap.put("signedResponse", mFaceAuthenticatorResult.getSignedResponse());
        responseMap.put("trackingId", mFaceAuthenticatorResult.getTrackingId());
        responseMap.put("lensFacing", mFaceAuthenticatorResult.getLensFacing());
        return responseMap;
    }

    private HashMap<String, Object> getFailureResponseMap(SDKFailure sdkFailure) {
        HashMap<String, Object> responseMap = new HashMap<>();
        responseMap.put("success", Boolean.FALSE);
        responseMap.put("message", sdkFailure.getMessage());
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
                FaceAuthenticatorResult mFaceAuthenticatorResult = (FaceAuthenticatorResult) data.getSerializableExtra(FaceAuthenticatorResult.PARAMETER_NAME);
                if (mFaceAuthenticatorResult.wasSuccessful()) {
                    if (result != null) {
                        result.success(getSucessResponseMap(mFaceAuthenticatorResult));
                        result = null;
                    }
                } else {
                    if (result != null) {
                        result.success(getFailureResponseMap(mFaceAuthenticatorResult.getSdkFailure()));
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
        this.channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "face_authenticator");
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
