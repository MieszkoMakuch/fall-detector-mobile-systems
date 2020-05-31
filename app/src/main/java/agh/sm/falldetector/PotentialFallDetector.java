package agh.sm.falldetector;

import android.content.Context;
import android.hardware.SensorManager;
import android.media.MediaScannerConnection;
import android.media.Ringtone;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Vibrator;
import android.support.annotation.NonNull;

import java.io.*;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import static java.lang.String.format;


public class PotentialFallDetector {

    private final double GRAVITY_EARTH = SensorManager.GRAVITY_EARTH;
    private final String TAG = this.getClass().getSimpleName();

    private final int STATE_WAITING_FOR_PEAK = 0;
    private final int STATE_POST_PEAK_EVENT = 1;
    private final int STATE_POST_FALL_EVENT = 2;
    private final int STATE_EVENT_FINISHED = 3;

    private final double ACCELERATION_MAGNITUDE_DETECTION_THRESHOLD = 3.0 * GRAVITY_EARTH;

    private final long POST_PEAK_TIMEOUT_MS = 1000;
    private final long POST_FALL_TIMEOUT_MS = 2000;

    private final long WINDOW_ENTRY_MAX_AGE_MS = POST_PEAK_TIMEOUT_MS + POST_FALL_TIMEOUT_MS;

    private final long PRE_IMPACT_JUST_BEFORE_MS = 500;

    private final long IMPACT_END_LOOKBACK_MS = POST_PEAK_TIMEOUT_MS + PRE_IMPACT_JUST_BEFORE_MS;
    private PotentialFallDetectorService potentialFallDetectorService;
    private long postPeakTimeStart;
    private long postFallTimeStart;
    private int state;
    private AccelerometerDataWindow fallLikeEventWindow;
    private long triggerPeakTime;
    private long impactStart;
    private long impactEnd;
    private long lastReadingTimestamp;

    public PotentialFallDetector(PotentialFallDetectorService potentialFallDetectorService) {

        this.potentialFallDetectorService = potentialFallDetectorService;
        resetFSM();

    }

    private void resetFSM() {
        state = STATE_WAITING_FOR_PEAK;
        resetValues();
        fallLikeEventWindow = new AccelerometerDataWindow();
    }

    private void resetValues() {
        postPeakTimeStart = 0;
        postFallTimeStart = 0;
        impactStart = 0;
        impactEnd = 0;
        triggerPeakTime = 0;
        lastReadingTimestamp = 0;
    }

    private ExtractedAccelerometerData doClock(long timestamp, double accelerationMaginitude) {
        timestamp = TimeUnit.MILLISECONDS.convert(timestamp, TimeUnit.NANOSECONDS);

        switch (state) {
            case STATE_WAITING_FOR_PEAK:
                handleStateWaitingForPeak(timestamp, accelerationMaginitude);
                break;
            case STATE_POST_PEAK_EVENT:
                handlePostPeakEvent(timestamp, accelerationMaginitude);
                break;
            case STATE_POST_FALL_EVENT:
                handlePostFallEvent(timestamp, accelerationMaginitude);
                break;
            case STATE_EVENT_FINISHED:
                return new ExtractedAccelerometerData(fallLikeEventWindow);
        }
        lastReadingTimestamp = timestamp;
        return null;
    }

    private void handlePostFallEvent(long timestamp, double accelerationMaginitude) {
        if (timestamp - postFallTimeStart > POST_FALL_TIMEOUT_MS) {
            state = STATE_EVENT_FINISHED;
            return;
        }

        fallLikeEventWindow.put(timestamp, accelerationMaginitude);

        if (accelerationMaginitude >= ACCELERATION_MAGNITUDE_DETECTION_THRESHOLD) {
            fallLikeEventWindow.removeOlderThanBy(timestamp, WINDOW_ENTRY_MAX_AGE_MS);
            postPeakTimeStart = timestamp;
            state = STATE_POST_PEAK_EVENT;
            triggerPeakTime = timestamp;
        }
    }

