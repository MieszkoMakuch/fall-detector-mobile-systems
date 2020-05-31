package agh.sm.falldetector;

import android.app.Notification;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.IBinder;
import android.support.annotation.NonNull;
import android.util.Log;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.*;
import java.net.ConnectException;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.SocketTimeoutException;
import java.util.concurrent.LinkedBlockingQueue;


public class PotentialFallDetectorService extends Service implements SensorEventListener {
    public static PotentialFallDetectorService thisInstance;

    private final String TAG = PotentialFallDetectorService.class.getSimpleName();

    private final int FALL_CLASS = 0;
    private final int WALK_CLASS = 1;
    private final int JUMP_CLASS = 2;
    private final int BUMP_CLASS = 3;

    private final String baseDir = android.os.Environment.getExternalStorageDirectory().getAbsolutePath();
    private final String dirname = "AGH_IM_DATA";
    final String filepath = baseDir + File.separator + dirname;
    public String classificationServerAddress = "172.20.10.2";
    private Sensor accelerometer;
    private SensorDataProcessor dataProcessor;

    private PotentialFallDetector fallLikeFSMDetect;
    private File testdata;


    @Override
    public void onCreate() {
        super.onCreate();
        thisInstance = this;
        SensorManager sensorManager = (SensorManager) getSystemService(Context.SENSOR_SERVICE);

        getAccelerometer(sensorManager);

        Handler sensorHandler = createThreadForSensorCallbacks();

        createThreadProcessingSensorValues();

        this.fallLikeFSMDetect = new PotentialFallDetector(this);
        sensorManager.registerListener(this, this.accelerometer, SensorManager.SENSOR_DELAY_FASTEST, sensorHandler);
    }

    private void createThreadProcessingSensorValues() {
        this.dataProcessor = new SensorDataProcessor();
        Thread dataProcessingThread = new Thread(this.dataProcessor);
        dataProcessingThread.start();
    }

    @NonNull
    private Handler createThreadForSensorCallbacks() {
        HandlerThread sensorHandlerThread = new HandlerThread("SensorThread", Thread.NORM_PRIORITY);
        sensorHandlerThread.start();
        return new Handler(sensorHandlerThread.getLooper());
    }

    private void getAccelerometer(SensorManager sensorManager) {
        assert sensorManager != null;
        this.accelerometer = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startID) {
        File path = new File(filepath);
        this.testdata = new File(path, "test_data_005.csv");
        createForegroundServiceWithNotification();
        return START_STICKY;
    }

    private void createForegroundServiceWithNotification() {
        Intent notificationIntent = new Intent(this, MainScreen.class);
        notificationIntent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP |
                Intent.FLAG_ACTIVITY_SINGLE_TOP);

        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, notificationIntent, 0);

        Notification notification = new Notification.Builder(getApplicationContext())
                .setContentTitle(getApplicationContext().getString(R.string.app_name))
                .setContentText("Accidental Fall Monitor - Currently Running")
                .setSmallIcon(android.R.drawable.ic_dialog_alert)
                .setContentIntent(pendingIntent)
                .setOngoing(true).build();
        startForeground(101, notification);
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onSensorChanged(SensorEvent event) {
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {
    }

    private int classifyFallViaRemoteTCPServer(PotentialFallDetector.ExtractedAccelerometerData features) {
        Socket socket;
        String response;
        Integer classification = null;

        try {
            socket = new Socket();
            int classificationSeverPort = 4011;
            socket.connect(new InetSocketAddress(classificationServerAddress,
                    classificationSeverPort), 2000);

            OutputStream outSockStream = socket.getOutputStream();
            PrintWriter outFile = new PrintWriter(outSockStream);

            InputStream inSockStream = socket.getInputStream();
            BufferedReader inFile = new BufferedReader(new InputStreamReader(inSockStream));

            String jsonString = null;
            try {
                jsonString = getJsonToSend(features);
            } catch (org.json.JSONException e) {
                e.printStackTrace();
            }

            //Send
            outFile.print(jsonString);
            outFile.flush();

            //Read
            response = inFile.readLine();
            classification = Integer.parseInt(response);

            socket.close();
        } catch (SocketTimeoutException e) {
            Log.d(TAG, "Classification server timeout");
            e.printStackTrace();
        } catch (ConnectException e) {
            Log.d(TAG, "Cannot connect, check if server is running");
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        if (classification == null) {
            return -1;
        }
        return classification;

    }

    private String getJsonToSend(PotentialFallDetector.ExtractedAccelerometerData features) throws JSONException {
        return new JSONObject()
                .put("impact_duration", features.impactDuration)
                .put("impact_violence", features.impactViolence)
                .put("impact_average", features.impactAverage)
                .put("post_impact_average", features.postImpactAverage).toString();
    }

    private class SensorDataProcessor implements Runnable {
        private LinkedBlockingQueue<SensorEvent> sensorEventQueue;

        SensorDataProcessor() {
            this.sensorEventQueue = new LinkedBlockingQueue<SensorEvent>(10000000);
        }

        @Override
        public void run() {
            while (true) {
                SensorEvent event = waitForSensorReading();
                if (event.sensor.equals(accelerometer)) processAccelerometerEvent(event);
            }
        }

        private void processAccelerometerEvent(SensorEvent event) {
            float x = event.values[0];
            float y = event.values[1];
            float z = event.values[2];

            double accelerationMagnitude = Math.sqrt(x * x + y * y + z * z);

            PotentialFallDetector.ExtractedAccelerometerData features = fallLikeFSMDetect.run
                    (event.timestamp, accelerationMagnitude);
            if (features != null) classifyResults(features);
        }

        private void classifyResults(PotentialFallDetector.ExtractedAccelerometerData features) {
            int classification = classifyFallViaRemoteTCPServer(features);
            switch (classification) {
                case FALL_CLASS:
                    Log.d(TAG, "Detected Fall");
                    Patient.ThisInstance.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            if (Patient.ThisInstance != null) {
                                Patient.updatePatientStatus("PENDING");
                            }
                        }
                    });
                    break;
                case JUMP_CLASS:
                    Log.d(TAG, "Detected jump");
                    break;
                case WALK_CLASS:
                    Log.d(TAG, "Detected walk");
                    break;
                case BUMP_CLASS:
                    Log.d(TAG, "Detected bump");
                    break;
                default:
                    break;
            }
        }

        private SensorEvent waitForSensorReading() {
            SensorEvent event;
            try {
                event = this.sensorEventQueue.take();
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                throw new RuntimeException(e);
            }
            return event;
        }
    }

}
