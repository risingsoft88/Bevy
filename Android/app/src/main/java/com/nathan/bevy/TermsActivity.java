package com.nathan.bevy;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

public class TermsActivity extends Activity implements View.OnClickListener {

    ImageView ivBack;
    EditText etContent;
    TextView tvTitle;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.activity_terms);

        ivBack = (ImageView) findViewById(R.id.ivBack);
        ivBack.setOnClickListener(this);
        tvTitle = (TextView) findViewById(R.id.tvTitle);
        etContent = (EditText) findViewById(R.id.etContent);
        int nType = getIntent().getIntExtra("type", 0);
        if (nType == 0) {
            tvTitle.setText("Terms &\n Conditions");
            etContent.setText(R.string.terms_string);
        } else if (nType == 1) {
            tvTitle.setText("Copyright\nPolicy");
            etContent.setText(R.string.copyright_string);
        } else if (nType == 2) {
            tvTitle.setText("Privacy\nPolicy");
            etContent.setText(R.string.privacy_string);
        } else {
            etContent.setText("");
        }
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.ivBack:
                finish();
                break;
        }
    }
}