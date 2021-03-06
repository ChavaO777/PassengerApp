package com.example.andresr.passengerappandroid.adapters;

import android.content.Context;
import android.content.res.Resources;
import android.os.AsyncTask;
import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.view.ContextMenu;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.PopupMenu;
import android.widget.Switch;
import android.widget.TextView;
import android.widget.Toast;

import com.example.andresr.passengerappandroid.BuildConfig;
import com.example.andresr.passengerappandroid.R;
import com.example.andresr.passengerappandroid.activities.MainActivity;
import com.example.andresr.passengerappandroid.helpers.TripHttpManager;
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
    public void onBindViewHolder(final TripViewHolder holder, int position) {
        final Trip trip = tripList.get(position);
        int currentPosition = position;
        holder.rowTextView.setText(trip.getText());
        holder.rowSwitch.setChecked(trip.getIsSet());
        final ImageButton button = holder.deleteButton;
        holder.deleteButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                PopupMenu popup = new PopupMenu(mCtx, button);
                popup.inflate(R.menu.trip_context_menu);

                popup.setOnMenuItemClickListener(new PopupMenu.OnMenuItemClickListener() {
                    @Override
                    public boolean onMenuItemClick(MenuItem menuItem) {
                        switch (menuItem.getItemId()) {
                            case R.id.menu_item_delete:
                                tripList.remove(holder.getAdapterPosition());
                                notifyItemRemoved(holder.getAdapterPosition());
                                // Do an async call to remove from server
                                new TripHttpManager((MainActivity) mCtx).execute(BuildConfig.HEROKU_URL, "DELETE", Integer.toString(trip.getId()));
                                return true;
                            case R.id.menu_item_edit:
                                // Send to other fragment
                                ((MainActivity)mCtx).tripToEdit = trip;
                                ((MainActivity)mCtx).setViewPager(4);
                                return true;
                        }
                        return false;
                    }
                });
                popup.show();
            }
        });

        holder.itemView.setOnLongClickListener(new View.OnLongClickListener() {
            @Override
            public boolean onLongClick(View view) {
                PopupMenu popup = new PopupMenu(mCtx, button);
                popup.inflate(R.menu.trip_context_menu);

                popup.setOnMenuItemClickListener(new PopupMenu.OnMenuItemClickListener() {
                    @Override
                    public boolean onMenuItemClick(MenuItem menuItem) {
                        switch (menuItem.getItemId()) {
                            case R.id.menu_item_delete:
                                tripList.remove(holder.getAdapterPosition());
                                notifyItemRemoved(holder.getAdapterPosition());
                                // Do an async call to remove from server
                                new TripHttpManager((MainActivity) mCtx).execute(BuildConfig.HEROKU_URL, "DELETE", Integer.toString(trip.getId()));
                                return true;
                            case R.id.menu_item_edit:
                                // Send to other fragment
                                ((MainActivity)mCtx).tripToEdit = trip;
                                ((MainActivity)mCtx).setViewPager(4);
                                return true;
                        }
                        return false;
                    }
                });
                popup.show();
                return true;
            }
        });
    }



    @Override
    public int getItemCount() {
        return tripList.size();
    }

    class TripViewHolder extends RecyclerView.ViewHolder implements View.OnCreateContextMenuListener {

        TextView rowTextView;
        Switch rowSwitch;
        ImageButton deleteButton;

        public TripViewHolder(View itemView) {
            super(itemView);
            rowTextView = itemView.findViewById(R.id.rowTextView);
            rowSwitch = itemView.findViewById(R.id.rowSwitch);
            deleteButton = itemView.findViewById(R.id.deleteButton);
            itemView.setOnCreateContextMenuListener(this);
        }

        @Override
        public void onCreateContextMenu(ContextMenu contextMenu, View view, ContextMenu.ContextMenuInfo contextMenuInfo) {
            contextMenu.add(Menu.NONE, R.id.menu_item_delete, Menu.NONE, "Borrar");
            contextMenu.add(Menu.NONE, R.id.menu_item_edit, Menu.NONE, "Editar");
        }
    }

    private class DeleteHandler extends AsyncTask<Integer, Void, Void> {

        @Override
        protected Void doInBackground(Integer... params) {
            int id = params[0];

            return null;
        }
    }
}