    private void handlePostPeakEvent(long timestamp, double accelerationMaginitude) {
        fallLikeEventWindow.put(timestamp, accelerationMaginitude);
        if (timestamp - postPeakTimeStart > POST_PEAK_TIMEOUT_MS) {
            postFallTimeStart = timestamp;
            state = STATE_POST_FALL_EVENT;
            return;
        }

        if (accelerationMaginitude >= ACCELERATION_MAGNITUDE_DETECTION_THRESHOLD) {
            fallLikeEventWindow.removeOlderThanBy(timestamp, WINDOW_ENTRY_MAX_AGE_MS);
            postPeakTimeStart = timestamp;
            state = STATE_POST_PEAK_EVENT;
            triggerPeakTime = timestamp;
            return;
        } else if (accelerationMaginitude >= ACCELERATION_MAGNITUDE_DETECTION_THRESHOLD / 2.0) {
            impactEnd = timestamp;
        }
        state = STATE_POST_PEAK_EVENT;
        if (lastReadingTimestamp == triggerPeakTime) impactEnd = timestamp;
    }

    private void handleStateWaitingForPeak(long timestamp, double accelerationMaginitude) {
        if (accelerationMaginitude >= ACCELERATION_MAGNITUDE_DETECTION_THRESHOLD) {
            postPeakTimeStart = timestamp;
            state = STATE_POST_PEAK_EVENT;
            triggerPeakTime = timestamp;
            fallLikeEventWindow.removeOlderThanBy(timestamp, WINDOW_ENTRY_MAX_AGE_MS);

        } else {
            state = STATE_WAITING_FOR_PEAK;
        }
        fallLikeEventWindow.put(timestamp, accelerationMaginitude);

    }

    ExtractedAccelerometerData run(long timestamp, double G) {
        ExtractedAccelerometerData rv = this.doClock(timestamp, G);
        if (rv != null) {
            this.debugDumpEventData(this.fallLikeEventWindow, rv);
            resetFSM();
        }
        return rv;
    }

    class ExtractedAccelerometerData {

        double impactDuration;
        double impactViolence;
        double impactAverage;
        double postImpactAverage;

        public ExtractedAccelerometerData(AccelerometerDataWindow window) {
            extractData(window);
        }

        private void extractData(AccelerometerDataWindow window) {
            AccelerometerDataWindow subset = window.clone();
            subset.removeOlderThan(impactEnd - IMPACT_END_LOOKBACK_MS);
            subset.removeNewerThan(triggerPeakTime);

            Map.Entry<Long, Double> dip = subset.getFirstEntryLt(0.7 * GRAVITY_EARTH);
            if (dip == null) {
                impactStart = triggerPeakTime;
            } else {
                subset.removeOlderThan(dip.getKey());
                Map.Entry<Long, Double> start = subset.getFirstEntryGt(ACCELERATION_MAGNITUDE_DETECTION_THRESHOLD / 2.0);
                if (start == null) {
                    impactStart = triggerPeakTime;
                } else {
                    impactStart = start.getKey();
                }
            }
            this.impactDuration = impactEnd - impactStart;
            AccelerometerDataWindow impactWindow = computeImpactViolence(window);
            computeImpactAverage(impactWindow);
            computePostImpactAverage(window);

        }

        private void computePostImpactAverage(AccelerometerDataWindow window) {
            AccelerometerDataWindow postImpactWindow = window.clone();
            postImpactWindow.removeOlderThan(impactEnd);

            double postImpactSum = 0;
            for (double value : postImpactWindow.values()) {
                postImpactSum = postImpactSum + value;
            }
            this.postImpactAverage = postImpactSum / postImpactWindow.size();
        }

        private void computeImpactAverage(AccelerometerDataWindow impactWindow) {
            double impactSum = 0;
            for (double value : impactWindow.values()) {
                impactSum = impactSum + value;
            }
            this.impactAverage = impactSum / impactWindow.size();
        }

        @NonNull
        private AccelerometerDataWindow computeImpactViolence(AccelerometerDataWindow window) {
            AccelerometerDataWindow impactWindow = window.clone();
            impactWindow.removeOlderThan(impactStart);
            impactWindow.removeNewerThan(impactEnd);
            double num = impactWindow.size() - impactWindow.getNumEntriesInRange(
                    0.8 * GRAVITY_EARTH,
                    1.2 * GRAVITY_EARTH);
            this.impactViolence = num / (double) impactWindow.size();
            return impactWindow;
        }
    }

