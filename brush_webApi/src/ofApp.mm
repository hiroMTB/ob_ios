#define USE_DUMMY_DATA

#include "ofApp.h"

void ofApp::setup(){
 
    ofSetLogLevel(OF_LOG_VERBOSE);

#ifdef USE_DUMMY_DATA
    handler.getDummyData("sessionExample.json");
#else
    handler.getDataFromServer();
#endif
}

void ofApp::draw(){
    ofBackground(0);
    ofPushMatrix();{
        ofTranslate(20, 20);
        ofSetHexColor(0x00FF00);
    }ofPopMatrix();
}
