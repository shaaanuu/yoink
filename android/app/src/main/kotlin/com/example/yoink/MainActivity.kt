package com.example.yoink

import android.os.Build
import android.os.Environment
import android.content.ContentValues
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.chaquo.python.Python
import com.chaquo.python.android.AndroidPlatform
import java.io.File

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
            } else if (call.method == "download") {
                val url = call.argument<String>("url")
                val formatId = call.argument<String>("format_id")

                if (url == null || formatId == null) {
                    result.error("MISSING_ARGS", "Missing arguments", null)
                    return@setMethodCallHandler
                }

                val outputDir = resolveOutputDir()

                try {
                    val py = Python.getInstance()
                    val module = py.getModule("bridge")
                    val jsonStr = module.callAttr("download", url, formatId, outputDir).toString()
                    result.success(jsonStr)
                } catch (e: Exception) {
                    result.error("PYTHON_CRASH", e.message, null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun resolveOutputDir(): String {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            try {
                val resolver = contentResolver
                val values = ContentValues().apply {
                    put(MediaStore.MediaColumns.DISPLAY_NAME, "yoink_${System.currentTimeMillis()}.mp4")
                    put(MediaStore.MediaColumns.MIME_TYPE, "video/mp4")
                    put(MediaStore.MediaColumns.RELATIVE_PATH, "Download/yoink")
                }
                val uri = resolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, values)
                if (uri != null) {
                    val projection = arrayOf(MediaStore.MediaColumns.DATA)
                    resolver.query(uri, projection, null, null, null)?.use { cursor ->
                        if (cursor.moveToFirst()) {
                            val path = cursor.getString(0)
                            if (path != null) {
                                resolver.delete(uri, null, null)
                                val dir = File(path).parent
                                if (dir != null) return dir
                            }
                        }
                    }
                }
            } catch (_: Exception) {}
        }
        val dir = File(Environment.getExternalStorageDirectory(), "yoink")
        dir.mkdirs()
        return dir.absolutePath
    }
}