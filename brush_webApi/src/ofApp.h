#pragma once

#include "ofxiOS.h"
#include "BrushDataHandler.h"
#include "CircularVisualizer.h"

class ofApp : public ofxiOSApp{
    
public:
    void setup();
    void draw();

    static ofApp & get(){
        static ofApp app;
        return app;
    }
    
    BrushDataHandler handler;
};


