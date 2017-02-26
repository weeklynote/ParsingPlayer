#!/bin/bash
echo "TESTING..."
if [ ${TEST} == "android" ]; then
    ./gradlew --stacktrace connectedAndroidTest
elif [${TEST} == "unit"]; then
    ./gradlew --stacktrace test
    retval=$?
    if [ $retval -ne 0 ]; then
        echo "TEST FAILED: " $retval
        exit $retval
    fi
fi
echo "TEST DONE"

