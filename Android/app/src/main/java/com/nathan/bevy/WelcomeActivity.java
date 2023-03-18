package com.nathan.bevy;

import android.app.Activity;
import android.app.ActivityOptions;
import android.content.Intent;
import android.os.Bundle;
import android.view.Window;
import android.widget.ImageView;
import android.widget.Toast;

import com.nathan.bevy.listeners.OnSwipeTouchListener;

public class WelcomeActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.activity_welcome);

        ImageView ivWelcome = (ImageView) findViewById(R.id.ivWelcome);
        ivWelcome.setOnTouchListener(new OnSwipeTouchListener(WelcomeActivity.this) {
            public void onSwipeLeft() {
                startActivity(new Intent(WelcomeActivity.this, MainActivity.class));
                finish();
//                overridePendingTransition(R.anim.enter, R.anim.exit);
            }
        });
    }

}