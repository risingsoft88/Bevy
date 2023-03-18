package com.nathan.bevy;

import android.app.Application;

import com.google.android.libraries.places.api.Places;
import com.nathan.bevy.models.StateModel;

import java.util.ArrayList;
import java.util.List;

public class BevyApplication extends Application {

    private static final String GOOGLEPLACES_APIKEY = "AIzaSyDsTupX6E0G9pHKjJjGYIFibu4dg68oJ1o";
    public List<StateModel> states = new ArrayList<StateModel>();

    @Override
    public void onCreate() {
        super.onCreate();

        initGooglePlaces();

        states.add(new StateModel("AL", "Alabama"));
        states.add(new StateModel("AK", "Alaska"));
        states.add(new StateModel("AZ", "Arizona"));
        states.add(new StateModel("AR", "Arkansas"));
        states.add(new StateModel("CA", "California"));
        states.add(new StateModel("CO", "Colorado"));
        states.add(new StateModel("CT", "Connecticut"));
        states.add(new StateModel("DE", "Delaware"));
        states.add(new StateModel("DC", "District Of Columbia"));
        states.add(new StateModel("FL", "Florida"));
        states.add(new StateModel("GA", "Georgia"));
        states.add(new StateModel("HI", "Hawaii"));
        states.add(new StateModel("ID", "Idaho"));
        states.add(new StateModel("IL", "Illinois"));
        states.add(new StateModel("IN", "Indiana"));
        states.add(new StateModel("IA", "Iowa"));
        states.add(new StateModel("KS", "Kansas"));
        states.add(new StateModel("KY", "Kentucky"));
        states.add(new StateModel("LA", "Louisiana"));
        states.add(new StateModel("ME", "Maine"));
        states.add(new StateModel("MD", "Maryland"));
        states.add(new StateModel("MA", "Massachusetts"));
        states.add(new StateModel("MI", "Michigan"));
        states.add(new StateModel("MN", "Minnesota"));
        states.add(new StateModel("MS", "Mississippi"));
        states.add(new StateModel("MO", "Missouri"));
        states.add(new StateModel("MT", "Montana"));
        states.add(new StateModel("NE", "Nebraska"));
        states.add(new StateModel("NV", "Nevada"));
        states.add(new StateModel("NH", "New Hampshire"));
        states.add(new StateModel("NJ", "New Jersey"));
        states.add(new StateModel("NM", "New Mexico"));
        states.add(new StateModel("NY", "New York"));
        states.add(new StateModel("NC", "North Carolina"));
        states.add(new StateModel("ND", "North Dakota"));
        states.add(new StateModel("OH", "Ohio"));
        states.add(new StateModel("OK", "Oklahoma"));
        states.add(new StateModel("OR", "Oregon"));
        states.add(new StateModel("PA", "Pennsylvania"));
        states.add(new StateModel("RI", "Rhode Island"));
        states.add(new StateModel("SC", "South Carolina"));
        states.add(new StateModel("SD", "South Dakota"));
        states.add(new StateModel("TN", "Tennessee"));
        states.add(new StateModel("TX", "Texas"));
        states.add(new StateModel("UT", "Utah"));
        states.add(new StateModel("VT", "Vermont"));
        states.add(new StateModel("VA", "Virginia"));
        states.add(new StateModel("WA", "Washington"));
        states.add(new StateModel("WV", "West Virginia"));
        states.add(new StateModel("WI", "Wisconsin"));
        states.add(new StateModel("WY", "Wyoming"));

//        Globals.myDrafts = PrefHelper.readReportDrafts(getApplicationContext());
//        Globals.myReports = new ArrayList<>();
////        Globals.myReports = PrefHelper.readSentReports(getApplicationContext());
//        Globals.curUser = PrefHelper.readUserInfo(getApplicationContext());
////        initImageLoader(getApplicationContext());
//
//        try {
//            Globals.gpsTracker = new GPSTracker(this);
//        } catch (Exception ex) {
//        }
    }

//    private void initImageLoader(Context context) {
//        File cacheDir = StorageUtils.getOwnCacheDirectory(context,
//                "Bevy_Cache");
//        int availableMemory = (int) Runtime.getRuntime().maxMemory() / 6;
//
//        ImageLoaderConfiguration config = new ImageLoaderConfiguration.Builder(
//                context).threadPriority(Thread.NORM_PRIORITY - 1)
//                .threadPoolSize(3).diskCache(new UnlimitedDiskCache(cacheDir))
//                .denyCacheImageMultipleSizesInMemory()
//                .memoryCache(new WeakMemoryCache())
//                .memoryCacheSize(availableMemory)
//                .diskCacheFileNameGenerator(new Md5FileNameGenerator())
//                .tasksProcessingOrder(QueueProcessingType.FIFO)
//                .writeDebugLogs() // Remove for release app
//                .build();
//        // Initialize ImageLoader with configuration.
//        ImageLoader.getInstance().init(config);
//    }

    private void initGooglePlaces() {
        Places.initialize(getApplicationContext(), GOOGLEPLACES_APIKEY);
    }

}