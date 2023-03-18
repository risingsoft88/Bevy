package com.nathan.bevy;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.fragment.app.FragmentActivity;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;

import com.jiangjiesheng.slidingmenu.SlidingMenu;
import com.nathan.bevy.fragments.SettingsFragment;
import com.nathan.bevy.fragments.WalletFragment;

public class MainActivity extends FragmentActivity implements View.OnClickListener {

    SlidingMenu slidingMenu;
    WalletFragment walletFragment = null;
    SettingsFragment settingsFragment = null;
    int currentMenu = -1;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.activity_main);

        initSlideMenus();

        showWalletFragment();
    }


    public void showLeftMenu() {
        if (!slidingMenu.isMenuShowing()) {
            slidingMenu.showMenu(true);
        }
    }

    public void showRightMenu() {
        if (!slidingMenu.isSecondaryMenuShowing()) {
            slidingMenu.showSecondaryMenu(true);
        }
    }

    public void showWalletFragment() {
        if (currentMenu != 0) {
            currentMenu = 0;
            if (walletFragment == null) {
                walletFragment = new WalletFragment();
                Bundle data = new Bundle();
                walletFragment.setArguments(data);
            }

            FragmentManager fragmentManager = getSupportFragmentManager();
            FragmentTransaction ft = fragmentManager.beginTransaction();
            ft.replace(R.id.content_frame_home, walletFragment);
            ft.commit();

            ImageView ivWalletIcon = (ImageView) slidingMenu.findViewById(R.id.ivWalletIcon);
            ivWalletIcon.setImageResource(R.drawable.icon_wallet_enable);
            TextView tvWalletTitle = (TextView) slidingMenu.findViewById(R.id.tvWalletTitle);
            tvWalletTitle.setTextColor(getResources().getColor(R.color.black));
            ImageView ivSettingsIcon = (ImageView) slidingMenu.findViewById(R.id.ivSettingsIcon);
            ivSettingsIcon.setImageResource(R.drawable.icon_settings_disable);
            TextView tvSettingsTitle = (TextView) slidingMenu.findViewById(R.id.tvSettingsTitle);
            tvSettingsTitle.setTextColor(getResources().getColor(R.color.gray_half));
        }
    }

    public void showSettingsFragment() {
        if (currentMenu != 1) {
            currentMenu = 1;
            settingsFragment = new SettingsFragment();
            Bundle data = new Bundle();
            settingsFragment.setArguments(data);
            FragmentManager fragmentManager = getSupportFragmentManager();
            FragmentTransaction ft = fragmentManager.beginTransaction();
            ft.replace(R.id.content_frame_home, settingsFragment);
            ft.commit();

            ImageView ivWalletIcon = (ImageView) slidingMenu.findViewById(R.id.ivWalletIcon);
            ivWalletIcon.setImageResource(R.drawable.icon_wallet_disable);
            TextView tvWalletTitle = (TextView) slidingMenu.findViewById(R.id.tvWalletTitle);
            tvWalletTitle.setTextColor(getResources().getColor(R.color.gray_half));
            ImageView ivSettingsIcon = (ImageView) slidingMenu.findViewById(R.id.ivSettingsIcon);
            ivSettingsIcon.setImageResource(R.drawable.icon_settings_enable);
            TextView tvSettingsTitle = (TextView) slidingMenu.findViewById(R.id.tvSettingsTitle);
            tvSettingsTitle.setTextColor(getResources().getColor(R.color.black));
        }
    }

    public void initSlideMenus() {
        slidingMenu = new SlidingMenu(this);
        slidingMenu.setMode(SlidingMenu.LEFT_RIGHT);
        slidingMenu.setTouchModeAbove(SlidingMenu.TOUCHMODE_NONE);
        slidingMenu.setShadowWidthRes(R.dimen.shadow_width);
        slidingMenu.setBehindOffsetRes(R.dimen.slidingmenu_offset);
        slidingMenu.setFadeDegree(0.35f);
        slidingMenu.attachToActivity(this, SlidingMenu.SLIDING_CONTENT);
        slidingMenu.setMenu(R.layout.slidingmenu_left);
        slidingMenu.setSecondaryMenu(R.layout.slidingmenu_right);

        LinearLayout llWallet = (LinearLayout) slidingMenu.findViewById(R.id.llWallet);
        llWallet.setOnClickListener(this);
        LinearLayout llSettings = (LinearLayout) slidingMenu.findViewById(R.id.llSettings);
        llSettings.setOnClickListener(this);
        LinearLayout llLogout = (LinearLayout) slidingMenu.findViewById(R.id.llLogout);
        llLogout.setOnClickListener(this);

        LinearLayout llAccounts = (LinearLayout) slidingMenu.findViewById(R.id.llAccounts);
        llAccounts.setOnClickListener(this);
        LinearLayout llP2P = (LinearLayout) slidingMenu.findViewById(R.id.llP2P);
        llP2P.setOnClickListener(this);
        LinearLayout llSavings = (LinearLayout) slidingMenu.findViewById(R.id.llSavings);
        llSavings.setOnClickListener(this);
        LinearLayout llSupport = (LinearLayout) slidingMenu.findViewById(R.id.llSupport);
        llSupport.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        Intent intent;
        switch (v.getId()) {
            case R.id.llWallet:
                slidingMenu.toggle(true);
                showWalletFragment();
                break;
            case R.id.llSettings:
                slidingMenu.toggle(true);
                showSettingsFragment();
                break;
            case R.id.llLogout:
                slidingMenu.toggle(true);
                finish();
                break;
            case R.id.llAccounts:
                intent = new Intent(MainActivity.this, WalletAccountsActivity.class);
                startActivity(intent);
                slidingMenu.toggle(true);
                break;
            case R.id.llP2P:
                intent = new Intent(MainActivity.this, WalletContactsActivity.class);
                intent.putExtra("type", 0); //send
                startActivity(intent);
                slidingMenu.toggle(true);
                break;
            case R.id.llSavings:
                intent = new Intent(MainActivity.this, WalletSavingsActivity.class);
                startActivity(intent);
                slidingMenu.toggle(true);
                break;
            case R.id.llSupport:
                intent = new Intent(MainActivity.this, SupportActivity.class);
                startActivity(intent);
                slidingMenu.toggle(true);
                break;
        }
    }
}