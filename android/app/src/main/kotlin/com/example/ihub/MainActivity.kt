package com.example.ihub
//import io.flutter.embedding.android.FlutterActivity
//
//class MainActivity: FlutterActivity()
import android.os.Bundle
import android.widget.Toast
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Set the app to full screen
        window.setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN)

        // Start the lock task (kiosk mode)
        startLockTask()
    }

    override fun onBackPressed() {
        // Move the app to the background, but prevent exiting
        moveTaskToBack(true)
//        Toast.makeText(this, "App moved to background", Toast.LENGTH_SHORT).show()
    }

    override fun onUserLeaveHint() {
        // Prevent the app from closing when Home or Recent Apps button is pressed
        moveTaskToBack(true)
//        Toast.makeText(this, "App moved to background", Toast.LENGTH_SHORT).show()
        }
}
