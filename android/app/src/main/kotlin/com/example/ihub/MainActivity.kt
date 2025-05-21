package com.example.ihub

import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.example.ihub/locktask"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        window.setFlags(
            WindowManager.LayoutParams.FLAG_FULLSCREEN,
            WindowManager.LayoutParams.FLAG_FULLSCREEN
        )

        startLockTask()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            when (call.method) {
                "stopLockTask" -> {
                    stopLockTask()
                    result.success(null)
                }
                "startLockTask" -> {
                    startLockTask()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    // ❌ Don't override onUserLeaveHint (causes app to minimize)
    // ❌ Don't override onBackPressed (unless needed)
}
