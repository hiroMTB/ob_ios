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
    ofBackground(0);
    
    float x = ofGetWidth()/2;
    float y = ofGetHeight()/2;
    float rad = ofGetWidth()/2;
    
    ofPushMatrix();{
        viz.draw_hour   (x, y, rad * 0.80);
        viz.draw_day    (x, y, rad * 0.82);
        viz.draw_week   (x, y, rad * 0.84);
        viz.draw_month  (x, y, rad * 0.86);
        viz.draw_year   (x, y, rad * 0.88);
    }ofPopMatrix();
}
