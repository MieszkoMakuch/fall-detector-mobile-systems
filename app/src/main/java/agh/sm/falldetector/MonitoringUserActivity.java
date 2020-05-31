package agh.sm.falldetector;

import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.location.Location;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.support.v4.app.NotificationCompat;
import android.support.v4.app.TaskStackBuilder;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.SocketTimeoutException;
import java.net.UnknownHostException;

public class MonitoringUserActivity extends AppCompatActivity {
    private String currIpAddr = "172.20.10.4";
    private int currPort = 8080;
    private EditText patientIpAddressEditText, patientPortEditText;
    private Handler mainThreadHandler = new Handler();
    private TextView connectTextView, statusTextView, lastUpdatedTextView;
    private int pollInterval = 5000;
    private Runnable runnableCode = new Runnable() {
        @Override
        public void run() {
            requestPacketFromServer();
            mainThreadHandler.postDelayed(runnableCode, pollInterval);
        }
    };
    private long prevTime = 0;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_monitoring_user);
        patientIpAddressEditText = (EditText) findViewById(R.id.ipAddrEditText);
        patientPortEditText = (EditText) findViewById(R.id.portEditText);
        connectTextView = (TextView) findViewById(R.id.textViewConnectFlag);
        statusTextView = (TextView) findViewById(R.id.statusTextView);
        lastUpdatedTextView = (TextView) findViewById(R.id.lastUpdatedTextView);

        patientIpAddressEditText.setText(currIpAddr);
        patientPortEditText.setText(String.valueOf(currPort));

        statusTextView.requestFocus();
    }

    public void updateConnection(View view) {
        currIpAddr = patientIpAddressEditText.getText().toString();
        currPort = Integer.parseInt(patientPortEditText.getText().toString());
        view.clearFocus();
    }

    @Override
    protected void onStart() {
        super.onStart();
        mainThreadHandler.post(runnableCode);
    }

    public void requestPacketFromServer() {
        ClientBackgroundTask clientBackgroundTask = new ClientBackgroundTask(currIpAddr, currPort);
        clientBackgroundTask.execute();
    }

    private void notifyThatSomeoneNeedsHelp() {
        NotificationCompat.Builder mBuilder =
                new NotificationCompat.Builder(this)
                        .setSmallIcon(android.R.drawable.ic_dialog_alert)
                        .setContentTitle("FALLDETECTOR")
                        .setContentText("Someone may need help!");

        Intent resultIntent = new Intent(this, MonitoringUserActivity.class);

        TaskStackBuilder stackBuilder = TaskStackBuilder.create(this);
        stackBuilder.addParentStack(MonitoringUserActivity.class);
        stackBuilder.addNextIntent(resultIntent);
        PendingIntent resultPendingIntent =
                stackBuilder.getPendingIntent(
                        0,
                        PendingIntent.FLAG_UPDATE_CURRENT
                );
        mBuilder.setContentIntent(resultPendingIntent);
        NotificationManager mNotificationManager =
                (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        int mId = 1;
        assert mNotificationManager != null;
        mNotificationManager.notify(mId, mBuilder.build());
    }

    public void interpretPatientMessage(String msg) {
        prevTime = android.os.SystemClock.uptimeMillis();
        String status = "";
        boolean jsonUsingGPSFlag = false;
        double jsonGpsLatitude = 153, jsonGpsLongitude = -27.;

        JSONObject jObject = null;
        Log.d("agh_im_json", "parsing " + msg);
        try {
            jObject = new JSONObject(msg);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        try {
            status = jObject.getString("status");
            jsonUsingGPSFlag = jObject.getBoolean("usingGps");
            jsonGpsLatitude = jObject.getDouble("latitude");
            jsonGpsLongitude = jObject.getDouble("longitude");

        } catch (JSONException e) {
            e.printStackTrace();
        } finally {
            Log.d("agh_im_json", "Status: " + status);
            Log.d("agh_im_json", "FLAG: " + jsonUsingGPSFlag);
            Log.d("agh_im_json", "Latitude: " + jsonGpsLatitude);
            Log.d("agh_im_json", "Longitude: " + jsonGpsLongitude);
        }

        handleStatus(status);
        statusTextView.setText(status);

        if (jsonUsingGPSFlag) {
            Location targetLocation = new Location("");
            targetLocation.setLatitude(jsonGpsLatitude);
            targetLocation.setLongitude(jsonGpsLongitude);
            GoogleMapsFrame.googleMapsFrame.updateMonitoredUserLocation(targetLocation);
        }
    }

    private void handleStatus(String status) {
        switch (status) {
            case "NEEDS HELP":
                notifyThatSomeoneNeedsHelp();
                statusTextView.setTextColor(Color.argb(255, 255, 0, 0));
                pollInterval = 2000;
                break;
            case "PENDING":
                statusTextView.setTextColor(Color.argb(255, 255, 255, 0));
                pollInterval = 2500;
                break;
            case "OKAY":
                statusTextView.setTextColor(Color.parseColor("#118800"));
                pollInterval = 5000;
                break;
        }
    }

    public class ClientBackgroundTask extends AsyncTask<Void, Void, Void> {
        String dstAddress;
        int dstPort;
        String response = "";

        ClientBackgroundTask(String addr, int port) {
            dstAddress = addr;
            dstPort = port;
        }

        /**
         * Connect to specified port and IP address, with a timeout of 1 second.
         * Data is interpreted on the main UI thread if a message is received.
         */
        @Override
        protected Void doInBackground(Void... arg0) {
            Socket socket = null;
            try {
                socket = new Socket();
                socket.connect(new InetSocketAddress(dstAddress, dstPort), 1000);
                socket.setSoTimeout(1000);

                ByteArrayOutputStream byteArrayOutputStream =
                        new ByteArrayOutputStream(1024);
                byte[] buffer = new byte[1024];

                int bytesRead;
                InputStream inputStream = socket.getInputStream();

                while ((bytesRead = inputStream.read(buffer)) != -1) {
                    byteArrayOutputStream.write(buffer, 0, bytesRead);
                    response += byteArrayOutputStream.toString("UTF-8");
                }

                MonitoringUserActivity.this.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        interpretPatientMessage(response);
                    }
                });

            } catch (UnknownHostException e) {
                e.printStackTrace();
                response = "UnknownHostException: " + e.toString();
            } catch (SocketTimeoutException e) {
                e.printStackTrace();
                response = "SocketTimeout: " + e.toString();
            } catch (IOException e) {
                e.printStackTrace();
                response = "IOException: " + e.toString();
            } finally {
                closeSocket(socket);
            }
            updateStatusTextField();
            return null;
        }

        private void updateStatusTextField() {
            MonitoringUserActivity.this.runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    lastUpdatedTextView.setText(String.format("%.02f s ago", (android.os.SystemClock.uptimeMillis() - prevTime) / 1000f));
                    connectTextView.setText(response);
                }
            });
        }

        private void closeSocket(Socket socket) {
            if (socket != null) {
                try {
                    socket.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

        @Override
        protected void onPostExecute(Void result) {
            super.onPostExecute(result);
        }
    }
}
