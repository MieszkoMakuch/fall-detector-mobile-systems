package agh.sm.falldetector;

import android.location.Location;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.view.View;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.location.LocationListener;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.maps.CameraUpdate;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.model.*;

public class GoogleMapsFrame extends com.google.android.gms.maps.MapFragment implements GoogleApiClient.ConnectionCallbacks,
        GoogleApiClient.OnConnectionFailedListener,
        GoogleMap.OnInfoWindowClickListener,
        GoogleMap.OnMapLongClickListener,
        GoogleMap.OnMapClickListener,
        GoogleMap.OnMarkerClickListener,
        LocationListener {

    public static GoogleMapsFrame googleMapsFrame;
    private final int[] MAP_TYPES = {GoogleMap.MAP_TYPE_SATELLITE,
            GoogleMap.MAP_TYPE_NORMAL,
            GoogleMap.MAP_TYPE_HYBRID,
            GoogleMap.MAP_TYPE_TERRAIN,
            GoogleMap.MAP_TYPE_NONE};
    private GoogleApiClient googleApiClient;
    private Marker posMarker = null;

    public void updateMonitoredUserLocation(Location location) {
        if (location == null) {
            return;
        }
        LatLng latLng = new LatLng(location.getLatitude(), location.getLongitude());
        if (posMarker != null) {
            posMarker.setPosition(latLng);
        }
        CameraUpdate center = CameraUpdateFactory.newLatLng(latLng);
        if (getMap() != null) {
            getMap().moveCamera(center);
        }

    }

    public void onLocationChanged(Location location) {

    }

    @Override
    public void onConnectionSuspended(int i) {

    }

    @Override
    public void onConnectionFailed(@NonNull ConnectionResult connectionResult) {

    }

    @Override
    public void onInfoWindowClick(Marker marker) {

    }

    @Override
    public void onMapLongClick(LatLng latLng) {

    }

    @Override
    public boolean onMarkerClick(Marker marker) {
        marker.showInfoWindow();
        return true;
    }

    private void initListeners() {
        getMap().setOnMarkerClickListener(this);
        getMap().setOnMapLongClickListener(this);
        getMap().setOnInfoWindowClickListener(this);
        getMap().setOnMapClickListener(this);
    }

    @Override
    public void onViewCreated(View view, Bundle savedInstanceState) {

        super.onViewCreated(view, savedInstanceState);

        setHasOptionsMenu(true);

        googleApiClient = new GoogleApiClient.Builder(getActivity())
                .addConnectionCallbacks(this)
                .addOnConnectionFailedListener(this)
                .addApi(LocationServices.API)
                .build();

        initListeners();
    }

    @Override
    public void onStart() {
        googleMapsFrame = this;
        super.onStart();
        googleApiClient.connect();
    }

    @Override
    public void onStop() {
        super.onStop();
        if (googleApiClient != null && googleApiClient.isConnected()) {
            googleApiClient.disconnect();
        }
    }

    private void initCamera(Location location) {
        LatLng mapPos = new LatLng(location.getLatitude(),
                location.getLongitude());
        CameraPosition position = CameraPosition.builder()
                .target(mapPos)
                .zoom(60f)
                .bearing(0.0f)
                .tilt(0.0f)
                .build();

        getMap().animateCamera(CameraUpdateFactory
                .newCameraPosition(position), null);

        int curMapTypeIndex = 2;
        getMap().setMapType(MAP_TYPES[curMapTypeIndex]);
        getMap().setTrafficEnabled(false);
        getMap().setMyLocationEnabled(false);
        getMap().getUiSettings().setZoomControlsEnabled(true);

        if (posMarker == null) {
            MarkerOptions options = new MarkerOptions().position(mapPos);
            options.icon(BitmapDescriptorFactory.defaultMarker());
            posMarker = getMap().addMarker(options);
        }
    }


    @Override
    public void onConnected(Bundle bundle) {
        Location mCurrentLocation = LocationServices.FusedLocationApi.getLastLocation(googleApiClient);
        if (mCurrentLocation != null) {
            LatLng latLng = new LatLng(mCurrentLocation.getLatitude(), mCurrentLocation.getLongitude());
        }
        initCamera(mCurrentLocation);
    }

    @Override
    public void onMapClick(LatLng latLng) {
    }
}