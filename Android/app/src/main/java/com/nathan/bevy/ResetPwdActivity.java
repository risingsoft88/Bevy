package com.nathan.bevy;

import android.app.Activity;
import android.os.Bundle;
import android.view.Window;

public class ResetPwdActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.activity_resetpwd);
    }

}