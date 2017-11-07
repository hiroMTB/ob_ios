#pragma once

#include "ofxiOS.h"
#include "ofMain.h"
#include "ofxSpaceColonization.h"

class ofApp : public ofxiOSApp{
    
public:
    void setup();
    void update();
    void draw();
    
    void setPointsAndBuild();
    
    ofxSpaceColonization tree;
    ofEasyCam camera;
    
    ofVboMesh vboLines;
    ofVboMesh vboPoints;
    
    vector<glm::vec3> points;
};
