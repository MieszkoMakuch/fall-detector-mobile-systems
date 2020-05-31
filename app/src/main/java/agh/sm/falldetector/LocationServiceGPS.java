package agh.sm.falldetector;

import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.location.Location;
import android.location.LocationManager;
import android.os.Bundle;
import android.os.IBinder;
import android.util.Log;

public class LocationServiceGPS extends Service {
    private static final String TAG = "AGH_IM_GPS";
    private static final int INTERVAL_OF_LOCATION = 1000;
    private static final float LOCATION_DISTANCE = 1f;
    public static final String CANNOT_REQUEST_LOCATION_UPDATE_MSG = "Cannot request location update";
    public static LocationServiceGPS ThisInstance;
    private LocationManager mLocationManager = null;
    private AndoridLocListenerImpl[] mAndoridLocListenerImpls = new AndoridLocListenerImpl[]{
            new AndoridLocListenerImpl(LocationManager.GPS_PROVIDER),
            new AndoridLocListenerImpl(LocationManager.NETWORK_PROVIDER)
    };

    @Override
    public IBinder onBind(Intent arg0) {
        return null;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        super.onStartCommand(intent, flags, startId);
        return START_NOT_STICKY;
    }

    @Override
    public void onCreate() {
        ThisInstance = this;
        initializeLocationManager();
        reqestNetworkLocation();
        requestGPSLocation();
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (mLocationManager != null) {
            for (AndoridLocListenerImpl mAndoridLocListenerImpl : mAndoridLocListenerImpls) {
                try {
                    mLocationManager.removeUpdates(mAndoridLocListenerImpl);
                } catch (Exception ex) {
                    Log.i(TAG, "Cannot remove listeners", ex);
                }
            }
        }
    }

    private void initializeLocationManager() {
        if (mLocationManager == null) {
            mLocationManager = (LocationManager) getApplicationContext().getSystemService(Context.LOCATION_SERVICE);
        }
    }

    private void requestGPSLocation() {
        try {
            mLocationManager.requestLocationUpdates(
                    LocationManager.GPS_PROVIDER, INTERVAL_OF_LOCATION, LOCATION_DISTANCE,
                    mAndoridLocListenerImpls[0]);
        } catch (SecurityException ex) {
            Log.i(TAG, CANNOT_REQUEST_LOCATION_UPDATE_MSG, ex);

        } catch (IllegalArgumentException ex) {
            Log.d(TAG, "Cannot find GPS provider " + ex.getMessage());
        }
    }

    private void reqestNetworkLocation() {
        try {
            mLocationManager.requestLocationUpdates(
                    LocationManager.NETWORK_PROVIDER, INTERVAL_OF_LOCATION, LOCATION_DISTANCE,
                    mAndoridLocListenerImpls[1]);
        } catch (SecurityException ex) {
            Log.i(TAG, CANNOT_REQUEST_LOCATION_UPDATE_MSG, ex);
        } catch (IllegalArgumentException ex) {
            Log.d(TAG, "Cannot find network provider" + ex.getMessage());
        }
    }

    private class AndoridLocListenerImpl implements android.location.LocationListener {
        Location mLastLocation;

        public AndoridLocListenerImpl(String provider) {
            mLastLocation = new Location(provider);
        }

        @Override
        public void onLocationChanged(Location location) {
            if (Patient.ThisInstance != null) {
                Patient.updateGPSLatLng(location);
                Patient.ThisInstance.updateStatusJsonString();
            }
            mLastLocation.set(location);
        }

        @Override
        public void onProviderDisabled(String provider) {
            Log.e(TAG, "Provider disabled: " + provider);
        }

        @Override
        public void onProviderEnabled(String provider) {
            Log.e(TAG, "Provider enabled: " + provider);
        }

        @Override
        public void onStatusChanged(String provider, int status, Bundle extras) {
            Log.e(TAG, "Status changed: " + provider);
        }
    }
}
