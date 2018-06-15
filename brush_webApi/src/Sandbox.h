#pragma once

#include "ofMain.h"

namespace ob{
namespace sand{
    
    void drawArc(float r, float startDeg, float endDeg, float size, ofColor col){
        ofPath arc;
        arc.arc(0, 0, r, r, startDeg, endDeg);
        arc.arcNegative(0, 0, r+size, r+size, endDeg, startDeg);
        arc.close();
        arc.setCircleResolution(360);
        arc.setColor(col);
        arc.draw();
    }
    
    void drawArcDot(float r, float startRad, float endRad, int n){
     
        ofSetColor(0,0,0);
        ofFill();
        
        float adder = (endRad - startRad) / n;
        for(int i=0; i<n; i++){
            float rad = startRad + adder * i;
            float x = r * cos(rad);
            float y = r * sin(rad);
            
            ofDrawCircle(x, y, 1);
        }
    }
}
}
