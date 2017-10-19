#include "ofApp.h"

void ofApp::setup(){
    cout << "setup : " << endl;
    
    handler.getDataFromServer();
}

void ofApp::draw(){
    ofBackground(0);
    ofPushMatrix();{
        ofTranslate(20, 20);
        ofSetHexColor(0x00FF00);
        //draw_json(data);
    }ofPopMatrix();
}

void ofApp::launchedWithURL(string url){
    cout << "launchedWithURL : " << url << endl;
    handler.launchedWithURL(url);
}

