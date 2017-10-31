#define USE_DUMMY_DATA

#include "ofApp.h"

void ofApp::setup(){
 
    ofSetLogLevel(OF_LOG_VERBOSE);
    ofSetCircleResolution(360);
    ofLogNotice("setup") << "width : " << ofGetWidth() << ", height : " << ofGetHeight();

#ifdef USE_DUMMY_DATA
    handler.getDataFromDummyFile("sessionExample.json");
    BrushData::createData(json, data);
#else
    ofRegisterURLNotification(this);
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

void ofApp::urlResponse(ofHttpResponse & response){
    string name = response.request.name;
    
    if(response.status==200){
        ofxJSONElement json;
        ofBuffer buf = response.data;
        string raw = ofToString(buf);
        json.parse(raw);
        
        if(name == "session data"){
            BrushData::createData(json, data);
            viz.create();
        }
    }
}


void ofApp::exit() {
    ofxiOSAlerts.removeListener(this);
    ofUnregisterURLNotification(this);
}
