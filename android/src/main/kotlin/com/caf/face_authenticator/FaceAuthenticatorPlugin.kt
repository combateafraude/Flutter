package com.caf.face_authenticator

import android.content.Context
import android.os.Looper
import input.CafStage
import input.FaceAuthenticator
import input.VerifyAuthenticationListener
import input.iproov.Filter
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import output.FaceAuthenticatorResult
import output.failure.NetworkReason
import output.failure.ServerReason

class FaceAuthenticatorPlugin: FlutterPlugin {

    private lateinit var eventChannel: EventChannel
    private lateinit var methodChannel: MethodChannel

    private var eventSink: EventChannel.EventSink? = null
    private var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding? = null

    private val methodCallHandler = MethodChannel.MethodCallHandler { call, result ->
        val context: Context? = flutterPluginBinding?.applicationContext

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

        //FaceAuth build
        mFaceAuthenticatorBuilder.build().authenticate(context, personId, object : VerifyAuthenticationListener {
            override fun onSuccess(faceAuthResult: FaceAuthenticatorResult) {
                android.os.Handler(Looper.getMainLooper()).post {
                    eventSink?.success(getSuccessResponseMap(faceAuthResult))
                    eventSink?.endOfStream()
                }
            }

            override fun onError(faceAuthResult: FaceAuthenticatorResult) {
                android.os.Handler(Looper.getMainLooper()).post {
                    if (faceAuthResult.sdkFailure != null) {
                        eventSink?.success(getErrorResponseMap(faceAuthResult))
                    } else {
                        eventSink?.success(getFailureResponseMap(faceAuthResult))
                    }
                    eventSink?.endOfStream()
                }
            }

            override fun onCancel(faceAuthResult: FaceAuthenticatorResult) {
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

    private fun getErrorResponseMap(result: FaceAuthenticatorResult): HashMap<String, Any> {
        val responseMap = HashMap<String, Any>()
        responseMap["event"] = "error"

        if (result.sdkFailure is ServerReason) {
            responseMap["errorType"] = "ServerReason"
            responseMap["errorMessage"] = result.sdkFailure.message
            responseMap["code"] = (result.sdkFailure as ServerReason).code
        } else if (result.sdkFailure is NetworkReason) {
            responseMap["errorType"] = "NetworkReason"
            responseMap["errorMessage"] = result.sdkFailure.message
        }
        return responseMap
    }

    private fun getFailureResponseMap(result: FaceAuthenticatorResult): HashMap<String, Any> {
        val responseMap = HashMap<String, Any>()
        responseMap["event"] = "failure"
        responseMap["errorMessage"] = result.errorMessage
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

        eventChannel = EventChannel(flutterPluginBinding!!.binaryMessenger, "liveness_listener")
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