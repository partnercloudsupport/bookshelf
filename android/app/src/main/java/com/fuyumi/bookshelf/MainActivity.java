package com.fuyumi.bookshelf;

import android.annotation.TargetApi;
import android.app.Activity;
import android.os.Build;
import android.os.Bundle;
import android.view.WindowManager;

import io.flutter.app.FlutterActivity;
import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        new MethodChannel(getFlutterView(), "bookshelf.fuyumi.com/screen").setMethodCallHandler(
                (methodCall, result) -> {
                    final Activity activity = new FlutterApplication().getCurrentActivity();
                    switch (methodCall.method) {
                        case "activateKeepScreenOn":
                            activateKeepScreenOn(activity);
                            result.success(null);
                            break;
                        case "deactivateKeepScreenOn":
                            deactivateKeepScreenOn(activity);
                            result.success(null);
                            break;
                        default:
                            result.notImplemented();
                            break;
                    }
                }
        );

        getWindow().setStatusBarColor(0x00000000);
//        getWindow().setNavigationBarColor(0xff2196F3);
        GeneratedPluginRegistrant.registerWith(this);
    }

    private void activateKeepScreenOn(Activity activity) {
        if (activity != null)
            activity.runOnUiThread(() -> activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON));
    }
    private void deactivateKeepScreenOn(Activity activity) {
        if (activity != null)
            activity.runOnUiThread(() -> activity.getWindow().clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON));
    }
}
