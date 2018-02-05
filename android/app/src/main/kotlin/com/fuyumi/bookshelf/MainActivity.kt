package com.fuyumi.bookshelf

import android.os.Bundle
import android.os.Build;

import android.view.WindowManager
import android.app.Activity
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity() : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            window.statusBarColor = 0x00000000
        }

        GeneratedPluginRegistrant.registerWith(this)
    }
}
