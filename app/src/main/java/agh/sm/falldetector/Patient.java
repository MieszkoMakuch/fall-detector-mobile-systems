package agh.sm.falldetector;

import android.app.Dialog;
import android.bluetooth.BluetoothAdapter;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Color;
import android.location.Location;
import android.os.Bundle;
import android.os.Handler;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import java.io.*;
import java.net.*;
import java.util.Enumeration;
import java.util.Timer;
import java.util.TimerTask;

public class Patient extends AppCompatActivity {
    public static Patient ThisInstance;
    private static String patientStatus = "OKAY";
    private static Location patientGPSLocation = null;
    private static String statusStringAsJson = "";

    private EditText classificationIpAddr;
    Socket guardianSocket;

    private boolean hasBeenAsked = false;
    private Timer answerTimer;
    private long lastAskTime = -1;
    private boolean needsHelp = false;

    private Handler handler = new Handler();

    private Runnable runnableCode = new Runnable() {
        @Override
        public void run() {
            handler.postDelayed(runnableCode, 20000);
        }
    };

    public static void updatePatientStatus(String status) {
        Log.d("agh_im_log", "received status " + status);
        if (!status.equals("OKAY") && !status.equals("PENDING") && !status.equals("NEEDS HELP")) {
            patientStatus = "OKAY";
        } else if (status.equals("PENDING") && !ThisInstance.needsHelp) {
            askPatientIfHeNeedsHelp(status);
        } else if (status.equals("NEEDS HELP")) {
            patientStatus = status;
        } else {
            patientStatus = "OKAY";
        }
        Patient.ThisInstance.updateStatusJsonString();
    }

    private static void askPatientIfHeNeedsHelp(String status) {
        if (!ThisInstance.hasBeenAsked) {
            ThisInstance.hasBeenAsked = true;
            TimerTask answerTimerTask = new TimerTask() {
                @Override
                public void run() {
                    ThisInstance.needsHelp = true;
                    ThisInstance.answerTimer.cancel();
                    Patient.updatePatientStatus("NEEDS HELP");

                }
            };
            ThisInstance.answerTimer = new Timer();
            ThisInstance.answerTimer.schedule(answerTimerTask, 5000);
            ThisInstance.lastAskTime = android.os.SystemClock.uptimeMillis();
            ThisInstance.askPatientIfHeNeedsHelpDialog();
        } else {
            patientStatus = status;
        }
    }

    public static void updateGPSLatLng(Location location) {
        patientGPSLocation = location;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(agh.sm.falldetector.R.layout.activity_monitored_user);
        ThisInstance = this;

        Intent intentGPS = new Intent(this, LocationServiceGPS.class);
        startService(intentGPS);

        Intent intent = new Intent(this, PotentialFallDetectorService.class);
        startService(intent);

        TextView portText = (TextView) findViewById(R.id.portTextView);
        TextView ipAddrText = (TextView) findViewById(R.id.ipAddrTextView);

        classificationIpAddr = (EditText) findViewById(agh.sm.falldetector.R.id.classificationIpAddr);

        classificationIpAddr.setText("172.20.10.2");

        portText.setText(String.format("%d", SocketServerThread.SocketServerPORT));
        ipAddrText.setText(getIpAddressOfTheLocalDevice());

        Thread socketServerThread = new Thread(new SocketServerThread());
        socketServerThread.start();

        IntentFilter filter = new IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED);

