#pragma once 

#include "ofMain.h"
#include "BrushData.h"
#include <unordered_map>

using namespace ob::plot;

class Guide{
    
public:

    Guide();
    void create(unordered_map<TYPE, float> & radiusData);
    void draw();
    void addDot(float r, float startRad, float endRad, int n);
    void addLine(float r, float len, float startRad, float endRad, int n);

    ofVboMesh points;
    ofVboMesh lines;
    
};
