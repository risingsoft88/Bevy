package com.nathan.bevy;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.os.Handler;
import android.view.Window;

public class SplashActivity extends Activity {
    SharedPreferences prefs;
//    SharedPreferences.Editor editor;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.activity_splash);

        prefs = getSharedPreferences("bevy_preferences",
                Context.MODE_PRIVATE);
//        editor = prefs.edit();
//        editor.putInt("logedin", 1);
//        editor.putString("logedin_email", email);
//        editor.putString("logedin_pwd", pwd);
//        editor.apply();
        boolean remember = prefs.getBoolean("remember", false);
        String userEmail = prefs.getString("userEmail", "");
        String userPwd = prefs.getString("userPwd", "");

        final Handler handler = new Handler();
        handler.postDelayed(new Runnable() {
            @Override
            public void run() {
                if (remember && !userEmail.isEmpty() && !userPwd.isEmpty()) {
                    startActivity(new Intent(SplashActivity.this, LoginActivity.class));
                } else {
                    startActivity(new Intent(SplashActivity.this, LoginWithActivity.class));
                }
                finish();
            }
        }, 3000); // After 3 seconds
    }

}