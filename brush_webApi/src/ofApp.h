#pragma once

#include "ofxiOS.h"
#include "CircularVisualizer.h"
#include "BrushDataHandler.h"
#include "BrushData.h"
#include "Voro.h"
#include "Np.h"
#include "Colo.h"

class ofApp : public ofxiOSApp{
    
public:
     ofApp(){ cout << "construct ofApp" << endl; }
    ~ofApp(){ cout << "destruct  ofApp" << endl; }

    void setup();
    void update();
    void draw();
    void exit();
    void urlResponse(ofHttpResponse & response);
    
    static ofApp & get(){
        static ofApp app;
        return app;
    }
      
    vector<BrushData> data;
    BrushDataHandler handler;

    CircularVisualizer viz;
    Voro voro;
    Np np;
    Colo colo;
    
    int num = 0;
    
    bool bInitialized = false;
};


