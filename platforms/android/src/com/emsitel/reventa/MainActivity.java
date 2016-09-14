/*
       Licensed to the Apache Software Foundation (ASF) under one
       or more contributor license agreements.  See the NOTICE file
       distributed with this work for additional information
       regarding copyright ownership.  The ASF licenses this file
       to you under the Apache License, Version 2.0 (the
       "License"); you may not use this file except in compliance
       with the License.  You may obtain a copy of the License at

         http://www.apache.org/licenses/LICENSE-2.0

       Unless required by applicable law or agreed to in writing,
       software distributed under the License is distributed on an
       "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
       KIND, either express or implied.  See the License for the
       specific language governing permissions and limitations
       under the License.
 */

package com.emsitel.reventa;

import android.os.Bundle;
import org.apache.cordova.*;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Bundle;
import android.support.v4.app.NotificationCompat;

import java.util.Timer;
import java.util.TimerTask;


import org.linphone.mediastream.Log;

import android.widget.Toast;
import com.emsitel.reventa.R;


public class MainActivity extends CordovaActivity
{
	private static final int RUNNING_NOTIFICATION_ID = 72046;
	private Notification mRunningNotification;
    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        // Set by <content src="index.html" /> in config.xml
        loadUrl(launchUrl);
        new Timer().scheduleAtFixedRate(new TimerTask(){
            @Override
            public void run(){
             	Verifica();
            }
        },0,3000);
       
     /*
        Toast.makeText(getBaseContext(),
                "se cambio el estado ... ", Toast.LENGTH_SHORT)
                .show();
		 if (!verificaConexion(this)) {
	            Toast.makeText(getBaseContext(),
	                    "Comprueba tu conexi�n a internet ", Toast.LENGTH_SHORT)
	                    .show();
	        }else{
	        	 Toast.makeText(getBaseContext(),
	                     "Conectado a internet ", Toast.LENGTH_SHORT)
	                     .show();
	        }
	        */
    }
    
   
    public void Verifica(){
    	if (!verificaConexion(this)) {
           Log.e("Comprueba tu conexi�n a internet");
           NotificationManager nManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
           nManager.cancel(RUNNING_NOTIFICATION_ID);
        }else{
           Log.i("Conectado a internet");
           NotificationManager nManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
			mRunningNotification = createRunningNotification(R.string.sip_active_title, R.string.sip_active_content,
					R.string.sip_active_ticker);
			nManager.notify(RUNNING_NOTIFICATION_ID, mRunningNotification);
			startForeground(RUNNING_NOTIFICATION_ID, mRunningNotification);
        }
    }
	private boolean startForeground(int runningNotificationId, Notification mRunningNotification2) {
		// TODO Auto-generated method stub
		return true;
	}


	public static boolean verificaConexion(Context ctx) {
  	    boolean bConectado = false;
  	    ConnectivityManager connec = (ConnectivityManager) ctx
  	            .getSystemService(Context.CONNECTIVITY_SERVICE);
  	    // No sólo wifi, también GPRS
  	    NetworkInfo[] redes = connec.getAllNetworkInfo();
  	    // este bucle debería no ser tan ñapa
  	    for (int i = 0; i < 2; i++) {
  	        // ¿Tenemos conexión? ponemos a true
  	        if (redes[i].getState() == NetworkInfo.State.CONNECTED) {
  	            bConectado = true;
  	        }
  	    }
  	    return bConectado;
  	}
  
  	
	private Notification createRunningNotification(int titleResId, int contentResId, int tickerResId) {
		PendingIntent notificationTapIntent = PendingIntent.getActivity(this, 0, new Intent(this, MainActivity.class),
				PendingIntent.FLAG_UPDATE_CURRENT);
		
		NotificationCompat.Builder nBuilder = new NotificationCompat.Builder(this);
		nBuilder.setSmallIcon(R.drawable.icon)
				.setContentIntent(notificationTapIntent)
				.setOnlyAlertOnce(true)
				.setTicker(getString(tickerResId))
				.setContentTitle(getString(titleResId))
				.setContentText(getString(contentResId));
		
		Notification runningNotification = nBuilder.build();
		runningNotification.flags |= Notification.FLAG_ONGOING_EVENT;
		return runningNotification;
	}
}