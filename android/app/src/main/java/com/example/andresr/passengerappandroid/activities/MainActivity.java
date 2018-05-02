package com.example.andresr.passengerappandroid.activities;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.app.job.JobInfo;
import android.app.job.JobScheduler;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.media.RingtoneManager;
import android.net.Uri;
import android.support.annotation.NonNull;
import android.support.design.widget.BottomNavigationView;
import android.support.v4.app.NotificationCompat;
import android.support.v4.app.NotificationManagerCompat;
import android.support.v4.view.ViewPager;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Toast;

import com.example.andresr.passengerappandroid.R;
import com.example.andresr.passengerappandroid.adapters.SectionsStatePagerAdapter;
import com.example.andresr.passengerappandroid.helpers.BottomNavigationViewHelper;
import com.example.andresr.passengerappandroid.helpers.OnTaskCompleted;
import com.example.andresr.passengerappandroid.helpers.TripHttpManager;
import com.example.andresr.passengerappandroid.helpers.TripNotificationReceiver;
import com.example.andresr.passengerappandroid.jobservices.TripJobService;
import com.example.andresr.passengerappandroid.models.Trip;

import java.util.Calendar;

public class MainActivity extends AppCompatActivity implements AddEditTripFragment.TimePickerFragment.OnTimeSelectedListener, OnTaskCompleted {

    private static final String TAG = "MainActivity";
    private SectionsStatePagerAdapter adapter;
    private ViewPager viewPager;
    public Trip tripToEdit; // Contains info of trip to edit

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        viewPager = findViewById(R.id.container);
        setupViewPager(viewPager);

        BottomNavigationView bottomNavigationView = findViewById(R.id.bottomNavView_Bar);
        BottomNavigationViewHelper.disableShiftMode(bottomNavigationView);
        Menu menu = bottomNavigationView.getMenu();
        MenuItem menuItem = menu.getItem(1);
        menuItem.setChecked(true);

        bottomNavigationView.setOnNavigationItemSelectedListener(new BottomNavigationView.OnNavigationItemSelectedListener() {
            @Override
            public boolean onNavigationItemSelected(@NonNull MenuItem item) {
                switch (item.getItemId()) {
                    case R.id.menu_calendar:
                        setViewPager(0);
                        break;

                    case R.id.menu_map:
                        setViewPager(1);
                        break;

                    case R.id.menu_profile:
                        setViewPager(2);
                        break;
                }
                item.setChecked(true);
                return false;
            }

        });

//        Uri soundUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);
//
//        NotificationCompat.Builder mBuilder = new NotificationCompat.Builder(this, "Alerta de traslado")
//                .setSound(soundUri)
//                .setSmallIcon(R.drawable.icon_crafter)
//                .setContentTitle("Prueba de notificación")
//                .setContentText("Probando que podamos mandar notificaciones")
//
//                .setPriority(NotificationCompat.PRIORITY_MAX);
//
//        NotificationManagerCompat notificationManager = NotificationManagerCompat.from(this);
//        notificationManager.notify(1, mBuilder.build());
//
//
//        Calendar cal = Calendar.getInstance();
//        Intent intent = new Intent(getApplicationContext(), MainActivity.class);
//        PendingIntent pendingIntent = PendingIntent.getBroadcast(getApplicationContext(), 100, intent, PendingIntent.FLAG_UPDATE_CURRENT);
//        AlarmManager alarmManager = (AlarmManager) getSystemService(ALARM_SERVICE);
//        alarmManager.setRepeating(AlarmManager.RTC_WAKEUP, cal.getTimeInMillis(),180000 , pendingIntent);
        AlarmManager alarmManager = (AlarmManager) getSystemService(Context.ALARM_SERVICE);

        Intent notificationIntent = new Intent("com.andresr.action.DISPLAY_NOTIFICATION");
        PendingIntent broadcast = PendingIntent.getBroadcast(this, 100, notificationIntent, PendingIntent.FLAG_UPDATE_CURRENT);

        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.SECOND, 5);
        alarmManager.setExact(AlarmManager.RTC_WAKEUP, cal.getTimeInMillis(), broadcast);
    }

    private void setupViewPager(ViewPager viewPager) {
        adapter = new SectionsStatePagerAdapter(getSupportFragmentManager());
        adapter.addFragment(new TripListFragment(), "Trip List");
        adapter.addFragment(new MapFragment(), "Map");
        adapter.addFragment(new ProfileFragment(), "Profile");
        adapter.addFragment(new RateFragment(), "Rate");
        adapter.addFragment(new AddEditTripFragment(), "Add/Edit Trip");
        viewPager.setAdapter(adapter);
    }

    public void setViewPager(int fragmentNumber) {
        viewPager.setCurrentItem(fragmentNumber);
    }

    public void startJobService(Trip tripInfo) {
        ComponentName componentName = new ComponentName(this, TripJobService.class);
        JobInfo info = new JobInfo.Builder(123, componentName)
                .setPersisted(true)
                .setPeriodic(15 * 60 * 1000)
                .build();
        JobScheduler scheduler = (JobScheduler) getSystemService(JOB_SCHEDULER_SERVICE);
        int resultCode = scheduler.schedule(info);
        if (resultCode == JobScheduler.RESULT_SUCCESS) {
            Log.d(TAG, "startJobService: Job scheduled");
        } else {
            Log.d(TAG, "startJobService: Job scheduling failed");
        }
    }

    public void cancelJob(View v) {
        JobScheduler scheduler = (JobScheduler) getSystemService(JOB_SCHEDULER_SERVICE);
        scheduler.cancel(123);
    }


    // Interface method for AddEditTripFragment's TimePickerManager's hour selection
    @Override
    public void onTimeSelected(int hourOfDay, int minute) {
        // Received from TimePickerManager, send to AddEditTripFragment
        AddEditTripFragment fragment = (AddEditTripFragment) adapter.getItem(4);

        if (fragment != null) {
            fragment.updateTime(hourOfDay, minute);
        } else {
            // TODO: check if fragment is not present
        }

    }

    @Override
    // Called once the AsyncTask to Add/Delete/Edit trip finished.
    public void onTaskCompleted(int rc) {
        switch (rc) {
            case TripHttpManager.ERR_CONNECTION:
                Toast.makeText(this, "Error en el servidor. Por favor contactar a un administrador", Toast.LENGTH_SHORT).show();
            break;
            case TripHttpManager.SUCCESS_DELETE:
                Toast.makeText(this, "Traslado borrado exitosamente.", Toast.LENGTH_SHORT).show();
            break;
            case TripHttpManager.SUCCESS_UPDATE:
                setViewPager(0);
                Toast.makeText(this, "Traslado editado exitosamente.", Toast.LENGTH_SHORT).show();
            break;
            case TripHttpManager.SUCCESS_CREATE:
                setViewPager(0);
                Toast.makeText(this, "Traslado creado exitosamente.", Toast.LENGTH_SHORT).show();
            break;
        }
    }
}