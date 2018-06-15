#include "Colo.h"

Colo::Colo(){
    
    mesh.setMode(OF_PRIMITIVE_LINES);
    mesh.setUsage(GL_STATIC_DRAW);
    
    auto opt = ofxSpaceColonizationOptions({
        300,                            // max_dist
        5,                             // min_dist
        150,                            // trunk_length
        glm::vec4(0.0f, 0.0f, 0.0f, 1.0f), // rootPosition
        glm::vec3(1.0f, 0.0f, 0.0f),    // rootDirection
        2,                               // branchLength
        false,                           // done growing
        false,                           // cap
        1.0,                             // radius;
        16,                              // resolution;
        1,                               // textureRepeat;
        0.6                              // radiusScale;
    });
    
    tree.setup(opt);
}

void Colo::setOffset(glm::vec3 _offset){
    offset = _offset;
}

void Colo::addVertices(const vector<BrushData> & data, ob::plot::TYPE type, float minRad, float maxRad){

    static const glm::vec2 xAxis(1,0);
        
    for(int i=0; i<data.size(); i++){
        
        const PlotData & p = data[i].plot.at(type);
        const glm::vec2 & pos1 = p.stPos;
        glm::vec2 n1 = glm::normalize(pos1);
        float angle = glm::orientedAngle(xAxis, n1);
        
        if(minRad<angle && angle<=maxRad){
            pos.push_back(glm::vec3(pos1.x, pos1.y, 0) + offset);
        }
    }
}

void Colo::create(){
    tree.setLeavesPositions(pos);
    tree.build();
}

void Colo::update(){

    tree.grow();
    
    mesh.clear();
    vector<shared_ptr<ofxSpaceColonizationBranch>> & bs = tree.getBranches();
    for(int i=0; i<bs.size(); i++){
        
        shared_ptr<ofxSpaceColonizationBranch> & b = bs[i];
        const glm::vec3 & st = b->getStartPos();
        const glm::vec3 & end = b->getEndPos();
        mesh.addVertex(st);
        mesh.addVertex(end);
        mesh.addColor(ofFloatColor(0,0,0.2,0.7));
        mesh.addColor(ofFloatColor(0,0,0.2,0.7));
    }
}

void Colo::draw(){
    
    ofPushMatrix();
    ofTranslate(-offset);
    mesh.draw();
    
//    for(int i=0; i<pos.size(); i++){
//        ofFill();
//        ofSetColor(0,0,0);
//        ofDrawCircle(pos[i].x, pos[i].y, 1);
//    }
    
    ofPopMatrix();
}

void Colo::clear(){
    pos.clear();
    mesh.clear();
}
