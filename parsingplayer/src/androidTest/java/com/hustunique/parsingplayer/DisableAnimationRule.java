/*
 * Copyright (c) 2017 UniqueStudio
 *
 *
 * This file is part of ParsingPlayer.
 *
 * ParsingPlayer is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with ParsingPlayer; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 */

package com.hustunique.parsingplayer;

import android.os.IBinder;

import org.junit.rules.TestRule;
import org.junit.runner.Description;
import org.junit.runners.model.Statement;

import java.lang.reflect.Method;
import java.util.Arrays;

/**
 * Created by JianGuo on 2/25/17.
 */

public class DisableAnimationRule implements TestRule {
    private Method mSetAnimationScalesMethod;
    private Method mGetAnimationScalesMethod;
    private Object mWindowManagerObject;
    public DisableAnimationRule() {
        try {
            Class<?> windowManagerStubClazz = Class.forName("android.view.IWindowManager$Stub");
            Method asInterface = windowManagerStubClazz.getDeclaredMethod("asInterface", IBinder.class);
            Class<?> serviceManagerClazz = Class.forName("android.os.ServiceManager");
            Method getService = serviceManagerClazz.getDeclaredMethod("getService", String.class);
            Class<?> windowManagerClazz = Class.forName("android.view.IWindowManager");
            mSetAnimationScalesMethod = windowManagerClazz.getDeclaredMethod("setAnimationScales", float[].class);
            mGetAnimationScalesMethod = windowManagerClazz.getDeclaredMethod("getAnimationScales");
            IBinder windowManagerBinder = (IBinder) getService.invoke(null, "window");
            mWindowManagerObject = asInterface.invoke(null, windowManagerBinder);
        }
        catch (Exception e) {
            throw new RuntimeException("Failed to access animation methods", e);
        }
    }
    @Override
    public Statement apply(final Statement statement, Description description) {
        return new Statement() {
            @Override
            public void evaluate() throws Throwable {
                setAnimationScaleFactors(0.0f);
                try { statement.evaluate(); }
                finally { setAnimationScaleFactors(1.0f); }
            }
        };
    }
    private void setAnimationScaleFactors(float scaleFactor) throws Exception {
        float[] scaleFactors = (float[]) mGetAnimationScalesMethod.invoke(mWindowManagerObject);
        Arrays.fill(scaleFactors, scaleFactor);
        mSetAnimationScalesMethod.invoke(mWindowManagerObject, scaleFactors);
    }
}
