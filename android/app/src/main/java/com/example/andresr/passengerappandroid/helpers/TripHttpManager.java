package com.example.andresr.passengerappandroid.helpers;

import android.os.AsyncTask;
import android.util.Log;
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
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

import static android.support.constraint.Constraints.TAG;

public class TripHttpManager extends AsyncTask<String, Void, Integer> {

    private OnTaskCompleted listener;
    public TripHttpManager(OnTaskCompleted listener) {
        this.listener = listener;
    }

    public static final int ERR_BAD_QUERY = -3;
    public static final int ERR_CONNECTION = -2;
    public static final int ERR_NOTFOUND = -1;
    public static final int SUCCESS_CREATE = 1;
    public static final int SUCCESS_DELETE = 2;
    public static final int SUCCESS_UPDATE = 3;

    /**
     *
     * @param params - params[0]: the request URL
     *                 params[1]: the HTTP method
     *                 params[2]: (optional) the id of the element to edit or delete
     *                 params[3]: (optional) the day
     *                 params[4-10]: (optional) monday-sunday booleans, as Strings
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
            if (!method.equals("DELETE")) {
                connection.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
                // Create my POST/PATCH string
                HashMap<String, String> postParams = new HashMap<>();

//                if (!params[2].equals("")) {
//                    postParams.put("id", params[2]);
//                }
                postParams.put("day", params[3]);
                postParams.put("monday", params[4]);
                postParams.put("tuesday", params[5]);
                postParams.put("wednesday", params[6]);
                postParams.put("thursday", params[7]);
                postParams.put("friday", params[8]);
                postParams.put("saturday", params[9]);
                postParams.put("sunday", params[10]);
                String json = getPostJsonString(postParams);
                OutputStream os = connection.getOutputStream();
                os.write(json.getBytes("UTF-8"));
                os.close();
            }


            int responseCode = connection.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK || responseCode == HttpURLConnection.HTTP_CREATED) {
                switch(method){
                    case "DELETE": return SUCCESS_DELETE;
                    case "PATCH": return SUCCESS_UPDATE;
                    case "POST": return SUCCESS_CREATE;
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

    private String getPostJsonString(HashMap<String, String> params) throws UnsupportedEncodingException {
        StringBuffer result = new StringBuffer();
        boolean first = true;
        result.append("{");
        for (Map.Entry<String, String> entry : params.entrySet()) {
            if (first)
                first = false;
            else
                result.append(",");
            result.append("\"");
            result.append(URLEncoder.encode(entry.getKey(), "UTF-8"));
            result.append("\":");
            if (entry.getKey().equals("id") || entry.getKey().equals("day")) {
                // Append value as string
                result.append("\"");
                result.append(entry.getValue());
                result.append("\"");
            } else {
                // Append value as boolean
                result.append(URLEncoder.encode(entry.getValue(), "UTF-8"));
            }
        }
        result.append("}");
        Log.d(TAG, "getPostJsonString: " + result.toString());
        return result.toString();
    }
}
