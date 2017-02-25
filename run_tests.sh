#!/bin/bash
echo "RUN TEST"
./gradlew build
retval=$?
if [ $retval -ne 0 ]; then
    echo "error on assembling, exit code: "$retval
    exit $retval
fi
if [ ${TEST} == "android" ]; then
#    echo no | android create avd --force --name test --target $ANDROID_TARGET --abi $ANDROID_ABI --sdcard 800M
#    echo "runtime.network.latency=none" >> $HOME/.android/avd/test.avd/config.ini
#    echo "runtime.network.speed=full" >> $HOME/.android/avd/test.avd/config.ini
#    echo "hw.keyboard=yes" >> $HOME/.android/avd/test.avd/config.ini
#    emulator -avd test -debug all -memory 4000 -noskin -no-audio -cache-size 400 -netdelay none -netspeed full -no-window -no-boot-anim &
#    ./wait_for_emulator.sh
#    adb shell input keyevent 82 &
#    ANDROID_SERIAL='emulator-2226'
#    adb wait-for-device get-serialno
#    ./wait_for_emulator.sh
#    adb shell input keyevent 82 &
#    ANDROID_SERIAL=''
#    adb devices -l
#    cat $HOME/.android/avd/test.avd/config.ini
#    adb devices
#    sleep 10
#    adb shell settings put global window_animation_scale 0 &
#    adb shell settings put global transition_animation_scale 0 &
#    adb shell settings put global animator_duration_scale 0 &
    ./gradlew build connectedCheck
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


