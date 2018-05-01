package com.example.andresr.passengerappandroid.activities;

import android.app.Activity;
import android.app.DatePickerDialog;
import android.app.Dialog;
import android.app.DialogFragment;
import android.app.TimePickerDialog;
import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.text.format.DateFormat;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.TextView;
import android.widget.TimePicker;
import android.widget.ToggleButton;

import com.example.andresr.passengerappandroid.R;
import com.example.andresr.passengerappandroid.models.Trip;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import static android.content.ContentValues.TAG;

public class AddEditTripFragment extends Fragment {

    Button chooseTimeButton, chooseDateButton;
    ToggleButton mondayButton, tuesdayButton, wednesdayButton, thursdayButton, fridayButton, saturdayButton, sundayButton;
    TextView timeTextView, dateTextView, textTitle;

    private DatePickerDialog.OnDateSetListener mDateSetListener;

    private int hourOfDay, minute, day, month, year;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.fragment_add_edit_trip, container, false);
        chooseTimeButton = v.findViewById(R.id.chooseTimeButton);
        chooseDateButton = v.findViewById(R.id.chooseDateButton);
        timeTextView = v.findViewById(R.id.timeTextView);
        dateTextView = v.findViewById(R.id.dateTextView);
        textTitle = v.findViewById(R.id.textTitle);

        mondayButton = v.findViewById(R.id.mondayButton);
        tuesdayButton = v.findViewById(R.id.tuesdayButton);
        wednesdayButton = v.findViewById(R.id.wednesdayButton);
        thursdayButton = v.findViewById(R.id.thursdayButton);
        fridayButton = v.findViewById(R.id.fridayButton);
        saturdayButton = v.findViewById(R.id.saturdayButton);
        sundayButton = v.findViewById(R.id.sundayButton);
        textTitle.setText("Nuevo traslado");
        chooseTimeButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                DialogFragment newFragment = new TimePickerFragment();
                newFragment.show(getActivity().getFragmentManager(), "timePicker");
            }
        });



        final Trip myTrip = ((MainActivity)getActivity()).tripToEdit;
        // Check if tripToEdit is not null, so we can pull the values to populate the date/time
        if (myTrip != null) {
            textTitle.setText("Editar traslado");
            Date date = myTrip.getDate();
            String min = "0";
            if (date.getMinutes() < 10) {
                min += Integer.toString(date.getMinutes());
            } else min = Integer.toString(date.getMinutes());
            timeTextView.setText(date.getHours() + ":" + min);
            minute = date.getMinutes();
            hourOfDay = date.getHours();
            // Populate date
            dateTextView.setText(date.getDate() + "/" + date.getMonth() + "/" + (date.getYear() + 1900));
            year = date.getYear() + 1900;
            month = date.getMonth();
            day = date.getDate();

            // Populate ToggleButtons
            mondayButton.post(new Runnable() {
                @Override
                public void run() {
                    mondayButton.setChecked(myTrip.isMonday());
                    mondayButton.setSelected(myTrip.isMonday());
                }
            });
            tuesdayButton.post(new Runnable() {
                @Override
                public void run() {
                    tuesdayButton.setChecked(myTrip.isMonday());
                    tuesdayButton.setSelected(myTrip.isMonday());
                }
            });
            wednesdayButton.post(new Runnable() {
                @Override
                public void run() {
                    wednesdayButton.setChecked(myTrip.isMonday());
                    wednesdayButton.setSelected(myTrip.isMonday());
                }
            });
            thursdayButton.post(new Runnable() {
                @Override
                public void run() {
                    thursdayButton.setChecked(myTrip.isMonday());
                    thursdayButton.setSelected(myTrip.isMonday());
                }
            });
            fridayButton.post(new Runnable() {
                @Override
                public void run() {
                    fridayButton.setChecked(myTrip.isMonday());
                    fridayButton.setSelected(myTrip.isMonday());
                }
            });
            saturdayButton.post(new Runnable() {
                @Override
                public void run() {
                    saturdayButton.setChecked(myTrip.isMonday());
                    saturdayButton.setSelected(myTrip.isMonday());
                }
            });
            sundayButton.post(new Runnable() {
                @Override
                public void run() {
                    sundayButton.setChecked(myTrip.isMonday());
                    sundayButton.setSelected(myTrip.isMonday());
                }
            });

        }

        chooseDateButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (myTrip == null) { // If we are in 'add new trip' mode
                    Calendar cal = Calendar.getInstance();
                    year = cal.get(Calendar.YEAR);
                    month = cal.get(Calendar.MONTH);
                    day = cal.get(Calendar.DAY_OF_MONTH);
                } // else the values should already be there.

                DatePickerDialog dialog = new DatePickerDialog(getActivity(), mDateSetListener, year, month, day);
                dialog.getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
                dialog.show();
            }
        });
        mDateSetListener = new DatePickerDialog.OnDateSetListener() {
            @Override
            public void onDateSet(DatePicker datePicker, int year, int month, int day) {
                String date = day + "/" + month + "/" + year;
                dateTextView.setText(date);
            }
        };

        return v;
    }

    // Called from MainActivity whenever the time is updated
    public void updateTime(int hourOfDay, int minute) {
        this.hourOfDay = hourOfDay;
        this.minute = minute;
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.HOUR_OF_DAY, hourOfDay);
        calendar.set(Calendar.MINUTE, minute);
        String min = "0";
        if (calendar.get(Calendar.MINUTE) < 10) {
            min += Integer.toString(minute);
        } else min = Integer.toString(minute);
        timeTextView.setText(calendar.get(Calendar.HOUR_OF_DAY) + ":" + min);
    }





    public static class TimePickerFragment extends DialogFragment implements TimePickerDialog.OnTimeSetListener {

        OnTimeSelectedListener mCallback;

        // container Activity must implement this interface
        public interface OnTimeSelectedListener {
            void onTimeSelected(int hourOfDay, int minute);
        }

        @Override
        public void onAttach(Activity activity) {
            super.onAttach(activity);

            try {
                mCallback = (OnTimeSelectedListener) activity;
            } catch (ClassCastException e) {
                throw new ClassCastException(activity.toString() + " must implement OnTimeSelectedListener");
            }
        }

        @Override
        public Dialog onCreateDialog(Bundle savedInstanceState) {
            // Use the current time as the default values for the picker
            final Calendar c = Calendar.getInstance();
            int hour = c.get(Calendar.HOUR_OF_DAY);
            int minute = c.get(Calendar.MINUTE);

            // Create a new instance of TimePickerDialog and return it
            return new TimePickerDialog(getActivity(), TimePickerDialog.THEME_HOLO_LIGHT, this, hour, minute,
                    DateFormat.is24HourFormat(getActivity()));
        }

        public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
            mCallback.onTimeSelected(hourOfDay, minute);
        }
    }
}