        handler.post(runnableCode);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
    }

    public void updateStatusJsonString() {
        String json = "{";

        json += "\"status\":";
        json += "\"" + patientStatus + "\"";
        json += ",";

        boolean patientGPSFlag = true;

        json += "\"usingGps\":";
        json += patientGPSFlag ? "true" : "false";
        json += ",";

        json += "\"latitude\":";
        json += String.format("%f,", patientGPSLocation.getLatitude());
        json += "\"longitude\":";
        json += String.format("%f,", patientGPSLocation.getLongitude());

        json += "\"nearestBleNode\":";
        int bleNearestNodeId = 1;
        json += String.format("%d", bleNearestNodeId);
        json += "}";

        statusStringAsJson = json;
        Log.d("agh_im_server", "Updated to: " + json);
    }

    private void askPatientIfHeNeedsHelpDialog() {
        final Dialog dialog = new Dialog(this);
        dialog.setContentView(agh.sm.falldetector.R.layout.dialog);
        dialog.setTitle("FallDetector");

        TextView text = (TextView) dialog.findViewById(agh.sm.falldetector.R.id.text);
        text.setText("Detected potential fall. Are you ok?");
        text.setTextColor(Color.argb(255, 0, 0, 0));
        ImageView image = (ImageView) dialog.findViewById(agh.sm.falldetector.R.id.image);
        image.setImageResource(android.R.drawable.ic_dialog_alert);

        Button dialogButton = (Button) dialog.findViewById(agh.sm.falldetector.R.id.dialogButtonOK);
        closeCustomDialogIfButtonClicked(dialog, dialogButton);
        dialog.show();
    }

    private void closeCustomDialogIfButtonClicked(final Dialog dialog, Button dialogButton) {
        dialogButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dialog.dismiss();
                answerTimer.cancel();
                needsHelp = false;
                hasBeenAsked = false;
                Patient.updatePatientStatus("OKAY");
                Log.d("agh_im_log", "I DUN NEED HELP SIR!");
            }
        });
    }

    private String getIpAddressOfTheLocalDevice() {
        String ip = "";
        try {
            Enumeration<NetworkInterface> enumNetworkInterfaces = NetworkInterface.getNetworkInterfaces();
            while (enumNetworkInterfaces.hasMoreElements()) {
                NetworkInterface networkInterface = enumNetworkInterfaces.nextElement();
                Enumeration<InetAddress> enumInetAddress = networkInterface.getInetAddresses();
                while (enumInetAddress.hasMoreElements()) {
                    InetAddress inetAddress = enumInetAddress.nextElement();

                    if (inetAddress.isSiteLocalAddress()) {
                        ip += "" + inetAddress.getHostAddress() + "\n";
                    }
                }
            }

        } catch (SocketException e) {
            e.printStackTrace();
            ip += "Error:  " + e.toString() + "\n";
        }

        return ip;
    }

    /**
     * Set classification IP address call back function. Sets the classification server IP address.
     *
     */
    public void setClassificationServerCallback(View view) {
        PotentialFallDetectorService.thisInstance.classificationServerAddress =
                classificationIpAddr.getText().toString();
        view.clearFocus();
    }

    private class SocketServerThread extends Thread {

        static final int SocketServerPORT = 8080;
        DataInputStream dataInputStream = null;
        DataOutputStream dataOutputStream = null;

        @Override
        public void run() {
            Socket socket = null;

            try {
                ServerSocket serverSocket = new ServerSocket(SocketServerPORT);

                while (true) {
                    socket = serverSocket.accept();
                    updateStatusJsonString();
                    SocketServerReplyThread socketServerReplyThread = new SocketServerReplyThread(
                            socket, statusStringAsJson);
                    socketServerReplyThread.run();
                    guardianSocket = socket;
                    Log.d("agh_im_log", "Connected from " + socket.getInetAddress() + " sent " + statusStringAsJson);
                }
            } catch (IOException e) {
                e.printStackTrace();
                Log.d("agh_im_server", e.toString());
            } finally {
                if (socket != null) {
                    try {
                        socket.close();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }

                if (dataInputStream != null) {
                    try {
                        dataInputStream.close();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }

                if (dataOutputStream != null) {
                    try {
                        dataOutputStream.close();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        }
    }

    private class SocketServerReplyThread extends Thread {
        String outMsg;
        private Socket hostThreadSocket;

        SocketServerReplyThread(Socket socket, String msg) {
            this.hostThreadSocket = socket;
            this.outMsg = msg;
        }
        @Override
        public void run() {
            OutputStream outputStream;
            String msgReply = outMsg;

            try {
                outputStream = hostThreadSocket.getOutputStream();
                PrintStream printStream = new PrintStream(outputStream);
                printStream.print(msgReply);
                printStream.close();

            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}