    /**
     * Wrapper for accelerometer data window
     */
    public class AccelerometerDataWindow extends LinkedHashMap<Long, Double> implements Cloneable {

        public AccelerometerDataWindow() {
            super();
        }
        void removeOlderThanBy(long timestampReference, long maxAge) {
            Iterator<Long> iterator = this.keySet().iterator();
            while (iterator.hasNext()) {
                long key = iterator.next();
                if (timestampReference - key > maxAge) iterator.remove();
                else break;
            }
        }

        void removeOlderThan(long timestampReference) {
            removeOlderThanBy(timestampReference, 0);
        }

        void removeNewerThan(long timestampReference) {
            Iterator<Long> iterator = this.keySet().iterator();
            while (iterator.hasNext()) {
                long key = iterator.next();
                if (key > timestampReference) iterator.remove();
            }
        }

        public AccelerometerDataWindow clone() {
            AccelerometerDataWindow retval = new AccelerometerDataWindow();
            for (Entry entry : this.entrySet()) retval.put((Long) entry.getKey(), (Double) entry.getValue());
            return retval;
        }
        int getNumEntriesInRange(double lower, double upper) {

            if (lower == -1 * Double.MIN_VALUE && upper == Double.MAX_VALUE) return this.size();
            int count = 0;
            for (Entry<Long, Double> entry : this.entrySet())
                if (entry.getValue() >= lower && entry.getValue() <= upper) count++;
            return count;
        }
        Entry<Long, Double> getFirstEntryGt(double threshold) {
            for (Entry<Long, Double> entry : this.entrySet()) {
                if (entry.getValue() > threshold) return entry;
            }
            return null;
        }

        Entry<Long, Double> getFirstEntryLt(double threshold) {
            for (Entry<Long, Double> needle : this.entrySet())
                if (needle.getValue() < threshold) return needle;
            return null;
        }


    }

    public void debugDumpEventData(AccelerometerDataWindow window,
                                   ExtractedAccelerometerData features) {
        String windowFileFormat = "window%03d.csv";
        String featureFileFormat = "feature%03d.csv";

        File windF = null;
        File featF = null;
        for (int i = 0; i < 999; i++) {
            windF = new File(new File(potentialFallDetectorService.filepath),
                    format(windowFileFormat, i));
            featF = new File(new File(potentialFallDetectorService.filepath),
                    format(featureFileFormat, i));

            if (!windF.exists() && !featF.exists()) {
                break;
            }
        }

        Vibrator v = (Vibrator) potentialFallDetectorService.getApplicationContext().
                getSystemService(Context.VIBRATOR_SERVICE);
        v.vibrate(1000);

        try {
            Uri notification = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);
            Ringtone r = RingtoneManager.getRingtone(
                    this.potentialFallDetectorService.getApplicationContext(),
                    notification);
            r.play();
        } catch (Exception e) {
            e.printStackTrace();
        }

        try {
            FileOutputStream out = new FileOutputStream(windF, true);
            PrintWriter pw = new PrintWriter(out, true);

            for (Map.Entry<Long, Double> entry : window.entrySet()) {
                pw.println(entry.getKey() + "," + entry.getValue());
            }

            pw.close();
            out.close();

        } catch (IOException e) {
            e.printStackTrace();
        }
        try {
            FileOutputStream out = new FileOutputStream(featF, true);
            PrintWriter pw = new PrintWriter(out, true);

            pw.println(features.impactDuration + "," + features.impactViolence +
                    "," + features.impactAverage + "," + features.postImpactAverage);

            pw.close();
            out.close();

        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException ignored) {
        }

        MediaScannerConnection.scanFile(potentialFallDetectorService, new String[]{
                        windF.toString()}, null,
                new MediaScannerConnection.OnScanCompletedListener() {
                    public void onScanCompleted(String path, Uri uri) {}
                });

        MediaScannerConnection.scanFile(potentialFallDetectorService, new String[]{
                        featF.toString()}, null,
                new MediaScannerConnection.OnScanCompletedListener() {
                    public void onScanCompleted(String path, Uri uri) {}
                });

    }

}
