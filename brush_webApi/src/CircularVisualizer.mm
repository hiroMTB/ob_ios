#include "CircularVisualizer.h"
#include "ofApp.h"
#include "BrushDataHandler.h"

CircularVisualizer::CircularVisualizer(){
    
}

void CircularVisualizer::draw_hour(){
    const ofApp & app = ofApp::get();
    const BrushDataHandler & bd = app.handler;
    const vector<BrushSession> & data = bd.sessionData();
    for(int i=0; i<data.size(); i++){
        
        const BrushSession & s = data[i];
        cout << "st " << s.date() << endl;
        
    }
}

void CircularVisualizer::draw_day(){
    
}

void CircularVisualizer::draw_week(){
    
}

void CircularVisualizer::draw_month(){
    
}

void CircularVisualizer::draw_year(){
    
}
