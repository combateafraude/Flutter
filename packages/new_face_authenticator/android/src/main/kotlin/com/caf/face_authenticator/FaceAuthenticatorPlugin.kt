package com.caf.face_authenticator

import android.content.Context
import android.os.Looper
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import input.CafStage
import input.iproov.Filter
import input.FaceAuthenticator
import input.Time
import output.FaceAuthenticatorResult
import input.VerifyAuthenticationListener
import output.FaceAuthenticatorErrorResult

class FaceAuthenticatorPlugin: FlutterPlugin {

    private lateinit var eventChannel: EventChannel
    private lateinit var methodChannel: MethodChannel

    private var eventSink: EventChannel.EventSink? = null
    private var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding? = null

    private val methodCallHandler = MethodChannel.MethodCallHandler { call, result ->
        if (call.method == "start") {
            start(call)
        } else {
            result.notImplemented()
        }
    }

    private fun start(call: MethodCall) {
        val context: Context? = flutterPluginBinding?.applicationContext

        val argumentsMap = call.arguments as HashMap<*, *>

        // Mobile token
        val mobileToken = argumentsMap["mobileToken"] as String?
        // PersonID
        val personId = argumentsMap["personId"] as String?

        val mFaceAuthenticatorBuilder = FaceAuthenticator.Builder(mobileToken)

        // Stage
        val stage = argumentsMap["stage"] as String?
        if (stage != null) {
            mFaceAuthenticatorBuilder.setStage(CafStage.valueOf(stage))
        }

        // Filter
        val filter = argumentsMap["filter"] as String?
        if (filter != null) {
            mFaceAuthenticatorBuilder.setFilter(Filter.valueOf(filter))
        }

        // Enable Screenshot
        val enableScreenshot = argumentsMap["enableScreenshot"] as Boolean?
        if (enableScreenshot != null) {
            mFaceAuthenticatorBuilder.setEnableScreenshots(enableScreenshot)
        }

        // Enable SDK default loading screen
        val enableLoadingScreen = argumentsMap["enableLoadingScreen"] as Boolean?
        if (enableLoadingScreen != null) {
            mFaceAuthenticatorBuilder.setLoadingScreen(enableLoadingScreen)
        }

        // Customize the image URL Expiration Time
        val imageUrlExpirationTime = argumentsMap["imageUrlExpirationTime"] as String?
        if (imageUrlExpirationTime != null) {
            mFaceAuthenticatorBuilder.setImageUrlExpirationTime(Time.valueOf(imageUrlExpirationTime))
        }

        //FaceAuth build
        mFaceAuthenticatorBuilder.build().authenticate(context, personId, object : VerifyAuthenticationListener {
            override fun onSuccess(faceAuthResult: FaceAuthenticatorResult) {
                android.os.Handler(Looper.getMainLooper()).post {
                    eventSink?.success(getSuccessResponseMap(faceAuthResult))
                    eventSink?.endOfStream()
                }
            }

            override fun onError(sdkFailure: FaceAuthenticatorErrorResult) {
                android.os.Handler(Looper.getMainLooper()).post {
                    eventSink?.success(getErrorResponseMap(sdkFailure))
                    eventSink?.endOfStream()
                }
            }


            override fun onCancel() {
                android.os.Handler(Looper.getMainLooper()).post {
                    eventSink?.success(getClosedResponseMap())
                    eventSink?.endOfStream()
                }
            }

            override fun onLoading() {
                android.os.Handler(Looper.getMainLooper()).post {
                    eventSink?.success(getConnectingResponseMap())
                }
            }

            override fun onLoaded() {
                android.os.Handler(Looper.getMainLooper()).post {
                    eventSink?.success(getConnectedResponseMap())
                }
            }

        })
    }

    private fun getSuccessResponseMap(result: FaceAuthenticatorResult): HashMap<String, Any> {
        val responseMap = HashMap<String, Any>()
        responseMap["event"] = "success"
        responseMap["signedResponse"] = result.signedResponse
        return responseMap
    }

    private fun getErrorResponseMap(sdkFailure: FaceAuthenticatorErrorResult): HashMap<String, Any> {
        val responseMap = HashMap<String, Any>()
        responseMap["event"] = "error"
        responseMap["errorType"] = sdkFailure.errorType.value
        responseMap["errorDescription"] = sdkFailure.description

        return responseMap
    }

    private fun getClosedResponseMap(): HashMap<String, Any> {
        val responseMap = HashMap<String, Any>()
        responseMap["event"] = "canceled"
        return responseMap
    }

    private fun getConnectingResponseMap(): HashMap<String, Any> {
        val responseMap = HashMap<String, Any>()
        responseMap["event"] = "connecting"
        return responseMap
    }

    private fun getConnectedResponseMap(): HashMap<String, Any> {
        val responseMap = HashMap<String, Any>()
        responseMap["event"] = "connected"
        return responseMap
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        this.flutterPluginBinding = binding

        methodChannel = MethodChannel(flutterPluginBinding!!.binaryMessenger, "face_authenticator")
        methodChannel.setMethodCallHandler(methodCallHandler)

        eventChannel = EventChannel(flutterPluginBinding!!.binaryMessenger, "face_auth_listener")
        eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                eventSink = events
            }

            override fun onCancel(arguments: Any?) {
                eventSink = null
            }
        })
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
        this.flutterPluginBinding = null
    }
}