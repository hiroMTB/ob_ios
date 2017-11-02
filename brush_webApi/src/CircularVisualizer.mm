#include "CircularVisualizer.h"
#include "ofApp.h"
#include "BrushColor.h"
#include "ofRange.h"

CircularVisualizer::CircularVisualizer(){
    
}

void CircularVisualizer::composePlotData(vector<BrushData> & data){
    
    vector<ofRange> ranges;
    
    for(int i=0; i<data.size(); i++){
        
        BrushData & s = data[i];
        
        // Hour
        float start = s.start.tm_min + s.start.tm_sec/60.0f;
        float end   = s.end.tm_min + s.end.tm_sec/60.0f;
        float startDeg = start/60.0f * 360.0f - 90.0f;
        float endDeg = end/60.0f * 360.0f - 90.0f;
        float startRad = ofDegToRad(startDeg);
        float endRad = ofDegToRad(endDeg);
        
        ofRange range(startDeg, endDeg);
        int intersect = 0;
        if(range.span() < 5.0f/60.0f*360.0f){
            for(int j=0; j<ranges.size(); j++){
                if(ranges[j].intersects(range)){
                    intersect++;
                }
            }
        }
        
        PlotData & p = s.pHour;
        p.radius     = 0.3 * ofGetWidth()/2;
        p.size       = MAX(p.radius*0.01f, 4);  // thickness
        p.stAngle    = startDeg;
        p.endAngle   = endDeg;
        p.stPos.x    = p.radius * cos(startRad);
        p.stPos.y    = p.radius * sin(startRad);
        p.endPos.x   = p.radius * cos(endRad);
        p.endPos.y   = p.radius * sin(endRad);
        p.level      = intersect;
        p.color      = ob::color::hour;
        ranges.push_back(range);
    }
    
    for(int i=0; i<data.size(); i++){
        
        BrushData & s = data[i];
        
        // day
        PlotData & p = s.pDay;
        p.radius = 0.5 * ofGetWidth()/2;
        float start = s.start.tm_hour + s.start.tm_min/60.0f;
        p.stAngle   = p.endAngle = start/24.0f * 360.0f -90.0f;
        p.stPos.x   = p.radius * cos(ofDegToRad(p.stAngle));
        p.stPos.y   = p.radius * sin(ofDegToRad(p.stAngle));
        p.size      = ofGetWidth()*0.005f * s.duration/120.0f;
        p.color     = ob::color::day;
    }

    // week
    vector<int> wdayCnt;
    wdayCnt.assign(7, 0);

    for(int i=0; i<data.size(); i++){
        
        BrushData & s = data[i];
        PlotData & p = s.pWeek;
        int wday = s.start.tm_wday;
        float start = wday + s.start.tm_hour/23.0f;
        float startDeg = start/7.0f * 360.0f - 90.0;
        float startRad = ofDegToRad(startDeg);
        float baseRadius = 0.6 * ofGetWidth()/2;
        p.level = wdayCnt[wday];
        p.radius = baseRadius + 2.0f * wdayCnt[wday];

        p.stAngle   = p.endAngle = startDeg;
        p.stPos.x   = p.radius * cos(startRad);
        p.stPos.y   = p.radius * sin(startRad);
        p.size      = ofGetWidth()*0.005f * s.duration/120.0f;
        p.color     = ob::color::week;
        p.size = ofGetWidth()*0.005f * s.duration/120.0f;
        
        wdayCnt[wday]++;
    }
    
    // month
    vector<int> mdayCnt;
    mdayCnt.assign(31, 0);
    for(int i=0; i<data.size(); i++){
        
        BrushData & s = data[i];
        PlotData & p = s.pMonth;

        int mday = s.start.tm_mday - 1; // 0 - 30 days
        float start = mday + s.start.tm_hour/23.0f;
        float startDeg = start/31.0f * 360.0f - 90.0;
        float startRad = ofDegToRad(startDeg);
        float baseRadius = 0.7 * ofGetWidth()/2;
        p.radius = baseRadius + 3.0f * mdayCnt[mday];
        p.stAngle   = p.endAngle = startDeg;
        p.stPos.x   = p.radius * cos(startRad);
        p.stPos.y   = p.radius * sin(startRad);
        p.size      = ofGetWidth()*0.005f * s.duration/120.0f;
        p.color     = ob::color::month;
        p.size = ofGetWidth()*0.005f * s.duration/120.0f;
    }
    
    vector<int> ydayCnt;
    ydayCnt.assign(365, 0);
    for(int i=0; i<data.size(); i++){
        
        BrushData & s = data[i];
        PlotData & p = s.pMonth;
        
        int yday = s.start.tm_yday;
        float start = yday + s.start.tm_hour/23.0f;
        float startDeg = start/365.0f*360.0f - 90.0;
        float startRad = ofDegToRad(startDeg);
        float baseRadius = 0.8 * ofGetWidth()/2;
        p.radius = baseRadius + 4.0f * ydayCnt[yday];
        
        p.stAngle   = p.endAngle = startDeg;
        p.stPos.x   = p.radius * cos(startRad);
        p.stPos.y   = p.radius * sin(startRad);
        p.size      = ofGetWidth()*0.005f * s.duration/120.0f;
        p.color     = ob::color::year;
        p.size = ofGetWidth()*0.005f * s.duration/120.0f;
    }
}

