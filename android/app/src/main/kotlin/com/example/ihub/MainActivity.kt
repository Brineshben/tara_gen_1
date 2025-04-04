package com.example.ihub

import android.app.ActivityManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Set full-screen mode
        window.setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN)

        // Start kiosk mode
        startKioskMode()
    }

    override fun onResume() {
        super.onResume()
        // Restart kiosk mode when returning to the app
        startKioskMode()
    }

    override fun onBackPressed() {
        // Prevent exiting the app
        moveTaskToBack(true)
    }

    override fun onUserLeaveHint() {
        // Prevent the app from closing when Home or Recent Apps button is pressed
        moveTaskToBack(true)
    }

    private fun startKioskMode() {
        // Start Lock Task Mode (Kiosk Mode)
        if (!isLockTaskModeActive()) {
            startLockTask()
        }
    }

    private fun stopKioskMode() {
        // Stop Lock Task Mode before launching another app
        stopLockTask()
    }

    private fun isLockTaskModeActive(): Boolean {
        val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        return activityManager.lockTaskModeState != ActivityManager.LOCK_TASK_MODE_NONE
    }

    fun openAnotherApp() {
        stopKioskMode() // Stop Kiosk Mode before launching the external app

        val packageName = "com.slamtec.robostudio"
        val intent = packageManager.getLaunchIntentForPackage(packageName)

        if (intent != null) {
            startActivity(intent)
        } else {
            // Open Play Store if the app is not installed
            val playStoreIntent = Intent(
                Intent.ACTION_VIEW,
                Uri.parse("https://play.google.com/store/apps/details?id=$packageName")
            )
            playStoreIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(playStoreIntent)
        }
    }
}
