#pragma once

#include "ofMain.h"
#include "BrushData.h"

class CircularVisualizer{
    
public:
    
    CircularVisualizer();
  
    void composePlotData(vector<BrushData> & data);
    void draw_hour(float x, float y, float scale);
    void draw_day(float x, float y, float scale);
    void draw_week(float x, float y, float scale);
    void draw_month(float x, float y, float scale);
    void draw_year(float x, float y, float sc);
    
};
