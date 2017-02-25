#!/bin/bash
echo "RUN TEST"
./gradlew assembleDebug
retval=$?
if [ $retval -ne 0 ]; then
    echo "error on assembling, exit code: "$retval
    exit $retval
fi
if [ ${TEST} == "android" ]; then
    adb devices
    adb shell svc power stayon true
    sleep 10
    adb shell input keyevent 82
    sleep 5
    adb shell settings put global window_animation_scale 0.0 
    adb shell settings put global transition_animation_scale 0.0
    adb shell settings put global animator_duration_scale 0.0
    ./gradlew build assembleAndroidTest
    retval=$?
    if [ $retval -ne 0 ]; then
      echo "error on assembling, exit code: "$retval
      exit $retval
    fi
    ./gradlew :parsingplayer:installDebugAndroidTest
    retval=$?
    if [ $retval -ne 0 ]; then
      echo "error on install, exit code: "$retval
      exit $retval
    fi
    adb shell am instrument -w -r -e package com.hustunique.parsingplayer -e debug false com.hustunique.parsingplayer.test/android.support.test.runner.AndroidJUnitRunner
    retval=$?
    if [ $retval -ne 0 ]; then
      echo "error in adb, exit code: "$retval
      exit $retval
    fi
elif [${TEST} == "unit"]; then
    ./gradlew --stacktrace test
fi
retval=$?
if [ $retval -ne 0 ]; then
    echo "TEST FAILING"
    exit $retval
fi

