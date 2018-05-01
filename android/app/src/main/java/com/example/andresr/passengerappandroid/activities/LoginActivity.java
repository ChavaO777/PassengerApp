package com.example.andresr.passengerappandroid.activities;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.example.andresr.passengerappandroid.BuildConfig;
import com.example.andresr.passengerappandroid.R;
import com.example.andresr.passengerappandroid.helpers.LoginHelper;
import com.example.andresr.passengerappandroid.helpers.OnTaskCompleted;

public class LoginActivity extends AppCompatActivity implements OnTaskCompleted {

    private static final String TAG = "LoginActivity";
    Button loginButton;
    EditText inputUserId, inputPassword;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);
        loginButton = findViewById(R.id.loginButton);
        inputUserId = findViewById(R.id.inputUserId);
        inputPassword = findViewById(R.id.inputPassword);
    }

    public void doLogin(View v) {
        Log.d(TAG, "doLogin: inputUserId = " + inputUserId.getText().toString() + ", inputPassword = " + inputPassword.getText().toString());
        if (TextUtils.isEmpty(inputUserId.getText())) {
            Toast.makeText(this, "Error: por favor introduce tu nómina.", Toast.LENGTH_SHORT).show();
        } else if (TextUtils.isEmpty(inputPassword.getText())) {
            Toast.makeText(this, "Error: por favor introduce tu contraseña.", Toast.LENGTH_SHORT).show();
        } else {
            Log.d(TAG, "doLogin: Calling async task");
            new LoginHelper.LoginManager(this).execute(BuildConfig.API_URL + "/login", inputUserId.getText().toString(), inputPassword.getText().toString());
        }
    }

    @Override
    public void onTaskCompleted(int rc) {
        switch (rc) {
            case LoginHelper.LOGIN_SUCCESS:
                Intent i = new Intent(getApplicationContext(), MainActivity.class);
                startActivity(i);
            break;
            case LoginHelper.LOGIN_FAILED:
                Toast.makeText(this, "Error: la contraseña es incorrecta. Por favor intenta de nuevo.", Toast.LENGTH_SHORT).show();
                inputPassword.setText("");
            break;
            case LoginHelper.CONNECTION_ERR:
                Toast.makeText(this, "Error en la conexión. Por favor intenta más tarde.", Toast.LENGTH_SHORT).show();
            break;
            case LoginHelper.BAD_REQ:
                Toast.makeText(this, "Error en la aplicación. Por favor contacta al equipo de informática.", Toast.LENGTH_SHORT).show();
            break;
            case LoginHelper.USER_NOT_FOUND:
                Toast.makeText(this, "Error: no se encontró un usuario con esa nómina. Por favor intenta de nuevo.", Toast.LENGTH_SHORT).show();
                inputPassword.setText("");
                inputUserId.setText("");
                break;
        }
    }
}
