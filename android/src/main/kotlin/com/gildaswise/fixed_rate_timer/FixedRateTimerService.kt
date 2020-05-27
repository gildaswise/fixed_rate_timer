package com.gildaswise.fixed_rate_timer

import android.app.PendingIntent
import android.app.Service
import android.content.Intent
import android.os.Binder
import android.os.IBinder
import android.util.Log
import java.util.*
import kotlin.concurrent.fixedRateTimer

class FixedRateTimerService : Service() {

    private var updateTimer: Timer? = null
    private val task = Intent(NOTIFY_TASK)
    private val requestCode = 133757
    private val timerName = "flutter_fixed_rate_timer"
    private val binder = LocalBinder()

    inner class LocalBinder : Binder() {
        val service: FixedRateTimerService
            get() = this@FixedRateTimerService
    }

    override fun onBind(intent: Intent?): IBinder? {
        Log.v("FixedRateTimerService", "Bound!")
        return binder
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.v("FixedRateTimerService", "Starting...")
        val duration = intent?.getLongExtra("duration", 60 * 1000)
        duration?.let {
            updateTimer?.cancel()
            updateTimer = fixedRateTimer(timerName, false, 0L, it) {
                try {
                    PendingIntent.getBroadcast(applicationContext, requestCode, task, PendingIntent.FLAG_ONE_SHOT).send()
                } catch (error: Exception) {
                    Log.d("FixedRateTimerService", "Couldn't send task call: $error")
                }
            }
            Log.v("FixedRateTimerService", "Started timer with $it")
        }
        return START_STICKY
    }

    fun stop() {
        updateTimer?.cancel()
        updateTimer = null
    }

    override fun onDestroy() {
        stop()
        super.onDestroy()
    }


}
