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
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.TextView;
import android.widget.TimePicker;
import android.widget.ToggleButton;

import com.example.andresr.passengerappandroid.R;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

public class AddEditTripFragment extends Fragment {

    Button chooseTimeButton, chooseDateButton;
    TextView timeTextView, dateTextView;

    private DatePickerDialog.OnDateSetListener mDateSetListener;

    private int hourOfDay, minute, day, month, year;

    List<ToggleButton> repeatToggleButtonList;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.fragment_add_edit_trip, container, false);
        chooseTimeButton = v.findViewById(R.id.chooseTimeButton);
        chooseDateButton = v.findViewById(R.id.chooseDateButton);
        timeTextView = v.findViewById(R.id.timeTextView);
        dateTextView = v.findViewById(R.id.dateTextView);
        repeatToggleButtonList = new ArrayList<>();
        repeatToggleButtonList.add((ToggleButton) v.findViewById(R.id.mondayButton));
        repeatToggleButtonList.add((ToggleButton) v.findViewById(R.id.tuesdayButton));
        repeatToggleButtonList.add((ToggleButton) v.findViewById(R.id.wednesdayButton));
        repeatToggleButtonList.add((ToggleButton) v.findViewById(R.id.thursdayButton));
        repeatToggleButtonList.add((ToggleButton) v.findViewById(R.id.fridayButton));
        repeatToggleButtonList.add((ToggleButton) v.findViewById(R.id.saturdayButton));
        repeatToggleButtonList.add((ToggleButton) v.findViewById(R.id.sundayButton));
        chooseTimeButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                DialogFragment newFragment = new TimePickerFragment();
                newFragment.show(getActivity().getFragmentManager(), "timePicker");
            }
        });

        chooseDateButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Calendar cal = Calendar.getInstance();
                year = cal.get(Calendar.YEAR);
                month = cal.get(Calendar.MONTH);
                day = cal.get(Calendar.DAY_OF_MONTH);

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