package com.example.andresr.passengerappandroid.jobservices;

import android.app.job.JobParameters;
import android.app.job.JobService;
import android.content.Context;
import android.media.RingtoneManager;
import android.net.Uri;
import android.support.v4.app.NotificationCompat;
import android.support.v4.app.NotificationManagerCompat;

import com.example.andresr.passengerappandroid.R;
import com.example.andresr.passengerappandroid.models.Trip;

public class TripJobService extends JobService {

    Context mCtx;
    Trip tripToSchedule;

//    TripJobService() {
//
//    }
//
//    TripJobService(Context mCtx, Trip tripToSchedule) {
//        this.mCtx = mCtx;
//        this.tripToSchedule = tripToSchedule; // Serves as container with info we need for job
//    }

    @Override
    public boolean onStartJob(JobParameters jobParameters) {
        Uri soundUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);

        NotificationCompat.Builder mBuilder = new NotificationCompat.Builder(this, "Alerta de traslado")
                .setSound(soundUri)
                .setSmallIcon(R.drawable.icon_crafter)
                .setContentTitle("Prueba de notificación")
                .setContentText("Probando que podamos mandar notificaciones")
                .setPriority(NotificationCompat.PRIORITY_MAX);

        NotificationManagerCompat notificationManager = NotificationManagerCompat.from(this);
        notificationManager.notify(1, mBuilder.build());


        return false;
    }

    @Override
    public boolean onStopJob(JobParameters jobParameters) {
        return false;
    }
}
