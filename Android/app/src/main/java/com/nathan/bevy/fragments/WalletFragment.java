package com.nathan.bevy.fragments;

import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;

import androidx.fragment.app.Fragment;

import com.nathan.bevy.MainActivity;
import com.nathan.bevy.NewPwdActivity;
import com.nathan.bevy.R;
import com.nathan.bevy.SettingsEditProfileActivity;
import com.nathan.bevy.TermsActivity;
import com.nathan.bevy.WalletContactsActivity;
import com.nathan.bevy.WalletTopupActivity;

public class WalletFragment extends Fragment implements View.OnClickListener {

    MainActivity mainActivity;

    ImageView ivLeftMenu, ivRightMenu;
    LinearLayout llSend, llRequest, llTopup;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.fragment_wallet, container, false);

        mainActivity = (MainActivity) getActivity();

        ivLeftMenu = v.findViewById(R.id.ivLeftMenu);
        ivLeftMenu.setOnClickListener(this);
        ivRightMenu = v.findViewById(R.id.ivRightMenu);
        ivRightMenu.setOnClickListener(this);
        llSend = v.findViewById(R.id.llSend);
        llSend.setOnClickListener(this);
        llRequest = v.findViewById(R.id.llRequest);
        llRequest.setOnClickListener(this);
        llTopup = v.findViewById(R.id.llTopup);
        llTopup.setOnClickListener(this);

        return v;
    }

    @Override
    public void onClick(View v) {
        Intent intent;
        switch (v.getId()) {
            case R.id.ivLeftMenu:
                mainActivity.showLeftMenu();
                break;
            case R.id.ivRightMenu:
                mainActivity.showRightMenu();
                break;
            case R.id.llSend:
                intent = new Intent(getActivity(), WalletContactsActivity.class);
                intent.putExtra("type", 0); //send
                startActivity(intent);
                break;
            case R.id.llRequest:
                intent = new Intent(getActivity(), WalletContactsActivity.class);
                intent.putExtra("type", 1); //request
                startActivity(intent);
                break;
            case R.id.llTopup:
                intent = new Intent(getActivity(), WalletTopupActivity.class);
                startActivity(intent);
                break;
        }
    }
}