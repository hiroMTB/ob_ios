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
    
    // x: start_deg, y: end_deg
    glm::vec2 aHour;
    glm::vec2 aDay;
    glm::vec2 aWeek;
    glm::vec2 aYear;

    static void createData(ofxJSONElement & elem, vector<BrushData> & data);
    
    void print(){
        //cout << start << " - " << end << ", dur " << duration << ", pcnt " << pressureCount << ", pressureTIme " << pressureTIme << '\n';
    }
};
