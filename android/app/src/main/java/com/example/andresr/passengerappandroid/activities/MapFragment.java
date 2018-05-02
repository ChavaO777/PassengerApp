package com.example.andresr.passengerappandroid.activities;

import android.os.AsyncTask;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;

import com.example.andresr.passengerappandroid.BuildConfig;
import com.example.andresr.passengerappandroid.R;
import com.example.andresr.passengerappandroid.helpers.HttpHandler;
import com.example.andresr.passengerappandroid.models.Station;
import com.example.andresr.passengerappandroid.models.Trip;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.MarkerOptions;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

public class MapFragment extends Fragment implements OnMapReadyCallback {
    private SupportMapFragment mapFragment;
    private GoogleMap map;
    private static final String TAG = "MapFragment";

    List<Station> stationList;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.fragment_map, container, false);
        new GetStations().execute();
        stationList = new ArrayList<>();
        mapFragment = (SupportMapFragment) getChildFragmentManager().findFragmentById(R.id.map);
        if(mapFragment == null) {
            FragmentManager fm = getFragmentManager();
            FragmentTransaction ft = fm.beginTransaction();
            mapFragment = SupportMapFragment.newInstance();
            ft.replace(R.id.map, mapFragment).commit();
        }
        mapFragment.getMapAsync(this);

        return v;

    }
    @Override
    public void onResume() {
        //mapView.onResume();
        super.onResume();
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        //mapView.onDestroy();
    }

    @Override
    public void onLowMemory() {
        super.onLowMemory();
        //mapView.onLowMemory();
    }

    @Override
    public void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        //mapView.onSaveInstanceState(outState);
    }
    @Override
    public void onMapReady(GoogleMap googleMap) {


        map = googleMap;

        LatLng wv = new LatLng(19.129328,-98.262249);
        googleMap.getUiSettings().setMyLocationButtonEnabled(true);
        //0googleMap.getUiSettings().setZoomControlsEnabled(true);
        map.addMarker(new MarkerOptions().position(wv).title("VW Puebla"));
        map.moveCamera(CameraUpdateFactory.newLatLng(wv));
        //changed zoom level here
        map.animateCamera( CameraUpdateFactory.zoomTo( 15.5f ) );

        for (Station station : stationList) {
            Log.e(TAG, "Added marker " + station);
            LatLng pos = station.getLatLng();
            String name = station.getName();
            map.addMarker(new MarkerOptions().position(pos).title(name));
        }
    }
    private class GetStations extends AsyncTask<Void, Void, Void> {


        @Override

        protected void onPreExecute() {

            super.onPreExecute();

            Toast.makeText(getActivity(), "Getting data from server", Toast.LENGTH_LONG).show();

        }


        @Override

        protected Void doInBackground(Void... voids) {

            HttpHandler sh = new HttpHandler();

            // Making a request to url and getting response

            String url = BuildConfig.API_URL + "/stations";

            String jsonStr = sh.makeServiceCall(url);


            Log.e(TAG, "Response from url: " + jsonStr);

            if (jsonStr != null) {
                try {
                    //JSONObject jsonObj = new JSONObject(jsonStr);
                    JSONArray trips = new JSONArray(jsonStr);
                    for (int i = 0; i < trips.length(); ++i) {

                        JSONObject t = trips.getJSONObject(i);
                        LatLng latLong = new LatLng(t.getDouble("lat"), t.getDouble("lng"));
                        String id = t.getString("id");
                        String name = t.getString("name");
                        double lat = t.getDouble("lat");
                        double lng = t.getDouble("lng");
                        Station station = new Station(id, name, lat, lng);
                        stationList.add(station);
                    }
                }
                catch (JSONException e) {
                    Log.e(TAG, "JSON parsing error: " + e.getMessage());
                }
            }
            else {

                Log.e(TAG, "Couldn't get json from server.");

            }

            return null;

        }


        @Override

        protected void onPostExecute(Void result) {
            super.onPostExecute(result);
        }
    }
}
