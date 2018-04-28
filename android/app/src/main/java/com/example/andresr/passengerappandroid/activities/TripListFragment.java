package com.example.andresr.passengerappandroid.activities;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.example.andresr.passengerappandroid.R;
import com.example.andresr.passengerappandroid.adapters.TripAdapter;
import com.example.andresr.passengerappandroid.models.Trip;

import java.util.ArrayList;
import java.util.List;

public class TripListFragment extends Fragment {


    RecyclerView recyclerView;
    TripAdapter adapter;

    List<Trip> tripList;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.fragment_trip_list, container, false);
        tripList = new ArrayList<>();

        recyclerView = v.findViewById(R.id.recyclerView);
        recyclerView.setHasFixedSize(true);
        recyclerView.setLayoutManager(new LinearLayoutManager(container.getContext()));


        // Hardcoded Trips. Delete later when API is called
        tripList.add(
                new Trip(
                        "Hora de partida: 8:00pm 3 de mar. 2018",
                        true
                )
        );
        tripList.add(
                new Trip(
                        "Hora de partida: 10:00am L M M",
                        false
                )
        );

        adapter = new TripAdapter(container.getContext(), tripList);
        recyclerView.setAdapter(adapter);


        return v;

    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);


    }
}
