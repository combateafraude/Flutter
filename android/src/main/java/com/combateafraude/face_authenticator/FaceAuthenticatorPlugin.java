package com.combateafraude.face_authenticator;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;

import androidx.annotation.Nullable;
import androidx.annotation.NonNull;

import java.util.HashMap;

import input.CafStage;
import input.FaceAuthenticator;
import input.VerifyAuthenticationListener;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import output.FaceAuthenticatorResult;

@SuppressWarnings("unchecked")
public class FaceAuthenticatorPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {

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

        //PersonID
        String personId = (String) argumentsMap.get("personId");

        //Stage
        CafStage cafStage = CafStage.PROD;
        String flutterStage = (String) argumentsMap.get("stage");
        if (flutterStage != null) {
            cafStage = CafStage.valueOf(flutterStage);
        }

        FaceAuthenticator faceAuthenticator = new FaceAuthenticator.Builder(mobileToken)
                .setStage(cafStage)
                .build();

        faceAuthenticator.authenticate(context, personId, new VerifyAuthenticationListener() {
            @Override
            public void onSuccess(FaceAuthenticatorResult faceAuthenticatorResult) {
                result.success(getSucessResponseMap(faceAuthenticatorResult));
                
            }

            @Override
            public void onError(FaceAuthenticatorResult faceAuthenticatorResult) {
                result.success(getFailureResponseMap(faceAuthenticatorResult));
            }

            @Override
            public void onCancel(FaceAuthenticatorResult faceAuthenticatorResult) {
                result.success(getClosedResponseMap());
            }

            @Override
            public void onLoading() {

            }

            @Override
            public void onLoaded() {

            }
        });
    }

    private Integer getResourceId(@Nullable String resourceName, String resourceType) {
        if (resourceName == null || activity == null) return null;
        int resId = activity.getResources().getIdentifier(resourceName, resourceType, activity.getPackageName());
        return resId == 0 ? null : resId;
    }

    private HashMap<String, Object> getSucessResponseMap(FaceAuthenticatorResult result) {
        HashMap<String, Object> responseMap = new HashMap<>();
        responseMap.put("success", Boolean.TRUE);
        responseMap.put("isAlive", result.isAlive());
        responseMap.put("isAlive", result.isMatch());
        responseMap.put("userId", result.getUserId());

        return responseMap;
    }

    private HashMap<String, Object> getFailureResponseMap(FaceAuthenticatorResult result) {
        HashMap<String, Object> responseMap = new HashMap<>();
        responseMap.put("success", Boolean.FALSE);
        responseMap.put("errorMessage", result.getErrorMessage());
        return responseMap;
    }

    private HashMap<String, Object> getClosedResponseMap() {
        HashMap<String, Object> responseMap = new HashMap<>();
        responseMap.put("success", null);
        return responseMap;
    }

    @Override
    public synchronized boolean onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
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
