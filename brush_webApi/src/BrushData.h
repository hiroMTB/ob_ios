#pragma once

#include "ofMain.h"
#include "ofxJSON.h"

class BrushData{
    
public:
    BrushData(){};
    int pressureCount;
    int pressureTime;
    int duration;
    
    std::tm start;
    std::tm end;

    static void createData(ofxJSONElement & elem, vector<BrushData> & data);
    
    void print(){
        //cout << start << " - " << end << ", dur " << duration << ", pcnt " << pressureCount << ", pressureTIme " << pressureTIme << '\n';
    }
};
