import socket
import os
import sys
import time
import threading
import json

os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'

import numpy as np
import tensorflow as tf

tf.logging.set_verbosity(tf.logging.ERROR)

TRAINING_DATA = "training.csv"
TEST_DATA = "test.csv"

MODEL_DIR = os.getcwd() + "/falldetector_model"
MODEL_DIR_TRAINED = MODEL_DIR + "/trained"

CLASSES_NO = 4

FEATURES_NO = 4

SERVER_BIND_IP = "0.0.0.0"
SERVER_PORT = 4011

server_done = False


def label_classify(label):
    if label == 0:
        return "Fall"
    elif label == 1:
        return "Jump"
    elif label == 2:
        return "Walking"
    elif label == 3:
        return "Bump"
    else:
        return "UNKNOWN"


def load__model():
    training_set = tf.contrib.learn.datasets.base.load_csv_with_header(
        filename=TRAINING_DATA,
        target_dtype=np.int,
        features_dtype=np.float32)
    test_set = tf.contrib.learn.datasets.base.load_csv_with_header(
        filename=TEST_DATA,
        target_dtype=np.int,
        features_dtype=np.float32)

    feature_columns = [tf.contrib.layers.real_valued_column("",
                                                            dimension=FEATURES_NO)]

    classifier = tf.contrib.learn.DNNClassifier(feature_columns=feature_columns,
                                                hidden_units=[10, 20, 10],
                                                n_classes=CLASSES_NO,
                                                model_dir=MODEL_DIR,
                                                config=tf.contrib.learn.RunConfig(save_checkpoints_secs=1))

    # Define the training inputs
    def training_get_inputs():
        x = tf.constant(training_set.data)
        y = tf.constant(training_set.target)

        return x, y

    classifier.fit(input_fn=training_get_inputs, steps=0)

    def test_get_inputs():
        x = tf.constant(test_set.data)
        y = tf.constant(test_set.target)
        return x, y

    accuracy_score = classifier.evaluate(input_fn=test_get_inputs,
                                         steps=1)["accuracy"]
    print(("\nModel Accuracy: {0:f}\n".format(accuracy_score)))

    return classifier


def classify(classifier, features):
    def input_func(feat=features):
        return np.array(
            [[f for f in feat]], dtype=np.float32)

    predict = list(classifier.predict_classes(input_fn=input_func))
    return int(predict[0])


def _server_thread():
    server_sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    server_sock.bind((SERVER_BIND_IP, SERVER_PORT))

    server_sock.listen()
    print("Fall Detector"
          " server running!")
    print("Listening on {}:{}".format(SERVER_BIND_IP, SERVER_PORT))

    # Load the TensorFlow classification model
    classifier = load__model()
    print("TensorFlow DNNClassifier model loaded.")

    print("Ready.")

    while True:

        client_sock, address = server_sock.accept()
        print("Accepted connection from {}:{}!".format(
            address[0], address[1]))

        req = client_sock.recv(4096)

        try:
            j = json.loads(req.decode())
        except json.decoder.JSONDecodeError:
            print("JSON ERROR with decoding, connection rejected")
            print("DEBUG: %s" % str(req))
            client_sock.close()
            continue

        print("Received {}".format(str(j)))

        # if json is the wrong format
        if 'impact_duration' not in j:
            print("error: no impact_duration")
            continue
        if 'impact_violence' not in j:
            print("error: no impact_violence")
            continue
        if 'impact_average' not in j:
            print("error: no impact_average")
            continue
        if 'post_impact_average' not in j:
            print("error: no post_impact_average")
            continue

        classification = classify(classifier,
                                  [j['impact_duration'], j['impact_violence'],
                                   j['impact_average'], j['post_impact_average']])

        client_sock.send(b'%d\n' % classification)
        print("classification: %d = %s" % \
              (classification, label_classify(classification)))

        client_sock.close()

    print("Server turning off... if you want to exit: CTRL-C")
    server_end = True


def main():
    server_thread = threading.Thread(target=_server_thread)
    server_thread.start()

    try:
        while not server_done:
            time.sleep(1)
    except KeyboardInterrupt:
        print("KeyBoardInterrupt...")
        sys.exit(0)


if __name__ == "__main__":
    main()
