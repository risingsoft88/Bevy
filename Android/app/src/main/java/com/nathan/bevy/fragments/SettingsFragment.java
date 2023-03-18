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
import com.nathan.bevy.SignupActivity;
import com.nathan.bevy.TermsActivity;

public class SettingsFragment extends Fragment implements View.OnClickListener {

    MainActivity mainActivity;

    ImageView ivLeftMenu;
    LinearLayout llEditProfile, llChangePassword, llTerms, llCopyright, llPrivacy;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.fragment_settings, container, false);

        mainActivity = (MainActivity) getActivity();

        ivLeftMenu = v.findViewById(R.id.ivLeftMenu);
        ivLeftMenu.setOnClickListener(this);
        llEditProfile = v.findViewById(R.id.llEditProfile);
        llEditProfile.setOnClickListener(this);
        llChangePassword = v.findViewById(R.id.llChangePassword);
        llChangePassword.setOnClickListener(this);
        llTerms = v.findViewById(R.id.llTerms);
        llTerms.setOnClickListener(this);
        llCopyright = v.findViewById(R.id.llCopyright);
        llCopyright.setOnClickListener(this);
        llPrivacy = v.findViewById(R.id.llPrivacy);
        llPrivacy.setOnClickListener(this);

        return v;
    }

    @Override
    public void onClick(View v) {
        Intent intent;
        switch (v.getId()) {
            case R.id.ivLeftMenu:
                mainActivity.showLeftMenu();
                break;
            case R.id.llEditProfile:
                startActivity(new Intent(getActivity(), SettingsEditProfileActivity.class));
                break;
            case R.id.llChangePassword:
                startActivity(new Intent(getActivity(), NewPwdActivity.class));
                break;
            case R.id.llTerms:
                intent = new Intent(getActivity(), TermsActivity.class);
                intent.putExtra("type", 0); //terms
                startActivity(intent);
                break;
            case R.id.llCopyright:
                intent = new Intent(getActivity(), TermsActivity.class);
                intent.putExtra("type", 1); //copyright
                startActivity(intent);
                break;
            case R.id.llPrivacy:
                intent = new Intent(getActivity(), TermsActivity.class);
                intent.putExtra("type", 2); //privacy
                startActivity(intent);
                break;
        }
    }
}