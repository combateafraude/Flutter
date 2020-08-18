package com.combateafraude.face_authenticator;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import androidx.annotation.NonNull;

import com.combateafraude.faceauthenticator.FaceAuthenticator;
import com.combateafraude.faceauthenticator.FaceAuthenticatorActivity;
import com.combateafraude.faceauthenticator.FaceAuthenticatorResult;
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
 * ActivefaceLivenessSdkPlugin
 */
public class FaceAuthenticatorPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {
    private static final String DEBUG_NAME = "ActiveFaceSdk";
    private Activity activity;
    private Context context;
    private ActivityPluginBinding activityBinding;

    private MethodChannel methodChannel;
    private MethodChannel.Result pendingResult;

    private static final String MESSAGE_CHANNEL = "com.combateafraude.face_authenticator/message";

    private static final int REQUEST_CODE_FACE_AUTHENTICATOR = 20991;

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

        FaceAuthenticatorPlugin plugin = new FaceAuthenticatorPlugin();
        plugin.setupChannels(registrar.messenger(), registrar.activity().getApplicationContext());
        plugin.setActivity(registrar.activity());
        registrar.addActivityResultListener(plugin);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        Log.d(DEBUG_NAME, "onDetachedFromEngine");
        teardownChannels();
    }

    private void setupChannels(BinaryMessenger messenger, Context context) {
        Log.d(DEBUG_NAME, "setupChannels");
        this.context = context;
        methodChannel = new MethodChannel(messenger, MESSAGE_CHANNEL);
        methodChannel.setMethodCallHandler(this);
    }

    private void setActivity(Activity activity) {
        this.activity = activity;
    }

    private void teardownChannels() {
        Log.d(DEBUG_NAME, "teardownChannels");
        this.activity = null;
        this.activityBinding.removeActivityResultListener(this);
        this.activityBinding = null;
        this.context = null;
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        Log.d(DEBUG_NAME, "onAttachedToActivity");
        this.activityBinding = binding;
        setActivity(binding.getActivity());
        this.activityBinding.addActivityResultListener(this);
    }

    @Override
    public void onDetachedFromActivity() {
        Log.d(DEBUG_NAME, "onDetachedFromActivity");
        teardownChannels();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        Log.d(DEBUG_NAME, "onDetachedFromActivityForConfigChanges");
        onDetachedFromActivity();
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        Log.d(DEBUG_NAME, "onReattachedToActivityForConfigChanges");
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

        String mobileToken = (String) argsMap.get("mobileToken");
        Boolean hasSound = (Boolean) argsMap.get("hasSound");
        Integer requestTimeout = (Integer) argsMap.get("requestTimeout");
        String cpf = (String) argsMap.get("cpf");

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

        FaceAuthenticator.Builder mFaceAuthenticatorBuilder = new FaceAuthenticator.Builder(mobileToken)
                .setLayout(idLayout, idGreenMask, idWhiteMask, idRedMask)
                .setPeopleId(cpf);
        if (hasSound != null) mFaceAuthenticatorBuilder.enableSound(hasSound);
        if (idStyle != null) mFaceAuthenticatorBuilder.setStyle(idStyle);
        if (requestTimeout != null) mFaceAuthenticatorBuilder.setNetworkSettings(requestTimeout);

        Intent mIntent = new Intent(context, FaceAuthenticatorActivity.class);
        mIntent.putExtra(FaceAuthenticator.PARAMETER_NAME, mFaceAuthenticatorBuilder.build());
        activity.startActivityForResult(mIntent, REQUEST_CODE_FACE_AUTHENTICATOR);
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        final Map<String, Object> response = new HashMap<>();
        if (requestCode == REQUEST_CODE_FACE_AUTHENTICATOR) {
            if (resultCode == RESULT_OK && data != null) {
                FaceAuthenticatorResult mFaceAuthenticatorResult = (FaceAuthenticatorResult) data.getSerializableExtra(FaceAuthenticatorResult.PARAMETER_NAME);
                if (mFaceAuthenticatorResult.wasSuccessful()) {
                    response.put("success", Boolean.valueOf(true));
                    response.put("authenticated", mFaceAuthenticatorResult.isAuthenticated());
                    response.put("signedResponse", mFaceAuthenticatorResult.getSignedResponse());
                } else {
                    response.put("success", Boolean.valueOf(false));
                    if (mFaceAuthenticatorResult.getSdkFailure() instanceof InvalidTokenReason) {
                        response.put("errorType", "InvalidTokenReason");
                        response.put("errorMessage", mFaceAuthenticatorResult.getSdkFailure().getMessage());
                    } else if (mFaceAuthenticatorResult.getSdkFailure() instanceof PermissionReason) {
                        response.put("errorType", "PermissionReason");
                        response.put("errorMessage", mFaceAuthenticatorResult.getSdkFailure().getMessage());
                    } else if (mFaceAuthenticatorResult.getSdkFailure() instanceof NetworkReason) {
                        response.put("errorType", "NetworkReason");
                        response.put("errorMessage", mFaceAuthenticatorResult.getSdkFailure().getMessage());
                    } else if (mFaceAuthenticatorResult.getSdkFailure() instanceof ServerReason) {
                        response.put("errorType", "ServerReason");
                        response.put("errorCode", ((ServerReason) mFaceAuthenticatorResult.getSdkFailure()).getCode());
                        response.put("errorMessage", mFaceAuthenticatorResult.getSdkFailure().getMessage());
                    } else if (mFaceAuthenticatorResult.getSdkFailure() instanceof StorageReason) {
                        response.put("errorType", "StorageReason");
                        response.put("errorMessage", mFaceAuthenticatorResult.getSdkFailure().getMessage());
                    } else if (mFaceAuthenticatorResult.getSdkFailure() instanceof LibraryReason) {
                        response.put("errorType", "LibraryReason");
                        response.put("errorMessage", mFaceAuthenticatorResult.getSdkFailure().getMessage());
                    } else {
                        response.put("errorType", "SDKFailure");
                        response.put("errorMessage", mFaceAuthenticatorResult.getSdkFailure().getMessage());
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
}
