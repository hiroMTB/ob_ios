#pragma once

#include "ofxiOS.h"
#include "ofxJSON.h"

class ofApp : public ofxiOSApp{
	
    public:
        void setup();
        void draw();
        ofxJSONElement result;
};


