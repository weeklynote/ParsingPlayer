#!/bin/bash
echo "TESTING..."
if [ ${TEST} == "android" ]; then
    ./gradlew uninstallAll
    ./gradlew installDebugAndroidTest
    retval=$?
    if [ $retval -ne 0 ]; then
      echo "error on install, exit code: "$retval
      exit $retval
    fi
    adb shell am instrument -w -r -e package com.hustunique.parsingplayer -e debug false com.hustunique.parsingplayer.test/android.support.test.runner.AndroidJUnitRunner
    retval=$?
    if [ $retval -ne 0 ]; then
      echo "error in espresso testing, exit code: "$retval
      exit $retval
    fi
elif [${TEST} == "unit"]; then
    ./gradlew --stacktrace test
    retval=$?
    if [ $retval -ne 0 ]; then
        echo "TEST FAILED: " $retval
        exit $retval
    fi
fi
echo "TEST DONE"

