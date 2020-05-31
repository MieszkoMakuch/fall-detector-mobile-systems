import os
import sys

import numpy as np

os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'

import tensorflow as tf
from tensorflow.contrib.learn.python.learn.utils import input_fn_utils
from tensorflow.python.ops import array_ops
from tensorflow.python.framework import dtypes
from tensorflow.contrib.learn import build_parsing_serving_input_fn
from tensorflow.contrib.layers import create_feature_spec_for_parsing

tf.logging.set_verbosity(tf.logging.INFO)

TRAINING_DATA = "training.csv"
TEST_DATA = "test.csv"

MODEL_DIR = os.getcwd() + "/falldetector_model"
MODEL_DIR_TRAINED = MODEL_DIR + "/trained"

CLASSES_NO = 4

FEATURES_NO = 4


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
        return "NAME_ME"


def main():
    if not os.path.exists(TRAINING_DATA):
        print("ERR: training data file does not exist.")
        sys.exit(1)

    if not os.path.exists(TEST_DATA):
        print("ERR: test data file does not exist.")
        sys.exit(1)

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

    def training_get_inputs():
        x = tf.constant(training_set.data)
        y = tf.constant(training_set.target)

        return x, y

    classifier.fit(input_fn=training_get_inputs, steps=100000)

    def test_get_inputs():
        x = tf.constant(test_set.data)
        y = tf.constant(test_set.target)

        return x, y

    accuracy_score = classifier.evaluate(input_fn=test_get_inputs,
                                         steps=1)["accuracy"]

    print(("\nAccuracy: {0:f}\n".format(accuracy_score)))

    def classify_sample():
        return np.array(
            [[1077, 0.49, 10.33, 10.52],
             [346, 0.95, 19.37, 9.89]], dtype=np.float32)

    predictions = list(classifier.predict_classes(input_fn=classify_sample))
    predictions = [label_classify(i) for i in predictions]

    print(" ************* Examples of classification *************")
    print("Prediction: \t{}".format(predictions))
    print("Output: \t{}\n".format([label_classify(2), label_classify(0)]))

    tfrecord_serving_input_fn = build_parsing_serving_input_fn(
        create_feature_spec_for_parsing(feature_columns))
    classifier.export_savedmodel(
        export_dir_base=MODEL_DIR_TRAINED,
        serving_input_fn=tfrecord_serving_input_fn,
        as_text=False)


if __name__ == "__main__":
    main()
