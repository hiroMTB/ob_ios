#pragma once

#include "ofxiOS.h"
#include "ofxJSON.h"

class ofApp : public ofxiOSApp{
    
public:
    void setup();
    void draw();
    
    void draw_json( ofxJSONElement & elem);
    
    ofxJSONElement result;
    
    
    string baseurl = "https://api.developer.oralb.com/v1";
    string appId = "fac078cd-1cf0-4e04-82ab-385a98359d09";
    string appKey = "6bb594ec-2860-427e-8e34-891fdb33995d";
    string bear = "n.a";
    string authUrl = "n.a";
    
};


