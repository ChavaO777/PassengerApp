package com.example.andresr.passengerappandroid.activities;

import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;

import com.example.andresr.passengerappandroid.R;
import com.example.andresr.passengerappandroid.adapters.TripAdapter;
import com.example.andresr.passengerappandroid.models.Trip;

import java.util.ArrayList;
import java.util.List;

public class TripListFragment extends Fragment {


    RecyclerView recyclerView;
    TripAdapter adapter;
    Button addTripButton;

    List<Trip> tripList;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.fragment_trip_list, container, false);
        tripList = new ArrayList<>();

        recyclerView = v.findViewById(R.id.recyclerView);
        recyclerView.setHasFixedSize(true);
        recyclerView.setLayoutManager(new LinearLayoutManager(container.getContext()));
        addTripButton = v.findViewById(R.id.addTripButton);
        addTripButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                ((MainActivity)getActivity()).setViewPager(4);

//                Fragment fragment = new AddEditTripFragment();
//                FragmentManager fragmentManager = getActivity().getSupportFragmentManager();
//                FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
//                fragmentTransaction.replace(R.id.container, fragment);
//                fragmentTransaction.addToBackStack(null);
//                fragmentTransaction.commit();
            }
        });


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
