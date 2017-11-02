#include "CircularVisualizer.h"
#include "ofApp.h"
#include "BrushDataHandler.h"
#include "BrushColor.h"
#include "ofRange.h"

CircularVisualizer::CircularVisualizer(){
    
}

void CircularVisualizer::draw_hour(float x, float y, float radius){
    
    plotHour.clear();
    
    vector<BrushData> & data = ofApp::get().data;
    
    vector<ofRange> ranges;
    
    for(int i=0; i<data.size(); i++){
        
        const BrushData & s = data[i];
        float start = s.start.tm_min + s.start.tm_sec/60.0f;
        float end   = s.end.tm_min + s.end.tm_sec/60.0f;
        float startDeg = start/60.0f * 360.0f - 90.0f;
        float endDeg = end/60.0f * 360.0f - 90.0f;
        float thickness = MAX(radius*0.01f, 4);

        ofRange range(startDeg, endDeg);
        int intersect = 0;
        if(range.span() < 5.0f/60.0f*360.0f){
            for(int j=0; j<ranges.size(); j++){
                if(ranges[j].intersects(range)){
                    intersect++;
                }
            }
        }
        float r = radius+(thickness+5)*intersect;
        
        ofPath arc;
        arc.arc(x, y, r, r, startDeg, endDeg);
        arc.arcNegative(x, y, r+thickness, r+thickness, endDeg, startDeg);
        arc.close();
        arc.setCircleResolution(360);
        arc.setColor(ob::color::hour);
        arc.draw();
        ranges.push_back(range);
        
        float startRad = ofDegToRad(startDeg);
        float endRad = ofDegToRad(endDeg);
        
        float posStx = x + r*cos(startRad);
        float posSty = y + r*sin(startRad);

        float posEndx = x + r*cos(endRad);
        float posEndy = y + r*sin(endRad);

        plotHour.push_back(glm::vec2(posStx, posSty));
        plotHour.push_back(glm::vec2(posEndx, posEndy));        
    }
}

void CircularVisualizer::draw_day(float x, float y, float radius){
    
    plotDay.clear();
    
    vector<BrushData> & data = ofApp::get().data;
    
    for(int i=0; i<data.size(); i++){
        const BrushData & s = data[i];
        float start = s.start.tm_hour + s.start.tm_min/60.0f;
        float startDeg = start/24.0f * 360.0f -90.0f;
        float startRad = ofDegToRad(startDeg);

        float posx = x + radius * cos(startRad);
        float posy = y + radius * sin(startRad);

        float duration = s.duration;
        float size = ofGetWidth()*0.005f * duration/180.0f;

        ofFill();
        ofSetColor(ob::color::day);
        ofDrawCircle(posx, posy, size);
        
        plotDay.push_back(glm::vec2(posx, posy));
    }
}

void CircularVisualizer::draw_week(float x, float y, float radius){
    plotWeek.clear();
    
    vector<BrushData> & data = ofApp::get().data;    vector<int> wdayCnt;
    
    wdayCnt.assign(7, 0);
    
    for(int i=0; i<data.size(); i++){
        const BrushData & s = data[i];
        int wday = s.start.tm_wday;
        float start = wday + s.start.tm_hour/23.0f;
        float startDeg = start/7.0f * 360.0f - 90.0;
        float startRad = ofDegToRad(startDeg);

        float gap = 3;
        float r = radius + (gap+2) * wdayCnt[wday];
        float posx = x + r * cos(startRad);
        float posy = y + r * sin(startRad);

        float duration = s.duration;
        float size = ofGetWidth()*0.005f * duration/180.0f;
        ofFill();
        ofSetColor(ob::color::week);
        ofDrawCircle(posx, posy, size);
        wdayCnt[wday]++;
        
        plotWeek.push_back(glm::vec2(posx, posy));
    }
}

void CircularVisualizer::draw_month(float x, float y, float radius){
    
    plotMonth.clear();
    
    vector<BrushData> & data = ofApp::get().data;    vector<int> mdayCnt;
    
    mdayCnt.assign(31, 0);
    
    for(int i=0; i<data.size(); i++){
        const BrushData & s = data[i];
        int mday = s.start.tm_mday - 1; // 0 - 30 days
        float start = mday + s.start.tm_hour/23.0f;
        float startDeg = start/31.0f * 360.0f - 90.0;
        float startRad = ofDegToRad(startDeg);
        float gap = 2.0f;
        float r = radius + (gap+1) * mdayCnt[mday];
        float posx = x + r * cos(startRad);
        float posy = y + r * sin(startRad);
        
        float duration = s.duration;
        float size = ofGetWidth()*0.005f * duration/180.0f;
        
        ofFill();
        ofSetColor(ob::color::month);
        ofDrawCircle(posx, posy, size);
        mdayCnt[mday]++;
        
        plotMonth.push_back(glm::vec2(posx, posy));
    }
}

void CircularVisualizer::draw_year(float x, float y, float radius){
    
    plotYear.clear();
    
    vector<BrushData> & data = ofApp::get().data;
    
    vector<int> ydayCnt;
    
    ydayCnt.assign(365, 0);
    for(int i=0; i<data.size(); i++){
        const BrushData & s = data[i];
        int yday = s.start.tm_yday;
        float start = yday + s.start.tm_hour/23.0f;
        float startDeg = start/365.0f*360.0f - 90.0;
        float startRad = ofDegToRad(startDeg);
        float gap = 1.0f;
        float r = radius; // + (gap+2) * ydayCnt[yday];
        float posx = x + r * cos(startRad);
        float posy = y + r * sin(startRad);
        
        float duration = s.duration;
        float size = ofGetWidth()*0.005f * duration/180.0f;
        
        ofFill();
        ofSetColor(ob::color::year);
        ofDrawCircle(posx, posy, size);
        ydayCnt[yday]++;
        
        plotYear.push_back(glm::vec2(posx, posy));

    }
}
