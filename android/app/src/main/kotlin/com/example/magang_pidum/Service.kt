package com.example.magang_pidum
import android.content.BroadcastReceiver
import android.content.Intent
import android.content.Context

class Service: BroadcastReceiver() {
  override fun onReceive(context: Context, intent: Intent){
    if(intent.action == Intent.ACTION_BOOT_COMPLETED){
      print(100)
    }
  }
}
