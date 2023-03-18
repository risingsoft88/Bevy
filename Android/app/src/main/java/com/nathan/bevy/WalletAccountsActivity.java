package com.nathan.bevy;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.widget.ImageView;
import android.widget.LinearLayout;

public class WalletAccountsActivity extends Activity implements View.OnClickListener {

    ImageView ivBack;
    LinearLayout llAddCard;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.activity_walletaccounts);

        ivBack = (ImageView) findViewById(R.id.ivBack);
        ivBack.setOnClickListener(this);
        llAddCard = (LinearLayout) findViewById(R.id.llAddCard);
        llAddCard.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.ivBack:
                finish();
                break;
            case R.id.llAddCard:
//                startActivity(new Intent(WalletAccountsActivity.this, WalletAddCardActivity.class));
                break;
        }
    }
}