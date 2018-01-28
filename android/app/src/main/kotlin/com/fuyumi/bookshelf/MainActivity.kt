package com.fuyumi.bookshelf

import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import android.view.WindowManager
import android.app.Activity

class MainActivity() : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)
    }



    private fun activateKeepScreenOn(activity: Activity?) {
        if (activity != null)
            activity!!.runOnUiThread({ activity!!.getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON) })
    }

    private fun deactivateKeepScreenOn(activity: Activity?) {
        if (activity != null)
            activity!!.runOnUiThread({ activity!!.getWindow().clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON) })
    }
}
