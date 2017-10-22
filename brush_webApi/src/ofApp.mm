#define USE_DUMMY_DATA

#include "ofApp.h"

void ofApp::setup(){
 
    ofSetLogLevel(OF_LOG_VERBOSE);
    ofSetCircleResolution(360);
    ofLogNotice("setup") << "width : " << ofGetWidth() << ", height : " << ofGetHeight();
    
#ifdef USE_DUMMY_DATA
    handler.getDummyData("sessionExample.json");
#else
    handler.getDataFromServer();
#endif
}

void ofApp::draw(){
    ofBackground(255);
    
    float x = ofGetWidth()/2;
    float y = ofGetHeight()/2;
    float rad = ofGetWidth()/2;
    
    ofPushMatrix();{
        viz.draw_hour   (x, y, rad * 0.2);
        viz.draw_day    (x, y, rad * 0.4);
        viz.draw_week   (x, y, rad * 0.5);
        viz.draw_month  (x, y, rad * 0.6);
        viz.draw_year   (x, y, rad * 0.7);
    }ofPopMatrix();
}