void CircularVisualizer::draw_hour(float x, float y, float scale){
    ofApp & app = ofApp::get();
    vector<BrushData> & data = app.data;
    
    for(int i=0; i<data.size(); i++){
        
        const BrushData & s = data[i];
        const PlotData & p = s.pHour;
        float startDeg  = p.stAngle;
        float endDeg    = p.endAngle;
       
        int intersect   = p.level;
        float size      = p.size;
        float r         = p.radius + (2+size)*intersect;
        
        ofPath arc;
        arc.arc(x, y, r, r, startDeg, endDeg);
        arc.arcNegative(x, y, r+size, r+size, endDeg, startDeg);
        arc.close();
        arc.setCircleResolution(360);
        arc.setColor(p.color);
        arc.draw();
    }
}

void CircularVisualizer::draw_day(float x, float y, float scale){
    ofApp & app = ofApp::get();
    vector<BrushData> & data = app.data;
    for(int i=0; i<data.size(); i++){
        const BrushData & s = data[i];
        const PlotData & p = s.pDay;

        float posx = x + p.stPos.x;
        float posy = y + p.stPos.y;
        float size = p.size;

        ofFill();
        ofSetColor(p.color);
        ofDrawCircle(posx, posy, size);
    }
}

void CircularVisualizer::draw_week(float x, float y, float scale){
    ofApp & app = ofApp::get();
    vector<BrushData> & data = app.data;
    for(int i=0; i<data.size(); i++){

        const BrushData & s = data[i];
        const PlotData & p = s.pWeek;
        
        float posx = x + p.stPos.x;
        float posy = y + p.stPos.y;
        float size = p.size;
        
        ofFill();
        ofSetColor(p.color);
        ofDrawCircle(posx, posy, size);
    }
}

void CircularVisualizer::draw_month(float x, float y, float scale){
    ofApp & app = ofApp::get();
    vector<BrushData> & data = app.data;

    for(int i=0; i<data.size(); i++){
        
        const BrushData & s = data[i];
        const PlotData & p = s.pMonth;
        float posx = x + p.stPos.x;
        float posy = y + p.stPos.y;
        float size = p.size;
        
        ofFill();
        ofSetColor(p.color);
        ofDrawCircle(posx, posy, size);
    }
}

void CircularVisualizer::draw_year(float x, float y, float scale){
    ofApp & app = ofApp::get();
    vector<BrushData> & data = app.data;
    for(int i=0; i<data.size(); i++){
        
        const BrushData & s = data[i];
        const PlotData & p = s.pMonth;
        float posx = x + p.stPos.x;
        float posy = y + p.stPos.y;
        float size = p.size;
        
        ofFill();
        ofSetColor(p.color);
        ofDrawCircle(posx, posy, size);
    }
}
