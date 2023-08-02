package com.combateafraude.passive_face_liveness;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

import com.caf.facelivenessiproov.input.CAFStage;
import com.caf.facelivenessiproov.input.FaceLiveness;
import com.caf.facelivenessiproov.input.VerifyLivenessListener;
import com.caf.facelivenessiproov.output.FaceLivenessResult;

import java.util.HashMap;

@SuppressWarnings("unchecked")
public class PassiveFaceLivenessPlugin
        implements FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {

    private static final int REQUEST_CODE = 1002;
    private MethodChannel channel;
    MethodChannel.Result result;
    private Activity activity;
    private ActivityPluginBinding activityBinding;
    private Context context;

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
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
        CAFStage cafStage = CAFStage.PROD;
        String flutterStage = (String) argumentsMap.get("stage");
        if (flutterStage != null) {
            cafStage = CAFStage.valueOf(flutterStage);
        }

        FaceLiveness faceLiveness = new FaceLiveness.Builder(mobileToken)
                .setStage(cafStage)
                .build();


        faceLiveness.startSDK(context, personId, new VerifyLivenessListener() {
        @Override
        public void onSuccess(FaceLivenessResult faceLivenessResult) {
            result.success(getSucessResponseMap(faceLivenessResult));
        }

        @Override
        public void onError(FaceLivenessResult faceLivenessResult) {
            result.success(getFailureResponseMap(faceLivenessResult));
        }

        @Override
        public void onCancel(FaceLivenessResult faceLivenessResult) {
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
        if (resourceName == null || activity == null)
            return null;
        int resId = activity.getResources().getIdentifier(resourceName, resourceType, activity.getPackageName());
        return resId == 0 ? null : resId;
    }

    private HashMap<String, Object> getSucessResponseMap(FaceLivenessResult result) {
        HashMap<String, Object> responseMap = new HashMap<>();
        responseMap.put("success", Boolean.TRUE);
        responseMap.put("signedResponse", result.getSignedResponse());

        return responseMap;
    }

    private HashMap<String, Object> getFailureResponseMap(FaceLivenessResult result) {
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

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        return false;
    }


}
