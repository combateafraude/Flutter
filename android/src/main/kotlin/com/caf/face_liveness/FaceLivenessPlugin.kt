package com.caf.face_liveness

import android.content.Context
import android.os.Looper
import com.caf.facelivenessiproov.input.CAFStage
import com.caf.facelivenessiproov.input.FaceLiveness
import com.caf.facelivenessiproov.input.Time
import com.caf.facelivenessiproov.input.VerifyLivenessListener
import com.caf.facelivenessiproov.input.iproov.Filter
import com.caf.facelivenessiproov.output.FaceLivenessResult
import com.caf.facelivenessiproov.output.failure.SDKFailure
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class FaceLivenessPlugin: FlutterPlugin {

    private lateinit var eventChannel: EventChannel
    private lateinit var methodChannel: MethodChannel

    private var eventSink: EventChannel.EventSink? = null
    private var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding? = null

    private val methodCallHandler =
        MethodChannel.MethodCallHandler { call, result ->
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

        val mFaceLivenessBuilder = FaceLiveness.Builder(mobileToken)

        // Stage
        val stage = argumentsMap["stage"] as String?
        if (stage != null) {
            mFaceLivenessBuilder.setStage(CAFStage.valueOf(stage))
        }

        // Filter
        val filter = argumentsMap["filter"] as String?
        if (filter != null) {
            mFaceLivenessBuilder.setFilter(Filter.valueOf(filter))
        }

        // Enable Screenshot
        val enableScreenshot = argumentsMap["enableScreenshot"] as Boolean?
        if (enableScreenshot != null) {
            mFaceLivenessBuilder.setEnableScreenshots(enableScreenshot)
        }

        // Enable SDK default loading screen
        val enableLoadingScreen = argumentsMap["enableLoadingScreen"] as Boolean?
        if (enableLoadingScreen != null) {
            mFaceLivenessBuilder.setLoadingScreen(enableLoadingScreen)
        }

        // Customize the image URL Expiration Time
        val imageUrlExpirationTime = argumentsMap["imageUrlExpirationTime"] as String?
        if (imageUrlExpirationTime != null) {
            mFaceLivenessBuilder.setImageUrlExpirationTime(Time.valueOf(imageUrlExpirationTime))
        }

        // FaceLiveness build
        mFaceLivenessBuilder.build().startSDK(context, personId, object : VerifyLivenessListener {
            override fun onSuccess(faceLivenessResult: FaceLivenessResult) {
                android.os.Handler(Looper.getMainLooper()).post {
                    eventSink?.success(getSuccessResponseMap(faceLivenessResult))
                    eventSink?.endOfStream()
                }
            }

            override fun onError(sdkFailure: SDKFailure) {
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

    private fun getSuccessResponseMap(result: FaceLivenessResult): HashMap<String, Any> {
        val responseMap = HashMap<String, Any>()
        responseMap["event"] = "success"
        responseMap["signedResponse"] = result.signedResponse
        return responseMap
    }

    private fun getErrorResponseMap(result: SDKFailure): HashMap<String, Any> {
        val responseMap = HashMap<String, Any>()
        responseMap["event"] = "error"
        responseMap["errorType"] = result.errorType.value
        responseMap["errorDescription"] = result.description
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

        methodChannel = MethodChannel(flutterPluginBinding!!.binaryMessenger, "face_liveness");
        methodChannel.setMethodCallHandler(methodCallHandler)

        eventChannel = EventChannel(flutterPluginBinding!!.binaryMessenger, "face_liveness_listener")
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