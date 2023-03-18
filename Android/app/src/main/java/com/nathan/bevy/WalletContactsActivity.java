package com.nathan.bevy;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.widget.ImageView;
import android.widget.LinearLayout;

public class WalletContactsActivity  extends Activity implements View.OnClickListener {

    ImageView ivBack;
    LinearLayout llContact;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.activity_walletcontacts);

        ivBack = (ImageView) findViewById(R.id.ivBack);
        ivBack.setOnClickListener(this);
        llContact = (LinearLayout) findViewById(R.id.llContact);
        llContact.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.ivBack:
                finish();
                break;
            case R.id.llContact:
                Intent intent = new Intent(WalletContactsActivity.this, WalletSendMoneyActivity.class);
                intent.putExtra("type", 0); //send
                startActivity(intent);
                break;
        }
    }
}