package com.combateafraude.passive_face_liveness;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.combateafraude.passivefaceliveness.PassiveFaceLivenessActivity;
import com.combateafraude.passivefaceliveness.input.CaptureSettings;
import com.combateafraude.passivefaceliveness.input.PassiveFaceLiveness;
import com.combateafraude.passivefaceliveness.input.SensorStabilitySettings;
import com.combateafraude.passivefaceliveness.output.PassiveFaceLivenessResult;
import com.combateafraude.passivefaceliveness.output.failure.SDKFailure;

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
public class PassiveFaceLivenessPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {

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
        String peopleId = (String) argumentsMap.get("peopleId");
        mPassiveFaceLivenessBuilder.setPeopleId(peopleId);

        // Use Analytics
        Boolean useAnalytics = (Boolean) argumentsMap.get("useAnalytics");
        if (useAnalytics != null) mPassiveFaceLivenessBuilder.setAnalyticsSettings(useAnalytics);

        // Android specific settings
        HashMap<String, Object> androidSettings = (HashMap<String, Object>) argumentsMap.get("androidSettings");
        if (androidSettings != null) {

            // Layout customization
            HashMap<String, Object> customizationAndroid = (HashMap<String, Object>) androidSettings.get("customization");
            if (customizationAndroid != null) {
                Integer styleId = getResourceId((String) customizationAndroid.get("styleResIdName"), STYLE_RES);
                if (styleId != null) mPassiveFaceLivenessBuilder.setStyle(styleId);

                Integer layoutId = getResourceId((String) customizationAndroid.get("layoutResIdName"), LAYOUT_RES);
                Integer greenMaskId = getResourceId((String) customizationAndroid.get("greenMaskResIdName"), DRAWABLE_RES);
                Integer whiteMaskId = getResourceId((String) customizationAndroid.get("whiteMaskResIdName"), DRAWABLE_RES);
                Integer redMaskId = getResourceId((String) customizationAndroid.get("redMaskResIdName"), DRAWABLE_RES);
                mPassiveFaceLivenessBuilder.setLayout(layoutId, greenMaskId, whiteMaskId, redMaskId);
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
                        mPassiveFaceLivenessBuilder.setStabilitySensorSettings(new SensorStabilitySettings(sensorMessageId, stabilityStabledMillis, stabilityThreshold));
                    }
                } else {
                    mPassiveFaceLivenessBuilder.setStabilitySensorSettings(null);
                }
            }

            // Capture settings
            HashMap<String, Object> captureSettings = (HashMap<String, Object>) androidSettings.get("captureSettings");
            if (captureSettings != null) {
                Integer beforePictureMillis = (Integer) captureSettings.get("beforePictureMillis");
                Integer afterPictureMillis = (Integer) captureSettings.get("afterPictureMillis");
                if (beforePictureMillis != null && afterPictureMillis != null) {
                    mPassiveFaceLivenessBuilder.setCaptureSettings(new CaptureSettings(beforePictureMillis, afterPictureMillis));
                }
            }

            HashMap<String, Object> showPreview = (HashMap<String, Object>) androidSettings.get("showPreview");
            if (showPreview != null) {
                String title = (String) showPreview.get("title");
                String subTitle = (String) showPreview.get("subTitle");
                String acceptLabel = (String) showPreview.get("acceptLabel");
                String tryAgainLabel = (String) showPreview.get("tryAgainLabel");

                mPassiveFaceLivenessBuilder.showPreview(title, subTitle, acceptLabel, tryAgainLabel);
            }

            if (androidSettings.get("showButtonTime") != null){
                    int showButtonTime = (int) androidSettings.get("showButtonTime");
                    mPassiveFaceLivenessBuilder.setShowButtonTime(showButtonTime);
            }

            
            
        }

        // Sound settings
        Boolean enableSound = (Boolean) argumentsMap.get("sound");
        if (enableSound != null) mPassiveFaceLivenessBuilder.enableSound(enableSound);

        // Network settings
        Integer requestTimeout = (Integer) argumentsMap.get("requestTimeout");
        if (requestTimeout != null) mPassiveFaceLivenessBuilder.setNetworkSettings(requestTimeout);

        Intent mIntent = new Intent(context, PassiveFaceLivenessActivity.class);
        mIntent.putExtra(PassiveFaceLiveness.PARAMETER_NAME, mPassiveFaceLivenessBuilder.build());
        activity.startActivityForResult(mIntent, REQUEST_CODE);
    }

    private Integer getResourceId(@Nullable String resourceName, String resourceType) {
        if (resourceName == null || activity == null) return null;
        int resId = activity.getResources().getIdentifier(resourceName, resourceType, activity.getPackageName());
        return resId == 0 ? null : resId;
    }

    private HashMap<String, Object> getSucessResponseMap(PassiveFaceLivenessResult mPassiveFaceLivenessResult) {
        HashMap<String, Object> responseMap = new HashMap<>();
        responseMap.put("success", Boolean.TRUE);
        responseMap.put("imagePath", mPassiveFaceLivenessResult.getImagePath());
        responseMap.put("imageUrl", mPassiveFaceLivenessResult.getImageUrl());
        responseMap.put("signedResponse", mPassiveFaceLivenessResult.getSignedResponse());
        responseMap.put("trackingId", mPassiveFaceLivenessResult.getTrackingId());
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
                PassiveFaceLivenessResult mPassiveFaceLivenessResult = (PassiveFaceLivenessResult) data.getSerializableExtra(PassiveFaceLivenessResult.PARAMETER_NAME);
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
