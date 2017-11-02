#define USE_DUMMY_DATA

#include "ofApp.h"

void ofApp::setup(){
 
    ofSetLogLevel(OF_LOG_VERBOSE);
    ofSetCircleResolution(360);
    ofLogNotice("setup") << "width : " << ofGetWidth() << ", height : " << ofGetHeight();

#ifdef USE_DUMMY_DATA
    ofxJSONElement json = handler.getDataFromDummyFile("sessionExample.json");
    BrushData::createData(json, data);
#else
    ofRegisterURLNotification(this);
    handler.getDataFromServer();
#endif

}

void ofApp::update(){
    num = ofGetFrameNum()*0.5f;
    num = MIN(data.size(), num);
}

void ofApp::draw(){
    ofBackground(255);
    
    float x = ofGetWidth()/2;
    float y = ofGetHeight()/2;
    float rad = ofGetWidth()/2;

    ofPushMatrix();{
        viz.draw_hour   (x, y, rad * 0.4, data, num);
        viz.draw_day    (x, y, rad * 0.6, data, num);
        viz.draw_week   (x, y, rad * 0.7, data, num);
        viz.draw_month  (x, y, rad * 0.8, data, num);
        viz.draw_year   (x, y, rad * 0.9, data, num);

        ofBackground(255);

        voro.addVertices(viz.plotHour);
        voro.addVertices(viz.plotDay);
        voro.addVertices(viz.plotWeek);
        voro.addVertices(viz.plotMonth);
        voro.addVertices(viz.plotYear);

        voro.create();
        voro.draw();
        
//        ofSetColor(255);
//        ofFill();
//        ofDrawCircle(x, y, rad*0.4);

        ofSetColor(150,200);
        ofSetLineWidth(1);
        ofNoFill();
        ofDrawCircle(x, y, rad*0.4);
        
        viz.draw_hour   (x, y, rad * 0.25, data, num);
        viz.draw_day    (x, y, rad * 0.28, data, num);
        viz.draw_week   (x, y, rad * 0.30, data, num);
        viz.draw_month  (x, y, rad * 0.32, data, num);
        viz.draw_year   (x, y, rad * 0.35, data, num);
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
        }
    }
}


void ofApp::exit() {
    ofxiOSAlerts.removeListener(this);
    ofUnregisterURLNotification(this);
}
