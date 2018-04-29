package com.example.andresr.passengerappandroid.activities;

import android.support.annotation.NonNull;
import android.support.design.widget.BottomNavigationView;
import android.support.v4.view.ViewPager;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;

import com.example.andresr.passengerappandroid.R;
import com.example.andresr.passengerappandroid.adapters.SectionsStatePagerAdapter;
import com.example.andresr.passengerappandroid.helpers.BottomNavigationViewHelper;

public class MainActivity extends AppCompatActivity implements AddEditTripFragment.TimePickerFragment.OnTimeSelectedListener {

    private SectionsStatePagerAdapter adapter;
    private ViewPager viewPager;

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
}