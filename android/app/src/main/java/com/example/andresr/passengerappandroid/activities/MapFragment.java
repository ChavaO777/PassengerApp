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

import com.example.andresr.passengerappandroid.R;
import com.google.android.gms.common.GooglePlayServicesNotAvailableException;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.MapView;
import com.google.android.gms.maps.MapsInitializer;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.MarkerOptions;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;

import javax.net.ssl.HttpsURLConnection;

public class MapFragment extends Fragment implements OnMapReadyCallback {
    private SupportMapFragment mapFragment;
    private GoogleMap map;
    private static final String TAG = "MapFragment";

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.fragment_map, container, false);
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

        LatLng wv = new LatLng(19.1150491,-98.2442522);
        googleMap.getUiSettings().setMyLocationButtonEnabled(true);
        //0googleMap.getUiSettings().setZoomControlsEnabled(true);
        map.addMarker(new MarkerOptions().position(wv).title("VW Puebla"));
        map.moveCamera(CameraUpdateFactory.newLatLng(wv));
        //changed zoom level here
        map.animateCamera( CameraUpdateFactory.zoomTo( 16.0f ) );

        setStationsMarkers();
    }

    public void setStationsMarkers() {
        AsyncTask.execute(new Runnable() {
            @Override
            public void run() {
                try {
                    URL serverEndPoint = new URL("http://192.168.4.246:8000");
                    HttpsURLConnection myConnection = (HttpsURLConnection) serverEndPoint.openConnection();
                    String msg;
                    if (myConnection.getResponseCode() == 200) {
                        msg = "conexion exitosa";
                    }
                    else {
                        msg = "error" + myConnection.getResponseCode();
                    }
                    Log.e(TAG, msg);
                } catch (MalformedURLException e) {
                    e.printStackTrace();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }); 
    }
}
