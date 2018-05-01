package com.example.andresr.passengerappandroid.helpers;

import android.os.AsyncTask;
import android.widget.Toast;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.net.ConnectException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.util.HashMap;

public class TripHttpManager extends AsyncTask<String, Void, Integer> {

    private OnTaskCompleted listener;
    public TripHttpManager(OnTaskCompleted listener) {
        this.listener = listener;
    }

    public static final int ERR_BAD_QUERY = -3;
    public static final int ERR_CONNECTION = -2;
    public static final int ERR_NOTFOUND = -1;
    public static final int SUCCESS_DELETE = 2;
    public static final int SUCCESS_UPDATE = 3;

    /**
     *
     * @param params - params[0]: the request URL
     *                 params[1]: the HTTP method
     *                 params[2]: (optional) the id of the element to edit or delete
     *                 params[3]: (optional) the
     *
     * @return
     */
    @Override
    protected Integer doInBackground(String... params) {
        String method = params[1];
        StringBuffer response = new StringBuffer();
        try {
            URL url = new URL(params[0] + "/" + params[2]);

            HttpURLConnection connection = (HttpURLConnection)url.openConnection();
            connection.setReadTimeout(15000);
            connection.setConnectTimeout(15000);
            connection.setRequestMethod(method);
            connection.setRequestProperty("Accept", "*/*");
            connection.setDoInput(true);
            connection.setDoOutput(true);

            int responseCode = connection.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) {
                switch(method){
                    case "DELETE": return SUCCESS_DELETE;
                    case "UPDATE": return SUCCESS_UPDATE;
                }
                return ERR_BAD_QUERY;
            } else if (responseCode == HttpURLConnection.HTTP_NOT_FOUND) {
                return ERR_NOTFOUND;
            }
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        } catch (ProtocolException e) {
            e.printStackTrace();
        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
            return ERR_CONNECTION;
        }
        return 0;
    }

    @Override
    protected void onPostExecute(Integer rc) {
        listener.onTaskCompleted(rc);
//        if (rc == ERR_NOTFOUND) {
//            listener.onTaskCompleted(ERR_NOTFOUND);
//        }
    }
}
