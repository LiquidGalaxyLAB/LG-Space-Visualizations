package com.example.lg_space_visualizations

import android.os.Bundle
import android.os.PersistableBundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant.registerWith

// Main activity that extends FlutterActivity for flutter integration
class MainActivity : FlutterActivity() {

    // Channel name for communicating with flutter
    private val CHANNEL = "flutter.native/helper"

    // Optional map ID, nullable integer
    private var mapId: Int? = null

    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)
        registerWith(FlutterEngine(this))
    }

    // Configures the Flutter engine and sets up method channel handling
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        registerWith(flutterEngine)

        // Setting up a MethodChannel with the engine to receive custom method calls from flutter
        MethodChannel(flutterEngine.dartExecutor, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "map#addDroneKML" -> {
                    val kmlData = getDroneKMLResource()
                    loadKMLFromResource(kmlData)
                    result.success(kmlData)
                }
                "map#addRoverKML" -> {
                    val kmlData = getRoverKMLResource()
                    loadKMLFromResource(kmlData)
                    result.success(kmlData)
                }
                else -> result.notImplemented()
            }
        }
    }

    // Loads KML data from a resource file and returns it as a string
    private fun loadKMLFromResource(resourceId: Int): String {
        val inputStream = context.resources.openRawResource(resourceId)
        return inputStream.bufferedReader().use { it.readText() }
    }

    // Get the resource ID for drone path KML data
    private fun getDroneKMLResource(): Int = R.raw.drone_path

    // Get the resource ID for rover path KML data
    private fun getRoverKMLResource(): Int = R.raw.rover_path
}
