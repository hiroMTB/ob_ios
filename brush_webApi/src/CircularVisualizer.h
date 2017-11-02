#pragma once

#include "ofMain.h"

class CircularVisualizer{
    
public:
    
    CircularVisualizer();
    
    void draw_hour(float x, float y, float radius);
    void draw_day(float x, float y, float radius);
    void draw_week(float x, float y, float radius);
    void draw_month(float x, float y, float radius);
    void draw_year(float x, float y, float radius);
    
    vector<glm::vec2> plotHour;
    vector<glm::vec2> plotDay;
    vector<glm::vec2> plotWeek;
    vector<glm::vec2> plotMonth;
    vector<glm::vec2> plotYear;

};
