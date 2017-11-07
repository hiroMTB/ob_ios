#pragma once

#include "ofMain.h"
#include "ofxSpaceColonization.h"
#include "BrushData.h"

class Colo{
    
public:
    Colo();
    void addVertices(const vector<BrushData> & data, ob::plot::TYPE type, float minRad, float maxRad);
    void create();
    void draw();
    void clear();
    void update();
    
    vector<glm::vec3> pos;
    ofVboMesh mesh;

    ofxSpaceColonization tree;

};
