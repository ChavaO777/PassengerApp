package com.example.andresr.passengerappandroid.models;

public class Trip {

    private String text;
    private boolean isSet;

    public Trip(String text, boolean isSet) {
        this.text = text;
        this.isSet = isSet;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public boolean getIsSet() {
        return isSet;
    }

    public void setIsSet(boolean set) {
        isSet = set;
    }
}
