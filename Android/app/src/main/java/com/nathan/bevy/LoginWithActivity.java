package com.nathan.bevy;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.widget.ImageView;

import java.util.Random;

public class LoginWithActivity extends Activity implements View.OnClickListener {

    ImageView ivLogin, ivSignup, ivFacebook, ivTwitter, ivGoogle, ivBackground;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.activity_loginwith);

        ivLogin = (ImageView) findViewById(R.id.ivLogin);
        ivLogin.setOnClickListener(this);
        ivSignup = (ImageView) findViewById(R.id.ivSignup);
        ivSignup.setOnClickListener(this);
        ivFacebook = (ImageView) findViewById(R.id.ivFacebook);
        ivFacebook.setOnClickListener(this);
        ivTwitter = (ImageView) findViewById(R.id.ivTwitter);
        ivTwitter.setOnClickListener(this);
        ivGoogle = (ImageView) findViewById(R.id.ivGoogle);
        ivGoogle.setOnClickListener(this);
        ivBackground = (ImageView) findViewById(R.id.ivBackground);

        Random r = new Random();
        int randomValue = r.nextInt(3);
        if (randomValue == 2) {
            ivBackground.setImageResource(R.drawable.screen_loginwith03);
        } else if (randomValue == 1) {
            ivBackground.setImageResource(R.drawable.screen_loginwith02);
        } else {
            ivBackground.setImageResource(R.drawable.screen_loginwith01);
        }
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.ivLogin:
                startActivity(new Intent(LoginWithActivity.this, LoginActivity.class));
                break;
            case R.id.ivSignup:
                startActivity(new Intent(LoginWithActivity.this, SignupActivity.class));
                break;
            case R.id.ivFacebook:
                break;
            case R.id.ivTwitter:
                break;
            case R.id.ivGoogle:
                break;
        }
    }
}