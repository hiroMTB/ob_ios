#pragma once

#include "ofxiOS.h"
#include "BrushDataHandler.h"

class ofApp : public ofxiOSApp{
    
public:
    void setup();
    void draw();
        
    void launchedWithURL(string url);

    BrushDataHandler handler;
};


