package com.example.andresr.passengerappandroid.models;

import com.google.android.gms.maps.model.LatLng;

public class Crafter {
    private String id;
    private String name;
    private double lat;
    private double lng;
    private boolean isActive;

    public Crafter(String id, String name, double lat, double lng, boolean isActive) {
        this.id = id;
        this.name = name;
        this.lat = lat;
        this.lng = lng;
        this.isActive = isActive;
    }
    public LatLng getLatLng() {
        return new LatLng(lat, lng);
    }
    public String getName() {
        return  name;
    }
    public String getId() {
        return id;
    }
    public boolean getIsActive() {
        return  isActive;
    }
}
