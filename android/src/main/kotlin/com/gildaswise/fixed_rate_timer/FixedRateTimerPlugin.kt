package com.gildaswise.fixed_rate_timer

import android.app.Activity
import android.content.*
import android.content.Context.BIND_AUTO_CREATE
import android.os.IBinder
import android.util.Log
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

const val NOTIFY_TASK = "com.gildaswise.fixed_rate_timer.task"

class FixedRateTimerPlugin(private val channel: MethodChannel, private val context: Context): BroadcastReceiver(), MethodCallHandler {

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "fixed_rate_timer")
      val context = registrar.activeContext()
      val plugin = FixedRateTimerPlugin(channel, context)
      channel.setMethodCallHandler(plugin)
    }
  }

  private var service: FixedRateTimerService? = null
  private var bound = false

  private var connection: ServiceConnection = object : ServiceConnection {
    override fun onServiceDisconnected(name: ComponentName) {
      bound = false
      service = null
    }

    override fun onServiceConnected(name: ComponentName, service: IBinder) {
      bound = true
      val binder = service as FixedRateTimerService.LocalBinder
      this@FixedRateTimerPlugin.service = binder.service
    }
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "start" -> start(call.arguments as Int)
      "stop" -> stop()
      else -> result.notImplemented()
    }
  }

  override fun onReceive(context: Context?, intent: Intent?) {
    when {
      intent?.action.equals(NOTIFY_TASK) -> {
        Log.v("FixedRateTimerPlugin", "Received NOTIFY_TASK")
        channel.invokeMethod("task", null)
      }
    }
  }

  private fun start(duration: Int) {
    val filter = IntentFilter()
    filter.addAction(NOTIFY_TASK)
    context.registerReceiver(this, filter)

    val serviceIntent = Intent(context, FixedRateTimerService::class.java)
    serviceIntent.putExtra("duration", duration.toLong())
    Log.v("FixedRateTimerPlugin", "Check if bound: $bound")
    if (!bound) {
      Log.v("FixedRateTimerPlugin", "Starting service, duration: $duration")
      context.startService(serviceIntent)
      Log.v("FixedRateTimerPlugin", "Binding service")
      context.bindService(serviceIntent, connection, BIND_AUTO_CREATE)
    }
  }

  private fun stop() {
    service?.stop()
    service?.stopSelf()
    context.unregisterReceiver(this)
  }
}
