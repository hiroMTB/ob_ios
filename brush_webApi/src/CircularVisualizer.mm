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
        
        {
            // Hour
            float start = s.start.tm_min + s.start.tm_sec/60.0f;
            float end   = s.end.tm_min + s.end.tm_sec/60.0f;
            float startDeg = start/60.0f * 360.0f - 90.0f;
            float endDeg = end/60.0f * 360.0f - 90.0f;
            
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
            p.stPos.x    = p.radius * cos(ofDegToRad(p.stAngle));
            p.stPos.y    = p.radius * sin(ofDegToRad(p.stAngle));
            p.endPos.x   = p.radius * cos(ofDegToRad(p.endAngle));
            p.endPos.y   = p.radius * sin(ofDegToRad(p.endAngle));
            p.level      = intersect;
            p.color      = ob::color::hour;
            ranges.push_back(range);
        }
        
        {
            // day
            PlotData & p = s.pDay;
            p.radius = 0.5 * ofGetWidth()/2;
            float start = s.start.tm_hour + s.start.tm_min/60.0f;
            p.stAngle   = p.endAngle = start/24.0f * 360.0f -90.0f;
            p.stPos.x   = p.radius * cos(ofDegToRad(p.stAngle));
            p.stPos.y   = p.radius * sin(ofDegToRad(p.stAngle));
            p.size      = ofGetWidth()*0.01f * s.duration/120.0f;
            p.color     = ob::color::day;
        }
        
        {
            // week
            
        }
        
    }
}

void CircularVisualizer::draw_hour(float x, float y, float radius){
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

void CircularVisualizer::draw_week(float x, float y, float radius){
    ofApp & app = ofApp::get();
    vector<BrushData> & data = app.data;
    vector<int> wdayCnt;
    wdayCnt.assign(7, 0);
    for(int i=0; i<data.size(); i++){
        const BrushData & s = data[i];
        int wday = s.start.tm_wday;
        float startDeg = wday/7.0f * 360.0f - 90.0;
        float startRad = ofDegToRad(startDeg);

        float gap = 3;
        float r = radius + (gap+2) * wdayCnt[wday];
        float posx = x + r * cos(startRad);
        float posy = y + r * sin(startRad);

        float duration = s.duration;
        float size = ofGetWidth()*0.01f * duration/120.0f;
        ofFill();
        ofSetColor(ob::color::week);
        ofDrawCircle(posx, posy, size);
        wdayCnt[wday]++;
    }
}

void CircularVisualizer::draw_month(float x, float y, float radius){
    ofApp & app = ofApp::get();
    vector<BrushData> & data = app.data;
    vector<int> mdayCnt;
    mdayCnt.assign(31, 0);
    for(int i=0; i<data.size(); i++){
        const BrushData & s = data[i];
        int mday = s.start.tm_mday - 1;
        float startDeg = mday/31.0f * 360.0f - 90.0;
        float startRad = ofDegToRad(startDeg);
        float gap = 3.0f;
        float r = radius + (gap+2) * mdayCnt[mday];
        float posx = x + r * cos(startRad);
        float posy = y + r * sin(startRad);
        
        float duration = s.duration;
        float size = ofGetWidth()*0.01f * duration/120.0f;
        
        ofFill();
        ofSetColor(ob::color::month);
        ofDrawCircle(posx, posy, size);
        mdayCnt[mday]++;
    }
}

void CircularVisualizer::draw_year(float x, float y, float radius){
    ofApp & app = ofApp::get();
    vector<BrushData> & data = app.data;
    vector<int> ydayCnt;
    ydayCnt.assign(365, 0);
    for(int i=0; i<data.size(); i++){
        const BrushData & s = data[i];
        int yday = s.start.tm_yday;
        float startDeg = yday/365.0f*360.0f - 90.0;
        float startRad = ofDegToRad(startDeg);
        float gap = 3.0f;
        float r = radius + (gap+2) * ydayCnt[yday];
        float posx = x + r * cos(startRad);
        float posy = y + r * sin(startRad);
        
        float duration = s.duration;
        float size = ofGetWidth()*0.01f * duration/120.0f;
        
        ofFill();
        ofSetColor(ob::color::year);
        ofDrawCircle(posx, posy, size);
        ydayCnt[yday]++;
    }
}
