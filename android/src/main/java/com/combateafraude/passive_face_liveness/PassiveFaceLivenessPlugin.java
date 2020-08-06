package com.combateafraude.passive_face_liveness;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import androidx.annotation.NonNull;

import com.combateafraude.helpers.sdk.failure.InvalidTokenReason;
import com.combateafraude.helpers.sdk.failure.LibraryReason;
import com.combateafraude.helpers.sdk.failure.NetworkReason;
import com.combateafraude.helpers.sdk.failure.PermissionReason;
import com.combateafraude.helpers.sdk.failure.ServerReason;
import com.combateafraude.helpers.sdk.failure.StorageReason;
import com.combateafraude.passivefaceliveness.PassiveFaceLiveness;
import com.combateafraude.passivefaceliveness.PassiveFaceLivenessActivity;
import com.combateafraude.passivefaceliveness.PassiveFaceLivenessResult;

import java.io.Serializable;
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
 * PassiveFaceLivenessPlugin
 */
public class PassiveFaceLivenessPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {
  private static final String DEBUG_NAME = "PassiveFaceSdk";
  private Activity activity;
  private Context context;
  private ActivityPluginBinding activityBinding;

  private MethodChannel methodChannel;
  private MethodChannel.Result pendingResult;

  private static final String MESSAGE_CHANNEL = "com.combateafraude.passive_face_liveness/message";

  private static final int REQUEST_CODE_PASSIVEFACE_LIVENESS = 20950;

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

    PassiveFaceLivenessPlugin plugin = new PassiveFaceLivenessPlugin();
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
    if (this.activityBinding != null) {
      this.activityBinding.removeActivityResultListener(this);
      this.activityBinding = null;
    }
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
    Boolean enableSound = (Boolean) argsMap.get("enableSound");
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

    PassiveFaceLiveness mPassiveFaceLiveness = new PassiveFaceLiveness.Builder(mobileToken)
            .setLayout(idLayout, idGreenMask, idWhiteMask, idRedMask)
            .enableSound(enableSound)
            .setStyle(idStyle)
            .setRequestTimeout(requestTimeout)
            .build();

    Intent mIntent = new Intent(context, PassiveFaceLivenessActivity.class);
    mIntent.putExtra(PassiveFaceLiveness.PARAMETER_NAME, (Serializable) mPassiveFaceLiveness);
    activity.startActivityForResult(mIntent, REQUEST_CODE_PASSIVEFACE_LIVENESS);
  }

  @Override
  public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
    final Map<String, Object> response = new HashMap<>();
    if (requestCode == REQUEST_CODE_PASSIVEFACE_LIVENESS) {
      if (resultCode == RESULT_OK && data != null) {
        PassiveFaceLivenessResult mPassiveFaceLivenessResult = (PassiveFaceLivenessResult) data.getSerializableExtra(PassiveFaceLivenessResult.PARAMETER_NAME);
        if (mPassiveFaceLivenessResult.wasSuccessful()) {
          response.put("success", Boolean.valueOf(true));
          if (mPassiveFaceLivenessResult.getImagePath() != null) {
            response.put("imagePath", mPassiveFaceLivenessResult.getImagePath());
          }
          if (mPassiveFaceLivenessResult.getImageUrl() != null) {
            response.put("imageUrl", mPassiveFaceLivenessResult.getImageUrl());
          }
          if (mPassiveFaceLivenessResult.getSignedResponse() != null) {
            response.put("signedResponse", mPassiveFaceLivenessResult.getSignedResponse());
          }
          response.put("missedAttemps", mPassiveFaceLivenessResult.getMissedAttemps());
        } else {
          response.put("success", Boolean.valueOf(false));
          if (mPassiveFaceLivenessResult.getSdkFailure() instanceof InvalidTokenReason) {
            response.put("errorType", "InvalidTokenReason");
            response.put("errorMessage", mPassiveFaceLivenessResult.getSdkFailure().getMessage());
          } else if (mPassiveFaceLivenessResult.getSdkFailure() instanceof PermissionReason) {
            response.put("errorType", "PermissionReason");
            response.put("errorMessage", mPassiveFaceLivenessResult.getSdkFailure().getMessage());
          } else if (mPassiveFaceLivenessResult.getSdkFailure() instanceof NetworkReason) {
            response.put("errorType", "NetworkReason");
            response.put("errorMessage", mPassiveFaceLivenessResult.getSdkFailure().getMessage());
          } else if (mPassiveFaceLivenessResult.getSdkFailure() instanceof ServerReason) {
            response.put("errorType", "ServerReason");
            response.put("errorCode", ((ServerReason) mPassiveFaceLivenessResult.getSdkFailure()).getCode());
            response.put("errorMessage", mPassiveFaceLivenessResult.getSdkFailure().getMessage());
          } else if (mPassiveFaceLivenessResult.getSdkFailure() instanceof StorageReason) {
            response.put("errorType", "StorageReason");
            response.put("errorMessage", mPassiveFaceLivenessResult.getSdkFailure().getMessage());
          } else if (mPassiveFaceLivenessResult.getSdkFailure() instanceof LibraryReason) {
            response.put("errorType", "LibraryReason");
            response.put("errorMessage", mPassiveFaceLivenessResult.getSdkFailure().getMessage());
          } else {
            response.put("errorType", "SDKFailure");
            response.put("errorMessage", mPassiveFaceLivenessResult.getSdkFailure().getMessage());
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
