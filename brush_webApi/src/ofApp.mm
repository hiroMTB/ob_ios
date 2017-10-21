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
    ofPushMatrix();{
        float rad = ofGetWidth()/2;
        viz.draw_hour   (ofGetWidth()/2, ofGetHeight()/2, rad * 0.1);
        viz.draw_day    (ofGetWidth()/2, ofGetHeight()/2, rad * 0.2);
        viz.draw_week   (ofGetWidth()/2, ofGetHeight()/2, rad * 0.4);
        viz.draw_month  (ofGetWidth()/2, ofGetHeight()/2, rad * 0.6);
        viz.draw_year   (ofGetWidth()/2, ofGetHeight()/2, rad * 0.8);
    }ofPopMatrix();
}
