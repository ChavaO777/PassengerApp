package com.example.andresr.passengerappandroid.adapters;

import android.content.Context;
import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Switch;
import android.widget.TextView;

import com.example.andresr.passengerappandroid.R;
import com.example.andresr.passengerappandroid.models.Trip;

import java.util.List;

public class TripAdapter extends RecyclerView.Adapter<TripAdapter.TripViewHolder> {


    private Context mCtx;
    private List<Trip> tripList;


    public TripAdapter(Context mCtx, List<Trip> tripList) {
        this.mCtx = mCtx;
        this.tripList = tripList;
    }

    @NonNull
    @Override
    public TripViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        LayoutInflater inflater  = LayoutInflater.from(mCtx);
        View view = inflater.inflate(R.layout.trip_row, null);
        TripViewHolder holder = new TripViewHolder(view);
        return holder;
    }

    @Override
    public void onBindViewHolder(@NonNull TripViewHolder holder, int position) {
        Trip trip = tripList.get(position);
        holder.rowTextView.setText(trip.getText());
        holder.rowSwitch.setChecked(trip.getIsSet());
    }

    @Override
    public int getItemCount() {
        return tripList.size();
    }

    class TripViewHolder extends RecyclerView.ViewHolder {

        TextView rowTextView;
        Switch rowSwitch;

        public TripViewHolder(View itemView) {
            super(itemView);
            rowTextView = itemView.findViewById(R.id.rowTextView);
            rowSwitch = itemView.findViewById(R.id.rowSwitch);
        }
    }
}
