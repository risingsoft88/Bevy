package com.nathan.bevy;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.widget.ImageView;
import android.widget.TextView;

public class WalletSavingsActivity extends Activity implements View.OnClickListener {

    ImageView ivBack, ivPlus;
    TextView tvCashout;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.activity_walletsavings);

        ivBack = (ImageView) findViewById(R.id.ivBack);
        ivBack.setOnClickListener(this);
        ivPlus = (ImageView) findViewById(R.id.ivPlus);
        ivPlus.setOnClickListener(this);
        tvCashout = (TextView) findViewById(R.id.tvCashout);
        tvCashout.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.ivBack:
                finish();
                break;
            case R.id.ivPlus:
//                startActivity(new Intent(WalletSavingsActivity.this, WalletCreateSavingActivity.class));
                break;
            case R.id.tvCashout:
                finish();
                break;
        }
    }
}