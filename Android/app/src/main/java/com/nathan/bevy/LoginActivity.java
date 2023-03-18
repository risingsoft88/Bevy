package com.nathan.bevy;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.widget.ImageView;
import android.widget.TextView;

public class LoginActivity extends Activity implements View.OnClickListener {

    ImageView ivBack, ivSignin, ivShowPwd, ivSwitchRemember;
    TextView tvForgotPwd, tvSigninOtherAccount, tvSignup;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.activity_login);

        ivBack = (ImageView) findViewById(R.id.ivBack);
        ivBack.setOnClickListener(this);
        ivSignin = (ImageView) findViewById(R.id.ivSignin);
        ivSignin.setOnClickListener(this);
        ivShowPwd = (ImageView) findViewById(R.id.ivShowPwd);
        ivShowPwd.setOnClickListener(this);
        ivSwitchRemember = (ImageView) findViewById(R.id.ivSwitchRemember);
        ivSwitchRemember.setOnClickListener(this);
        tvForgotPwd = (TextView) findViewById(R.id.tvForgotPwd);
        tvForgotPwd.setOnClickListener(this);
        tvSigninOtherAccount = (TextView) findViewById(R.id.tvSigninOtherAccount);
        tvSigninOtherAccount.setOnClickListener(this);
        tvSignup = (TextView) findViewById(R.id.tvSignup);
        tvSignup.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.ivBack:
                finish();
                break;
            case R.id.ivSignin:
                startActivity(new Intent(LoginActivity.this, WelcomeActivity.class));
                break;
            case R.id.ivShowPwd:
                break;
            case R.id.ivSwitchRemember:
                break;
            case R.id.tvForgotPwd:
                startActivity(new Intent(LoginActivity.this, ResetPwdActivity.class));
                break;
            case R.id.tvSigninOtherAccount:
                break;
            case R.id.tvSignup:
                startActivity(new Intent(LoginActivity.this, SignupActivity.class));
                break;
        }
    }
}