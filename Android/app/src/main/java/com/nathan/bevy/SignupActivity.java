package com.nathan.bevy;

import android.Manifest;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;
import android.text.method.HideReturnsTransformationMethod;
import android.text.method.PasswordTransformationMethod;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.RequiresApi;
import androidx.core.app.ActivityCompat;
import androidx.fragment.app.FragmentActivity;

import com.bumptech.glide.Glide;
import com.google.android.libraries.places.api.model.AddressComponent;
import com.google.android.libraries.places.api.model.Place;
import com.google.android.libraries.places.api.model.TypeFilter;
import com.google.android.libraries.places.widget.Autocomplete;
import com.google.android.libraries.places.widget.model.AutocompleteActivityMode;
import com.kbeanie.multipicker.api.CacheLocation;
import com.kbeanie.multipicker.api.CameraImagePicker;
import com.kbeanie.multipicker.api.ImagePicker;
import com.kbeanie.multipicker.api.Picker;
import com.kbeanie.multipicker.api.callbacks.ImagePickerCallback;
import com.kbeanie.multipicker.api.entity.ChosenImage;
import com.mikhaellopez.circularimageview.CircularImageView;
import com.nathan.bevy.models.StateModel;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class SignupActivity extends FragmentActivity implements View.OnClickListener, ImagePickerCallback, View.OnFocusChangeListener {

    ImageView ivBack, ivCreate, ivCheckTerms, ivShowPwd;
    CircularImageView ivAvatar;
    TextView tvTerms, tvSignin;
    EditText etFirstname, etLastname, etUsername, etEmail, etPhone, etPassword, etAddress, etCity, etState, etZip;

    private boolean bTermsChecked = false;
    private boolean bShowPassword = false;
    private String pickerPath;
    private ImagePicker imagePicker;
    private CameraImagePicker cameraPicker;
    List<String> stateArray = new ArrayList<String>();

    private static int AUTOCOMPLETE_REQUEST_CODE = 1;

    @RequiresApi(api = Build.VERSION_CODES.HONEYCOMB)
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.activity_signup);

        ivBack = (ImageView) findViewById(R.id.ivBack);
        ivBack.setOnClickListener(this);
        ivCreate = (ImageView) findViewById(R.id.ivCreate);
        ivCreate.setOnClickListener(this);
        ivCheckTerms = (ImageView) findViewById(R.id.ivCheckTerms);
        ivCheckTerms.setOnClickListener(this);
        ivShowPwd = (ImageView) findViewById(R.id.ivShowPwd);
        ivShowPwd.setOnClickListener(this);
        ivAvatar = (CircularImageView) findViewById(R.id.ivAvatar);
        ivAvatar.setOnClickListener(this);
        tvTerms = (TextView) findViewById(R.id.tvTerms);
        tvTerms.setOnClickListener(this);
        tvSignin = (TextView) findViewById(R.id.tvSignin);
        tvSignin.setOnClickListener(this);
        etFirstname = (EditText) findViewById(R.id.etFirstname);
        etLastname = (EditText) findViewById(R.id.etLastname);
        etUsername = (EditText) findViewById(R.id.etUsername);
        etEmail = (EditText) findViewById(R.id.etEmail);
        etPhone = (EditText) findViewById(R.id.etPhone);
        etPassword = (EditText) findViewById(R.id.etPassword);
        etAddress = (EditText) findViewById(R.id.etAddress);
        etAddress.setOnFocusChangeListener(this);
        etCity = (EditText) findViewById(R.id.etCity);
        etState = (EditText) findViewById(R.id.etState);
        etState.setOnFocusChangeListener(this);
        etZip = (EditText) findViewById(R.id.etZip);


        showTermsChecked();
        showPassword();
    }

    private void hideKeyboard() {
        InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
        imm.toggleSoftInput(InputMethodManager.HIDE_IMPLICIT_ONLY, 0);
    }

    private void showTermsChecked() {
        if (bTermsChecked) {
            ivCheckTerms.setImageResource(R.drawable.img_check_on);
        } else {
            ivCheckTerms.setImageResource(R.drawable.img_check_off);
        }
    }

    private void showPassword() {
        if (bShowPassword) {
            etPassword.setTransformationMethod(HideReturnsTransformationMethod.getInstance());
        } else {
            etPassword.setTransformationMethod(PasswordTransformationMethod.getInstance());
        }
    }

    @Override
    public void onClick(View v) {
        Intent intent;
        switch (v.getId()) {
            case R.id.ivBack:
                finish();
                break;
            case R.id.ivCreate:
                startActivity(new Intent(SignupActivity.this, WelcomeActivity.class));
                break;
            case R.id.ivCheckTerms:
                bTermsChecked = !bTermsChecked;
                showTermsChecked();
                break;
            case R.id.ivShowPwd:
                bShowPassword = !bShowPassword;
                showPassword();
                break;
            case R.id.ivAvatar:
                final CharSequence[] items = {"Take Photo", "Choose from Library", "Cancel"};
                AlertDialog.Builder builder = new AlertDialog.Builder(SignupActivity.this);
                builder.setTitle("Choose Image");
                builder.setItems(items, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int item) {
                        if (items[item].equals("Take Photo")) {
                            takePhoto();
                        } else if (items[item].equals("Choose from Library")) {
                            requestPermissions();
                        } else if (items[item].equals("Cancel")) {
                            dialog.dismiss();
                        }
                    }
                });
                builder.show();
                break;
            case R.id.tvTerms:
                intent = new Intent(SignupActivity.this, TermsActivity.class);
                intent.putExtra("type", 0); //terms
                startActivity(intent);
                break;
            case R.id.tvSignin:
                startActivity(new Intent(SignupActivity.this, LoginActivity.class));
                break;
        }
    }

    private void takePhoto() {
        cameraPicker = new CameraImagePicker(this);
        cameraPicker.setDebugglable(true);
        cameraPicker.setCacheLocation(CacheLocation.EXTERNAL_STORAGE_APP_DIR);
        cameraPicker.setImagePickerCallback(this);
        cameraPicker.shouldGenerateMetadata(true);
        cameraPicker.shouldGenerateThumbnails(true);
        pickerPath = cameraPicker.pickImage();
    }

    private void requestPermissions() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            boolean needsRead = ActivityCompat.checkSelfPermission(this, Manifest.permission.READ_EXTERNAL_STORAGE)
                    != PackageManager.PERMISSION_GRANTED;

            boolean needsWrite = ActivityCompat.checkSelfPermission(this, Manifest.permission.WRITE_EXTERNAL_STORAGE)
                    != PackageManager.PERMISSION_GRANTED;

            if (needsRead || needsWrite) {
                if (!Settings.System.canWrite(this)) {
                    requestPermissions(new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE,
                            Manifest.permission.READ_EXTERNAL_STORAGE}, 2909);
                }
            } else {
                openLibrary();
            }
        }
    }

    private void openLibrary() {
        imagePicker = new ImagePicker(this);
        imagePicker.setDebugglable(true);
//        imagePicker.setFolderName("Random");
        imagePicker.setRequestId(1234);
        imagePicker.ensureMaxSize(500, 500);
        imagePicker.shouldGenerateMetadata(true);
        imagePicker.shouldGenerateThumbnails(true);
        imagePicker.setImagePickerCallback(this);
        Bundle bundle = new Bundle();
        bundle.putInt("android.intent.extras.CAMERA_FACING", 1);
//        imagePicker.setCacheLocation(CacheLocation.EXTERNAL_STORAGE_PUBLIC_DIR);
        imagePicker.setCacheLocation(CacheLocation.EXTERNAL_STORAGE_APP_DIR);
        imagePicker.pickImage();
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        switch (requestCode) {
            case 2909: {
                if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    Log.e("Permission", "Granted");
                    openLibrary();
                } else {
                    Log.e("Permission", "Denied");
                }
                return;
            }
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == SignupActivity.RESULT_OK) {
            if (requestCode == Picker.PICK_IMAGE_DEVICE) {
                if (imagePicker == null) {
                    imagePicker = new ImagePicker(this);
                    imagePicker.setImagePickerCallback(this);
                }
                imagePicker.submit(data);
            } else if (requestCode == Picker.PICK_IMAGE_CAMERA) {
                if (cameraPicker == null) {
                    cameraPicker = new CameraImagePicker(this);
                    cameraPicker.setImagePickerCallback(this);
                    cameraPicker.reinitialize(pickerPath);
                }
                cameraPicker.submit(data);
            } else if (requestCode == AUTOCOMPLETE_REQUEST_CODE) {
                hideKeyboard();

                Place place = Autocomplete.getPlaceFromIntent(data);
                etAddress.setText(place.getName());
                for (AddressComponent component : place.getAddressComponents().asList()) {
                    for (String type : component.getTypes()) {
                        if (type.equals("locality")) {
                            etCity.setText(component.getName());
                        } else if (type.equals("administrative_area_level_1")) {
                            etState.setText(component.getShortName() + " - " + component.getName());
                        } else if (type.equals("postal_code")) {
                            etZip.setText(component.getName());
                        }
                    }
                }
            }
        }
    }

    @Override
    public void onImagesChosen(List<ChosenImage> images) {
        if (images.size() > 0) {
            ChosenImage image = images.get(0);
            if (image.getOriginalPath() != null) {
                Glide.with(SignupActivity.this).load(Uri.fromFile(new File(image.getOriginalPath()))).into(ivAvatar);
            }
        }
    }

    @Override
    public void onError(String message) {
        Toast.makeText(this, message, Toast.LENGTH_LONG).show();
    }

    @Override
    protected void onSaveInstanceState(Bundle outState) {
        // You have to save path in case your activity is killed.
        // In such a scenario, you will need to re-initialize the CameraImagePicker
        outState.putString("picker_path", pickerPath);
        super.onSaveInstanceState(outState);
    }

    @Override
    protected void onRestoreInstanceState(Bundle savedInstanceState) {
        // After Activity recreate, you need to re-intialize these
        // two values to be able to re-intialize CameraImagePicker
        if (savedInstanceState != null) {
            if (savedInstanceState.containsKey("picker_path")) {
                pickerPath = savedInstanceState.getString("picker_path");
            }
        }
        super.onRestoreInstanceState(savedInstanceState);
    }

    @Override
    public void onFocusChange(View v, boolean hasFocus) {
        switch (v.getId()) {
            case R.id.etAddress:
                if (hasFocus) {
                    List<Place.Field> fields = Arrays.asList(Place.Field.NAME, Place.Field.ADDRESS_COMPONENTS);
                    Intent intent = new Autocomplete.IntentBuilder(AutocompleteActivityMode.FULLSCREEN, fields).setCountry("US").setTypeFilter(TypeFilter.ADDRESS)
                            .build(SignupActivity.this);
                    startActivityForResult(intent, AUTOCOMPLETE_REQUEST_CODE);
                }
                break;
            case R.id.etState:
                if (hasFocus) {
                    int index = 0;
                    List<StateModel> states = ((BevyApplication) getApplication()).states;
                    for (int i = 0; i < states.size(); i ++) {
                        StateModel stateModel = states.get(i);
                        String str = stateModel.code + " - " + stateModel.name;
                        stateArray.add(str);
                    }
                    for (int i = 0; i < stateArray.size(); i ++) {
                        String str = stateArray.get(i);
                        if (str.equals(etState.getText().toString())) {
                            index = i;
                            break;
                        }
                    }
                    new AlertDialog.Builder(SignupActivity.this)
                        .setSingleChoiceItems(stateArray.toArray(new String[stateArray.size()]), index, null)
                        .setPositiveButton("Ok", new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int whichButton) {
                                dialog.dismiss();
                                hideKeyboard();
                                int selectedPosition = ((AlertDialog)dialog).getListView().getCheckedItemPosition();
                                etState.setText(stateArray.get(selectedPosition));
                            }
                        })
                        .setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int arg1){
                                dialog.dismiss();
                            }
                        })
                        .show();
                }
                break;
        }

    }
}