package com.kidsvsparents.kids_vs_parents

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.provider.OpenableColumns
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.io.File
import java.io.IOException
import java.nio.charset.StandardCharsets

class MainActivity : FlutterActivity() {
	private var pendingCsvResult: MethodChannel.Result? = null

	override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)
		MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NAME)
			.setMethodCallHandler { call, result ->
				when (call.method) {
					"pickCsv" -> pickCsv(result)
					"saveCsv" -> saveCsv(call.argument("csv"), call.argument("fileName"), result)
					"loadCsv" -> loadCsv(result)
					"clearCsv" -> clearCsv(result)
					else -> result.notImplemented()
				}
			}
	}

	private fun pickCsv(result: MethodChannel.Result) {
		if (pendingCsvResult != null) {
			result.error("picker_busy", "A CSV file selection is already open.", null)
			return
		}
		pendingCsvResult = result
		val intent = Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
			addCategory(Intent.CATEGORY_OPENABLE)
			type = "*/*"
			putExtra(Intent.EXTRA_MIME_TYPES, arrayOf("text/csv", "text/comma-separated-values", "application/csv", "application/vnd.ms-excel"))
		}
		try {
			startActivityForResult(intent, CSV_PICKER_REQUEST_CODE)
		} catch (error: Exception) {
			pendingCsvResult = null
			result.error("picker_unavailable", error.message, null)
		}
	}

	override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
		super.onActivityResult(requestCode, resultCode, data)
		if (requestCode != CSV_PICKER_REQUEST_CODE) return

		val result = pendingCsvResult ?: return
		pendingCsvResult = null
		if (resultCode != Activity.RESULT_OK) {
			result.success(null)
			return
		}

		val uri = data?.data
		if (uri == null) {
			result.error("missing_file", "No CSV file was selected.", null)
			return
		}

		try {
			val name = displayName(uri)
			val mimeType = contentResolver.getType(uri)
			val hasCsvType = mimeType in setOf("text/csv", "text/comma-separated-values", "application/csv", "application/vnd.ms-excel")
			if (!name.endsWith(".csv", ignoreCase = true) && !hasCsvType) {
				throw IOException("Choose a file with the .csv extension.")
			}
			val csv = contentResolver.openInputStream(uri)?.use { input ->
				val output = ByteArrayOutputStream()
				val buffer = ByteArray(8192)
				var totalBytes = 0
				while (true) {
					val count = input.read(buffer)
					if (count < 0) break
					totalBytes += count
					if (totalBytes > MAX_CSV_BYTES) throw IOException("CSV files must be 1 MB or smaller.")
					output.write(buffer, 0, count)
				}
				String(output.toByteArray(), StandardCharsets.UTF_8)
			} ?: throw IOException("The selected file could not be opened.")
			result.success(mapOf("fileName" to name, "csv" to csv))
		} catch (error: Exception) {
			result.error("csv_read_failed", error.message, null)
		}
	}

	private fun displayName(uri: Uri): String {
		contentResolver.query(uri, arrayOf(OpenableColumns.DISPLAY_NAME), null, null, null)?.use { cursor ->
			if (cursor.moveToFirst()) {
				val nameIndex = cursor.getColumnIndex(OpenableColumns.DISPLAY_NAME)
				if (nameIndex >= 0) return cursor.getString(nameIndex)
			}
		}
		return uri.lastPathSegment ?: "questions.csv"
	}

	private fun saveCsv(csv: String?, fileName: String?, result: MethodChannel.Result) {
		if (csv == null || fileName == null) {
			result.error("invalid_csv", "CSV contents and file name are required.", null)
			return
		}
		if (csv.toByteArray(StandardCharsets.UTF_8).size > MAX_CSV_BYTES) {
			result.error("csv_too_large", "CSV files must be 1 MB or smaller.", null)
			return
		}
		try {
			val dataFile = File(filesDir, CSV_FILE_NAME)
			val tempFile = File(filesDir, "$CSV_FILE_NAME.tmp")
			tempFile.writeText(csv, StandardCharsets.UTF_8)
			if (!tempFile.renameTo(dataFile)) throw IOException("Could not save the CSV file locally.")
			File(filesDir, CSV_SOURCE_NAME).writeText(fileName, StandardCharsets.UTF_8)
			result.success(true)
		} catch (error: Exception) {
			result.error("csv_save_failed", error.message, null)
		}
	}

	private fun loadCsv(result: MethodChannel.Result) {
		val dataFile = File(filesDir, CSV_FILE_NAME)
		if (!dataFile.exists()) {
			result.success(null)
			return
		}
		try {
			val sourceFile = File(filesDir, CSV_SOURCE_NAME)
			val sourceName = if (sourceFile.exists()) sourceFile.readText(StandardCharsets.UTF_8) else "questions.csv"
			result.success(
				mapOf<String, String>(
					"fileName" to sourceName,
					"csv" to dataFile.readText(StandardCharsets.UTF_8),
				),
			)
		} catch (error: Exception) {
			result.error("csv_load_failed", error.message, null)
		}
	}

	private fun clearCsv(result: MethodChannel.Result) {
		File(filesDir, CSV_FILE_NAME).delete()
		File(filesDir, CSV_SOURCE_NAME).delete()
		result.success(true)
	}

	companion object {
		private const val CHANNEL_NAME = "kids_vs_parents/local_questions"
		private const val CSV_PICKER_REQUEST_CODE = 7402
		private const val CSV_FILE_NAME = "learning_questions.csv"
		private const val CSV_SOURCE_NAME = "learning_questions_source.txt"
		private const val MAX_CSV_BYTES = 1024 * 1024
	}
}
