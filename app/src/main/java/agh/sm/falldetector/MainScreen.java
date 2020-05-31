package agh.sm.falldetector;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Environment;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

import java.io.File;

public class MainScreen extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle bundleInstanceState) {
        super.onCreate(bundleInstanceState);
        setContentView(agh.sm.falldetector.R.layout.main_screen);
        createDataModelFolders();
        Context context = getApplicationContext();
        Toast.makeText(context, "Turn on GPS", Toast.LENGTH_SHORT).show();
    }

    public void monitoringUserButtonPressed(View view) {
        Intent intent = new Intent(this, MonitoringUserActivity.class);
        intent.setFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);
        startActivityIfNeeded(intent, 0);

        Button button = (Button) findViewById(agh.sm.falldetector.R.id.btnMonitoredUser);
        button.setEnabled(false);
    }

    public void patientUserButtonPressed(View view) {
        Intent intent = new Intent(this, Patient.class);
        intent.setFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);
        startActivityIfNeeded(intent, 0);

        Button button = (Button) findViewById(agh.sm.falldetector.R.id.btnGuardian);
        button.setEnabled(false);
    }

    /**
     * Creates AGH_IM_DATA and AGH_IM_MODEL folders if not present.
     */
    private void createDataModelFolders() {

        File dataFolder = new File(Environment.getExternalStorageDirectory() + "/AGH_IM_DATA");
        File modelFolder = new File(Environment.getExternalStorageDirectory() + "/AGH_IM_MODEL");

        boolean dataSuccess = true;
        boolean modelSuccess = true;
        if (!dataFolder.exists()) {
            try {
                dataSuccess = dataFolder.mkdirs();
            } catch (SecurityException e) {
                dataSuccess = false;
            }
        }

        if (!modelFolder.exists()) {
            try {
                modelSuccess = modelFolder.mkdirs();
            } catch (SecurityException e) {
                modelSuccess = false;
            }
        }

        String TAG = "MainScreen";
        if (dataSuccess) Log.d(TAG, "Created AGH_IM_DATA folder");
        else Log.d(TAG, "Cannot create AGH_IM_DATA Folder");
        if (modelSuccess) Log.d(TAG, "Successfully created AGH_IM_MODEL folder");
        else Log.d(TAG, "Cannot create AGH_IM_MODEL Folder");

    }

}
