package com.example.andresr.passengerappandroid.models;

import com.google.android.gms.maps.model.LatLng;

public class Station {
    private String id;
    private String name;
    private double lat;
    private double lng;

    public Station(String id, String name, double lat, double lng) {
        this.id = id;
        this.name = name;
        this.lat = lat;
        this.lng = lng;
    }

    public LatLng getLatLng() {
        return new LatLng(lat, lng);
    }
    public String getName() {
        return  name;
    }
}
