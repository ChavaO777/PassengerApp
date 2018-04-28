package com.example.andresr.passengerappandroid.activities;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

import com.example.andresr.passengerappandroid.R;

public class LoginActivity extends AppCompatActivity {

    Button loginButton;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);
        loginButton = findViewById(R.id.loginButton);
    }

    public void doLogin(View v) {
        // Check login
        Intent i = new Intent(getApplicationContext(), MainActivity.class);
        startActivity(i);

    }
}
