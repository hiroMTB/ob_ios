#pragma once

#include "ofxiOS.h"
#include "ofMain.h"
#include "ofxSpaceColonization.h"
#include "ofxGui.h"

class ofApp : public ofxiOSApp{

public:
    void setup();
    void update();
    void draw();
    void maybeDrawGui();

    void keyPressed(int key);
    void keyReleased(int key);
    void mouseMoved(int x, int y );
    void mouseDragged(int x, int y, int button);
    void mousePressed(int x, int y, int button);
    void mouseReleased(int x, int y, int button);
    void mouseEntered(int x, int y);
    void mouseExited(int x, int y);
    void windowResized(int w, int h);
    void dragEvent(ofDragInfo dragInfo);
    void gotMessage(ofMessage msg);
    void selectedMinDistChanghed(int & aselectedMinDist);
    void selectedMaxDistChanghed(int & aselectedMaxDist);
    void selectedLengthChanghed(int & aselectedLength);
    void radiusChanghed(float & radius);
    void radiusScaleChanghed(float & radiusScaleChanghed);
    void buildAgainPressed();
    void angleChanghed(float & angle);
    void deviationOnYChanghed(float & yDev);
    void deviationOnXChanghed(float & xDev);
    void nVerticesChanghed(int & nVertices);

    ofxPanel gui;
    ofParameter<int>    selectedMaxDist;
    ofParameter<int>    selectedMinDist;
    ofParameter<int>    selectedLength;
    ofParameter<int>    slowness;
    ofxFloatSlider      radius;
    ofxFloatSlider      radiusScale;
    ofxButton           buildAgain;
    ofxToggle           showWireframe;

    ofxColorSlider diffuseColor;
    ofxColorSlider emissiveColor;
    ofxColorSlider lightColor;
    ofxColorSlider bgColor;

    ofxSpaceColonization tree;
    ofMaterial mat;
    ofLight light;
    bool drawGui = true;
    ofEasyCam camera;
    
};
