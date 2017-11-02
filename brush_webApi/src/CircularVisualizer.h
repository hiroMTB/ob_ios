#pragma once

#include "ofMain.h"
#include "BrushData.h"

class CircularVisualizer{
    
public:
    
    CircularVisualizer();
    
    void draw_hour(float x, float y, float radius, const vector<BrushData> & data, int num);
    void draw_day(float x, float y, float radius, const vector<BrushData> & data, int num);
    void draw_week(float x, float y, float radius, const vector<BrushData> & data, int num);
    void draw_month(float x, float y, float radius, const vector<BrushData> & data, int num);
    void draw_year(float x, float y, float radius, const vector<BrushData> & data, int num);
    
    vector<glm::vec2> plotHour;
    vector<glm::vec2> plotDay;
    vector<glm::vec2> plotWeek;
    vector<glm::vec2> plotMonth;
    vector<glm::vec2> plotYear;

};
