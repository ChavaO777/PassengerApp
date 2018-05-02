package com.example.andresr.passengerappandroid.helpers;

import android.os.AsyncTask;
import android.util.Log;

import org.json.JSONException;
import org.json.JSONObject;

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

// Controller for logins
public class LoginHelper {

    public static final int LOGIN_SUCCESS = 1;
    public static final int LOGIN_FAILED = -1;
    public static final int CONNECTION_ERR = 0;
    public static final int BAD_REQ = -2;
    public static final int USER_NOT_FOUND = -3;

    public static class LoginManager extends AsyncTask<String, Void, String> {
        private OnTaskCompleted listener;
        public LoginManager(OnTaskCompleted listener) {
            this.listener = listener;
        }

        @Override
        protected String doInBackground(String... params) {
            StringBuffer response = new StringBuffer();
            try {
                URL url = new URL(params[0]);

                HttpURLConnection connection = (HttpURLConnection)url.openConnection();
                connection.setReadTimeout(15000);
                connection.setConnectTimeout(15000);
                connection.setRequestMethod("POST");
                connection.setRequestProperty("Accept", "*/*");
                connection.setDoInput(true);
                connection.setDoOutput(true);

                HashMap<String, String> postParams = new HashMap<>();
                postParams.put("id", params[1]);
                postParams.put("password", params[2]);

                OutputStream os = connection.getOutputStream();
                BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(os, "UTF-8"));
                writer.write(getPostString(postParams));
                writer.flush();
                writer.close();
                os.close();

                int responseCode = connection.getResponseCode();
                if (responseCode == HttpURLConnection.HTTP_OK) {
                    String line;
                    BufferedReader br = new BufferedReader(new InputStreamReader(connection.getInputStream()));
                    while((line = br.readLine()) != null) {
                        response.append(line);
                    }
                } else if (responseCode == HttpURLConnection.HTTP_BAD_REQUEST) {
                    String line;
                    BufferedReader br = new BufferedReader(new InputStreamReader(connection.getErrorStream()));
                    while((line = br.readLine()) != null) {
                        response.append(line);
                    }
                }
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            } catch (ProtocolException e) {
                e.printStackTrace();
            } catch (MalformedURLException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
                if (e instanceof ConnectException) {
                    return "CONNERR";
                }
            }
            return response.toString();
        }

        @Override
        protected void onPostExecute(String result) {
            if (result.equals("CONNERR")) {
                listener.onTaskCompleted(CONNECTION_ERR);
                return;
            }
            // Parse the values here
            try {
                Log.d(TAG, "onPostExecute: " + result);
                JSONObject jobj = new JSONObject(result);
                if (jobj.has("token")) {
                    listener.onTaskCompleted(LOGIN_SUCCESS);
                } else {
                    if (jobj.has("message") && jobj.getString("message").equals("Incorrect password."))
                        listener.onTaskCompleted(LOGIN_FAILED);
                    else if (jobj.has("message") && jobj.getString("message").equals("Authentication failed. Passenger not found."))
                        listener.onTaskCompleted(USER_NOT_FOUND);
                    else
                        listener.onTaskCompleted(BAD_REQ);
                }
            } catch (JSONException e) {
                e.printStackTrace();
                listener.onTaskCompleted(BAD_REQ);
            }
        }

        private String getPostString(HashMap<String, String> params) throws UnsupportedEncodingException {
            StringBuffer result = new StringBuffer();
            boolean first = true;
            for (Map.Entry<String, String> entry : params.entrySet()) {
                if (first)
                    first = false;
                else
                    result.append("&");
                result.append(URLEncoder.encode(entry.getKey(), "UTF-8"));
                result.append("=");
                result.append(URLEncoder.encode(entry.getValue(), "UTF-8"));
            }
            return result.toString();
        }
    }
}
