#include "Guide.h"

Guide::Guide(){
    lines.setMode(OF_PRIMITIVE_LINES);
    points.setMode(OF_PRIMITIVE_POINTS);
    lines.setUsage(GL_STATIC_DRAW);
    points.setUsage(GL_STATIC_DRAW);
}

void Guide::create(unordered_map<TYPE, float> & radiusData){    
    addDot(radiusData[TYPE::HOUR] * ofGetWidth()/2,  0, TWO_PI, 60);
    addDot(radiusData[TYPE::DAY]  * ofGetWidth()/2,  0, TWO_PI, 24);
    addDot(radiusData[TYPE::WEEK] * ofGetWidth()/2,  0, TWO_PI, 7);
    addDot(radiusData[TYPE::MONTH]* ofGetWidth()/2,  0, TWO_PI, 31);
    addDot(radiusData[TYPE::YEAR] * ofGetWidth()/2,  0, TWO_PI, 356);
    
    // week lines
    addLine(radiusData[TYPE::MONTH] * ofGetWidth()/2 * 0.98,
            radiusData[TYPE::MONTH] * ofGetWidth()/2 * 1.02,
            0, TWO_PI, 31);

    addLine(radiusData[TYPE::WEEK] * ofGetWidth()/2 * 0.98,
            radiusData[TYPE::WEEK] * ofGetWidth()/2 * 1.02,
            0, TWO_PI, 7);

}

void Guide::draw(){
    
    ofSetLineWidth(1);
    lines.draw();
    
    glPointSize(2);
    points.draw();
}

void Guide::addDot(float r, float startRad, float endRad, int n){
    
    float adder = (endRad - startRad) / n;
    for(int i=0; i<n; i++){
        float rad = startRad + adder * i;
        float x = r * cos(rad);
        float y = r * sin(rad);
        
        points.addVertex(glm::vec3(x, y, 0));
        points.addColor(ofFloatColor(0,0,0));
    }
}

void Guide::addLine(float startR, float endR, float startRad, float endRad, int n){
    
    float adder = (endRad - startRad) / n;
    for(int i=0; i<n; i++){
        float rad = startRad + adder * i;
        float x1 = startR * cos(rad);
        float y1 = startR * sin(rad);
        
        float x2 = endR * cos(rad);
        float y2 = endR * sin(rad);

        lines.addVertex(glm::vec3(x1, y1, 0));
        lines.addVertex(glm::vec3(x2, y2, 0));
        lines.addColor(ofFloatColor(0,0,0,0.7));
        lines.addColor(ofFloatColor(0,0,0,0.7));
    }
}
