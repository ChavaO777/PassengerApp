package com.example.andresr.passengerappandroid.models;

import java.time.OffsetDateTime;
import java.util.Calendar;
import java.util.Date;

public class Trip {

    private String text;
    private boolean isSet;
    private boolean monday, tuesday, wednesday, thursday, friday, saturday, sunday;
    private Date date;
    private int id;

    public Trip(boolean isSet, boolean monday, boolean tuesday, boolean wednesday, boolean thursday, boolean friday, boolean saturday, boolean sunday, Date date, int id) {
        this.isSet = isSet;
        this.monday = monday;
        this.tuesday = tuesday;
        this.wednesday = wednesday;
        this.thursday = thursday;
        this.friday = friday;
        this.saturday = saturday;
        this.sunday = sunday;
        this.date = date;
        this.id = id;
        this.text = makeText();

    }

    public Trip(String text, boolean isSet, boolean monday, boolean tuesday, boolean wednesday, boolean thursday, boolean friday, boolean saturday, boolean sunday) {
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

    private String makeText() {
        StringBuilder sb = new StringBuilder();
        sb.append("Hora de partida: ");
        sb.append(date.getHours());
        sb.append(":");
        if (date.getMinutes() < 10)
            sb.append("0");
        sb.append(date.getMinutes());
        sb.append(" ");
        sb.append(date.getDate());
        sb.append("/");
        sb.append(date.getMonth());
        sb.append("/");
        sb.append(date.getYear() + 1900);
        if (monday)
            sb.append(" L");
        if (tuesday)
            sb.append(" M");
        if (wednesday)
            sb.append(" M");
        if (thursday)
            sb.append(" J");
        if (friday)
            sb.append(" V");
        if (saturday)
            sb.append(" S");
        if (sunday)
            sb.append(" D");
        return sb.toString();
    }
}
