package com.combateafraude.address_check;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.location.Address;
import android.os.Build;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.combateafraude.addresscheck.external.AddressCheck;
import com.combateafraude.addresscheck.external.AddressCollection;
import com.combateafraude.addresscheck.external.failure.SDKFailure;

import java.util.HashMap;
import java.util.Locale;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;

@SuppressWarnings("unchecked")
public class AddressCheckPlugin implements FlutterPlugin, MethodCallHandler {

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
    String mobileToken;

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

    @TargetApi(Build.VERSION_CODES.DONUT)
    private synchronized void start(@NonNull MethodCall call) {
        AddressCheck.init(context);
        HashMap<String, Object> argumentsMap = (HashMap<String, Object>) call.arguments;
        Address address = new Address(new Locale("pt", "BR"));

        // Mobile token
        mobileToken = (String) argumentsMap.get("mobileToken");
        AddressCheck.Builder mAddressCheck = new AddressCheck.Builder(mobileToken);

        // People ID
        String peopleId = (String) argumentsMap.get("peopleId");
        mAddressCheck.setPeopleId(peopleId);

        // Use Analytics
        Boolean useAnalytics = (Boolean) argumentsMap.get("useAnalytics");
        if (useAnalytics != null) mAddressCheck.setAnalyticsSettings(useAnalytics);

        // Network settings
        Integer requestTimeout = (Integer) argumentsMap.get("requestTimeout");
        if (requestTimeout != null) mAddressCheck.setNetworkSettings(requestTimeout);

        HashMap<String, Object> addressMap = (HashMap<String, Object>) argumentsMap.get("address");
        if (addressMap != null) {
            String countryName = (String) addressMap.get("countryName");
            String countryCode = (String) addressMap.get("countryCode");
            String adminArea = (String) addressMap.get("adminArea");
            String subAdminArea = (String) addressMap.get("subAdminArea");
            String locality = (String) addressMap.get("locality");
            String subLocality = (String) addressMap.get("subLocality");
            String thoroughfare = (String) addressMap.get("thoroughfare");
            String subThoroughfare = (String) addressMap.get("subThoroughfare");
            String postalCode = (String) addressMap.get("postalCode");
            address.setCountryName(countryName);
            address.setCountryCode(countryCode);
            address.setAdminArea(adminArea);
            address.setSubAdminArea(subAdminArea);
            address.setLocality(locality);
            address.setSubLocality(subLocality);
            address.setThoroughfare(thoroughfare);
            address.setSubThoroughfare(subThoroughfare);
            address.setPostalCode(postalCode);
        }

        AddressCheck addressCheck = mAddressCheck.build();
        //28700710008
        AddressCollection mAddressCollection = new AddressCollection(addressCheck, context);
        mAddressCollection.setAddress(address, new AddressCollection.Callback() {
            @Override
            public void onSuccess(String userId) {
                return;
                // o endereço foi atribuído com sucesso e o userId será usado para verificar o status atual da verificação
            }

            @Override
            public void onFailure(SDKFailure sdkFailure) {
                System.out.println("fail");
                System.out.println(sdkFailure.toString());
                System.out.println(sdkFailure.getMessage());
            }
        });
        result.success(getSucessResponseMap());
        return;
    }

    public AddressCheck getAddressCheck(String cpf) {
        return new AddressCheck.Builder(mobileToken)
                .setPeopleId(cpf)
                .build();
    }

    private HashMap<String, Object> getSucessResponseMap() {
        HashMap<String, Object> responseMap = new HashMap<>();
        responseMap.put("success", Boolean.TRUE);
        responseMap.put("last_activity_ts","s");
        responseMap.put("installations", "a");
        responseMap.put("address_verification","e");
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

   /* @Override
    public synchronized boolean onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        if (requestCode == REQUEST_CODE) {
            if (resultCode == Activity.RESULT_OK && data != null) {
                /*AddressCheckResult mAddressCheckResult = (AddressCheckResult) data.getSerializableExtra(AddressCheckResult.PARAMETER_NAME);
                if (mAddressCheckResult.wasSuccessful()) {
                    if (result != null) {
                        result.success(getSucessResponseMap(mAddressCheckResult));
                        result = null;
                    }
                } else {
                    if (result != null) {
                        result.success(getFailureResponseMap(mAddressCheckResult.getSdkFailure()));
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
    }*/

    @Override
    public synchronized void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        this.context = flutterPluginBinding.getApplicationContext();
        this.channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "address_check");
        this.channel.setMethodCallHandler(this);
    }

    @Override
    public synchronized void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        this.channel.setMethodCallHandler(null);
        this.context = null;
    }
/*
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
    }*/
}
