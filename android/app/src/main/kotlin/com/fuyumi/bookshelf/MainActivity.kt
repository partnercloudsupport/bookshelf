package com.fuyumi.bookshelf

import android.os.Bundle

import android.view.WindowManager
import android.app.Application
import android.app.Activity
import io.flutter.app.FlutterActivity
import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity() : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        MethodChannel(getFlutterView(), "bookshelf.fuyumi.com/screen").setMethodCallHandler(
                { methodCall, result ->
                    when (methodCall.method) {
                        "activateKeepScreenOn" -> {
                            getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                            result.success(null)
                        }
                        "deactivateKeepScreenOn" -> {
                            getWindow().clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                            result.success(null)
                        }
                        else -> result.notImplemented()
                    }
                }
        )

        GeneratedPluginRegistrant.registerWith(this)
    }
}
