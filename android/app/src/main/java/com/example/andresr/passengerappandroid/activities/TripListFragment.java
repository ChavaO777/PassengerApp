package com.example.andresr.passengerappandroid.activities;

import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ListAdapter;
import android.widget.Toast;

import com.example.andresr.passengerappandroid.R;
import com.example.andresr.passengerappandroid.adapters.TripAdapter;
import com.example.andresr.passengerappandroid.helpers.HttpHandler;
import com.example.andresr.passengerappandroid.models.Trip;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

public class TripListFragment extends Fragment {

    private static final String TAG = "TripListFragment";
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




        adapter = new TripAdapter(container.getContext(), tripList);
        recyclerView.setAdapter(adapter);
        new GetTrips().execute();
        return v;
    }


    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }
    private class GetTrips extends AsyncTask<Void, Void, Void> {


        @Override
        protected void onPreExecute() {
            super.onPreExecute();
            Toast.makeText(getActivity(), "Getting data from server", Toast.LENGTH_LONG).show();
        }

        @Override
        protected Void doInBackground(Void... voids) {
            HttpHandler sh = new HttpHandler();
            // Making a request to url and getting response
            String url = getString(R.string.herokuBaseUri);
            String jsonStr = sh.makeServiceCall(url);

            Log.e(TAG, "Response from url: " + jsonStr);
            if (jsonStr != null) {
                try {
                    //JSONObject jsonObj = new JSONObject(jsonStr);

                    JSONArray trips = new JSONArray(jsonStr);

                    for (int i = 0; i < trips.length(); ++i) {
                        JSONObject t = trips.getJSONObject(i);
                        int id = t.getInt("id");
                        String day = t.getString("day");
                        Boolean monday = t.getBoolean("monday");
                        Boolean tuesday = t.getBoolean("tuesday");
                        Boolean wednesday = t.getBoolean("wednesday");
                        Boolean thursday = t.getBoolean("thursday");
                        Boolean friday = t.getBoolean("friday");
                        Boolean saturday = t.getBoolean("saturday");
                        Boolean sunday = t.getBoolean("sunday");

                        DateFormat df = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");

                        Trip trip = new Trip(false, monday, tuesday, wednesday, thursday, friday, saturday, sunday, df.parse(day), id);
                        tripList.add(trip);
                        adapter.notifyItemInserted(tripList.size() - 1);
                    }
                } catch (ParseException e) {
                    e.printStackTrace();
                } catch (JSONException e) {

                    Log.e(TAG, "JSON parsing error: " + e.getMessage());
                }
            } else {
                Log.e(TAG, "Couldn't get json from server.");
            }
            return null;
        }

        @Override
        protected void onPostExecute(Void result) {
            super.onPostExecute(result);
            recyclerView.invalidate();
        }
    }
}
