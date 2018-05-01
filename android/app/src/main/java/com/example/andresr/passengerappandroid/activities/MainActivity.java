package com.example.andresr.passengerappandroid.activities;

import android.support.annotation.NonNull;
import android.support.design.widget.BottomNavigationView;
import android.support.v4.view.ViewPager;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.Toast;

import com.example.andresr.passengerappandroid.R;
import com.example.andresr.passengerappandroid.adapters.SectionsStatePagerAdapter;
import com.example.andresr.passengerappandroid.helpers.BottomNavigationViewHelper;
import com.example.andresr.passengerappandroid.helpers.OnTaskCompleted;
import com.example.andresr.passengerappandroid.helpers.TripHttpManager;
import com.example.andresr.passengerappandroid.models.Trip;

public class MainActivity extends AppCompatActivity implements AddEditTripFragment.TimePickerFragment.OnTimeSelectedListener, OnTaskCompleted {

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
        }
    }
}