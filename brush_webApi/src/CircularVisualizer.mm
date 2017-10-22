#include "CircularVisualizer.h"
#include "ofApp.h"
#include "BrushDataHandler.h"
#include "ofRange.h"

CircularVisualizer::CircularVisualizer(){
    
}

void CircularVisualizer::draw_hour(float x, float y, float radius){
    const ofApp & app = ofApp::get();
    const BrushDataHandler & bd = app.handler;
    const vector<BrushData> & data = bd.data;
    
    vector<ofRange> ranges;
    
    for(int i=0; i<data.size(); i++){
        
        const BrushData & s = data[i];
        float start = s.start.tm_min + s.start.tm_sec/60.0f;
        float end   = s.end.tm_min + s.end.tm_sec/60.0f;
        float startDeg = start/60.0f * 360.0f - 90.0f;
        float endDeg = end/60.0f * 360.0f - 90.0f;
        float thickness = MAX(radius*0.01f, 3);
    
        ofRange range(startDeg, endDeg);
        int intersect = 0;
        if(range.span() < 5.0f/60.0f*360.0f){
            for(int j=0; j<ranges.size(); j++){
                if(ranges[j].intersects(range)){
                    intersect++;
                }
            }
        }
        float r = radius+(thickness+2)*intersect;
        ofPath arc;
        arc.arc(x, y, r, r, startDeg, endDeg);
        arc.arcNegative(x, y, r+thickness, r+thickness, endDeg, startDeg);
        arc.close();
        arc.setCircleResolution(360);
        arc.setColor(ofFloatColor(1,1,1,0.7));
        arc.draw();
        
        ranges.push_back(range);
    }
}

void CircularVisualizer::draw_day(float x, float y, float radius){
    const ofApp & app = ofApp::get();
    const BrushDataHandler & bd = app.handler;
    const vector<BrushData> & data = bd.data;
    for(int i=0; i<data.size(); i++){
        const BrushData & s = data[i];
        float start = s.start.tm_hour + s.start.tm_min/60.0f;
        float startDeg = start/24.0f * 360.0f -90.0f;
        float startRad = ofDegToRad(startDeg);
        float posx = x + radius * sin(startRad);
        float posy = y + radius * cos(startRad);

        ofSetLineWidth(1);
        ofSetColor(ofFloatColor(1,1,1,0.7));
        ofDrawCircle(posx, posy, 3);
    }
}

void CircularVisualizer::draw_week(float x, float y, float radius){
    const ofApp & app = ofApp::get();
    const BrushDataHandler & bd = app.handler;
    const vector<BrushData> & data = bd.data;
    vector<int> wdayCnt;
    wdayCnt.assign(7, 0);
    for(int i=0; i<data.size(); i++){
        const BrushData & s = data[i];
        int wday = s.start.tm_wday;
        float startDeg = wday/7.0f * 360.0f - 90.0;
        float startRad = ofDegToRad(startDeg);

        float size = 3.0f;
        float r = radius + (size+2) * wdayCnt[wday];
        float posx = x + r * sin(startRad);
        float posy = y + r * cos(startRad);

        ofSetLineWidth(1);
        ofSetColor(ofFloatColor(1,1,1,0.7));
        ofDrawCircle(posx, posy, size);
        wdayCnt[wday]++;
    }
}

void CircularVisualizer::draw_month(float x, float y, float radius){
    const ofApp & app = ofApp::get();
    const BrushDataHandler & bd = app.handler;
    const vector<BrushData> & data = bd.data;
    vector<int> mdayCnt;
    mdayCnt.assign(31, 0);
    for(int i=0; i<data.size(); i++){
        const BrushData & s = data[i];
        int mday = s.start.tm_mday - 1;
        float startDeg = mday/31.0f * 360.0f - 90.0;
        float startRad = ofDegToRad(startDeg);
        float size = 3.0f;
        float r = radius + (size+2) * mdayCnt[mday];
        float posx = x + r * sin(startRad);
        float posy = y + r * cos(startRad);
        
        ofSetLineWidth(1);
        ofSetColor(ofFloatColor(1,1,1,0.7));
        ofDrawCircle(posx, posy, size);
        mdayCnt[mday]++;
    }
}

void CircularVisualizer::draw_year(float x, float y, float radius){
    const ofApp & app = ofApp::get();
    const BrushDataHandler & bd = app.handler;
    const vector<BrushData> & data = bd.data;
    vector<int> ydayCnt;
    ydayCnt.assign(365, 0);
    for(int i=0; i<data.size(); i++){
        const BrushData & s = data[i];
        int yday = s.start.tm_yday;
        float startDeg = yday/365.0f*360.0f - 90.0;
        float startRad = ofDegToRad(startDeg);
        float size = 3.0f;
        float r = radius + (size+2) * ydayCnt[yday];
        float posx = x + r * sin(startRad);
        float posy = y + r * cos(startRad);
        
        ofSetLineWidth(1);
        ofSetColor(ofFloatColor(1,1,1,0.7));
        ofDrawCircle(posx, posy, size);
        ydayCnt[yday]++;
    }
}