package caf.io.liveness.face_liveness;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.HashMap;

import caf.io.faceliveness.FaceLivenessActivity;
import caf.io.faceliveness.input.FaceLiveness;
import caf.io.faceliveness.output.FaceLivenessResult;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;

/** FaceLivenessPlugin */
public class FaceLivenessPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Result result;
  private Context context;
  private Activity activity;
  private ActivityPluginBinding activityBinding;
  private static final int REQUEST_CODE = 1009;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    context = flutterPluginBinding.getApplicationContext();
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "face_liveness");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if(call.method.equals("start")) {
      this.result = result;
      start(call);
    }
  }

  private synchronized void start(@NonNull MethodCall call) {
    HashMap<String, Object> argumentsMap = (HashMap<String, Object>) call.arguments;
    String clientId = (String) argumentsMap.get("clientId");
    String clientSecret = (String) argumentsMap.get("clientSecret");
    String token = (String) argumentsMap.get("token");
    String personId = (String) argumentsMap.get("personId");

    FaceLiveness faceLiveness = new FaceLiveness(clientId, clientSecret, token, personId);
    Intent mIntent = new Intent(context, FaceLivenessActivity.class);
    mIntent.putExtra(FaceLiveness.PARAMETER_NAME, faceLiveness);
    activity.startActivityForResult(mIntent, REQUEST_CODE);
  }

  private HashMap<String, Object> getResponseMap(FaceLivenessResult faceLivenessResult) {
    HashMap<String, Object> responseMap = new HashMap<>();
    responseMap.put("responseMessage", faceLivenessResult.getResponseMessage());
    responseMap.put("image", faceLivenessResult.getImage());
    responseMap.put("sessionId", faceLivenessResult.getSessionId());
    return responseMap;
  }

  @Override
  public synchronized boolean onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
    if (requestCode == REQUEST_CODE) {
      if (resultCode == Activity.RESULT_OK && data != null) {
        FaceLivenessResult faceLivenessResult = (FaceLivenessResult) data.getSerializableExtra(FaceLiveness.PARAMETER_NAME);
        if(faceLivenessResult != null){
          result.success(getResponseMap(faceLivenessResult));
        }
      }
    }
    return false;
  }

  @Override
  public synchronized void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    this.activity = binding.getActivity();
    this.activityBinding = binding;
    this.activityBinding.addActivityResultListener(this);
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    this.activity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivity() {

  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
    context = null;
  }
}
