#!/bin/bash
echo "RUN TEST"
./gradlew build
retval=$?
if [ $retval -ne 0 ]; then
    echo "error on assembling, exit code: "$retval
    exit $retval
fi
if [ ${TEST} == "android" ]; then
    echo no | android create avd --force --name test --target $ANDROID_TARGET --abi $ANDROID_ABI --sdcard 800M
    cat $HOME/.android/avd/test.avd/config.ini
    emulator -memory 4000 -avd test -no-audio -cache-size 400 -netdelay none -netspeed full -no-window &
    android-wait-for-emulator
    while ! adb shell getprop init.svc.bootanim; do
       echo Waiting for boot animation to end
       sleep 10
    done
    while ! adb shell getprop ro.build.version.sdk; do
       echo Waiting for ro.build.version.sdk value from device
       sleep 10
    done
    adb devices
    sleep 10
    adb shell settings put global window_animation_scale 0 &
    adb shell settings put global transition_animation_scale 0 &
    adb shell settings put global animator_duration_scale 0 &
    ./gradlew connectedAndroidTest
    retval=$?
    if [ $retval -ne 0 ]; then
      echo "error on assembling, exit code: "$retval
      exit $retval
    fi
#    ./gradlew uninstallAll
#    ./gradlew installDebugAndroidTest
#    retval=$?
#    if [ $retval -ne 0 ]; then
#      echo "error on install, exit code: "$retval
#      exit $retval
#    fi
#    adb shell am instrument -w -r -e package com.hustunique.parsingplayer -e debug false com.hustunique.parsingplayer.test/android.support.test.runner.AndroidJUnitRunner
#    retval=$?
#    if [ $retval -ne 0 ]; then
#      echo "error in adb, exit code: "$retval
#      exit $retval
#    fi
elif [${TEST} == "unit"]; then
    ./gradlew --stacktrace test
    retval=$?
    if [ $retval -ne 0 ]; then
        echo "TEST FAILING"
        exit $retval
    fi
fi


