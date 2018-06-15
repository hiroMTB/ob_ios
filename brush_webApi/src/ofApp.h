#pragma once

#include "ofxiOS.h"
#include "CircularVisualizer.h"
#include "BrushDataHandler.h"
#include "BrushData.h"
#include "Voro.h"
#include "Np.h"
#include "Colo.h"
#include "Guide.h"

#include <unordered_map>

class ofApp : public ofxiOSApp{
    
public:
    ofApp();
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
    
    unordered_map<ob::plot::TYPE, float> radiusData;
    vector<BrushData> data;
    BrushDataHandler handler;

    CircularVisualizer viz;
    Voro voro;
    Np np;
    Guide guide;
    vector<Colo> colos;
    
    int num = 0;
    
    bool bInitialized = false;
};


