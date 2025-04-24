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

        window.setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN)

        startLockTask()
    }

    override fun onBackPressed() {
        moveTaskToBack(true)
    }

    override fun onUserLeaveHint() {
        moveTaskToBack(true)
        }
}
