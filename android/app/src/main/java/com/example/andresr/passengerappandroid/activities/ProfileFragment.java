package com.example.andresr.passengerappandroid.activities;

import android.content.Context;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.CompoundButton;
import android.widget.Switch;
import android.widget.TextView;

import com.example.andresr.passengerappandroid.R;

public class ProfileFragment extends Fragment {

    Switch notificationsSwitch, vibrationSwitch, soundSwitch;
    TextView homeStopTextView, favStopTextView;
    Button logoutButton;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.fragment_profile, container, false);
        homeStopTextView = v.findViewById(R.id.homeStopTextView);
        favStopTextView = v.findViewById(R.id.favStopTextView);
        notificationsSwitch = v.findViewById(R.id.notificationsSwitch);
        notificationsSwitch.setOnCheckedChangeListener(new SwitchChange());
        vibrationSwitch = v.findViewById(R.id.vibrationSwitch);
        vibrationSwitch.setOnCheckedChangeListener(new SwitchChange());
        soundSwitch = v.findViewById(R.id.soundSwitch);
        soundSwitch.setOnCheckedChangeListener(new SwitchChange());

        SharedPreferences sharedPref = getActivity().getPreferences(Context.MODE_PRIVATE);
        if (!sharedPref.contains(getString(R.string.notifications))) {
            // Default the settings to true
            SharedPreferences.Editor editor = sharedPref.edit();
            editor.putBoolean(getString(R.string.notifications), true);
            editor.putBoolean(getString(R.string.vibration), true);
            editor.putBoolean(getString(R.string.sound), true);
            editor.commit();
        }

        homeStopTextView.setText(sharedPref.getString(getString(R.string.home_stop), getString(R.string.default_stop)));
        favStopTextView.setText(sharedPref.getString(getString(R.string.fav_stop), getString(R.string.default_stop)));

        logoutButton = v.findViewById(R.id.logoutButton);
        logoutButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                getActivity().finish();
            }
        });

        return v;
    }

    // Helper class to listen to preference switches
    private class SwitchChange implements CompoundButton.OnCheckedChangeListener {
        @Override
        public void onCheckedChanged(CompoundButton compoundButton, boolean b) {
            SharedPreferences sharedPref = getActivity().getPreferences(Context.MODE_PRIVATE);
            SharedPreferences.Editor editor = sharedPref.edit();
            boolean state;
            switch (compoundButton.getId()) {
                case R.id.notificationsSwitch:
                    state = sharedPref.getBoolean(getString(R.string.notifications), false);
                    editor.putBoolean(getString(R.string.notifications), !state);
                    editor.commit();
                    break;
                case R.id.vibrationSwitch:
                    state = sharedPref.getBoolean(getString(R.string.vibration), false);
                    editor.putBoolean(getString(R.string.vibration), !state);
                    editor.commit();
                    break;
                case R.id.soundSwitch:
                    state = sharedPref.getBoolean(getString(R.string.sound), false);
                    editor.putBoolean(getString(R.string.sound), !state);
                    editor.commit();
                    break;
            }
        }
    }
}
