package com.example.yoink

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.chaquo.python.Python
import com.chaquo.python.android.AndroidPlatform

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(engine: FlutterEngine) {
        super.configureFlutterEngine(engine)

        if (!Python.isStarted()) {
            Python.start(AndroidPlatform(this))
        }

        MethodChannel(engine.dartExecutor.binaryMessenger, "ytdlp").setMethodCallHandler { call, result ->
            if (call.method == "get_info") {
                val url = call.argument<String>("url")

                if (url == null) {
                    result.error("MISSING_ARGS", "Url missing", null)
                    return@setMethodCallHandler
                }

                try {
                    val py = Python.getInstance()
                    val module = py.getModule("bridge")
                    val jsonStr = module.callAttr("get_info", url).toString()
                    result.success(jsonStr)
                } catch (e: Exception) {
                    result.error("PYTHON_CRASH", e.message, null)
                }
            } else if (call.method == "check_deps") {
                try {
                    val py = Python.getInstance()
                    val module = py.getModule("bridge")
                    val jsonStr = module.callAttr("check_deps").toString()
                    result.success(jsonStr)
                } catch (e: Exception) {
                    result.error("PYTHON_CRASH", e.message, null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}