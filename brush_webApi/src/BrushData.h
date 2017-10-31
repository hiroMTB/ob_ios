#pragma once

#include "ofMain.h"
#include "ofxJSON.h"

class PlotData{
    
public:
    PlotData(){}
    
    glm::vec2 stPos;
    glm::vec2 endPos;
    
    float stAngle;
    float endAngle;
    float radius;    // dist from center
    float size;           // circle size, arc thickness, etc
    int level;            // override level
    ofColor color;
};


class BrushData{
    
public:
    BrushData(){};
    int pressureCount;
    int pressureTime;
    int duration;
    
    std::tm start;
    std::tm end;
    
    // x: start_deg, y: end_deg
    PlotData pHour;
    PlotData pDay;
    PlotData pWeek;
    PlotData pMonth;
    PlotData pYear;

    static void createData(ofxJSONElement & elem, vector<BrushData> & data);
    
    void print(){
        //cout << start << " - " << end << ", dur " << duration << ", pcnt " << pressureCount << ", pressureTIme " << pressureTIme << '\n';
    }
};
