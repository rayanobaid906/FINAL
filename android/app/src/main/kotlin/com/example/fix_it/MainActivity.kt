package com.example.fix_it

import android.content.Intent
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "fixit/camera"

    override fun configureFlutterEngine(
        flutterEngine: FlutterEngine
    ) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            if (call.method == "openCamera") {

                val cameraIntent =
                    Intent(MediaStore.ACTION_IMAGE_CAPTURE)

                if (
                    cameraIntent.resolveActivity(
                        packageManager
                    ) != null
                ) {
                    startActivity(cameraIntent)

                    result.success(true)
                } else {
                    result.error(
                        "CAMERA_ERROR",
                        "No camera app found",
                        null
                    )
                }

            } else {
                result.notImplemented()
            }
        }
    }
}