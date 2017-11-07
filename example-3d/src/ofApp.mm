#include "ofApp.h"


//--------------------------------------------------------------
void ofApp::setup(){
    
    // gui envelope
    auto opt = ofxSpaceColonizationOptions({
        200,                            // max_dist
        10,                             // min_dist
        150,                            // trunk_length
        glm::vec4(0.0f, 0.0f, 0.0f, 1.0f), // rootPosition
        glm::vec3(0.0f, 1.0f, 10.0f),    // rootDirection
        2,                               // branchLength
        false,                           // done growing
        false,                           // cap
        1.0,                             // radius;
        16,                              // resolution;
        1,                               // textureRepeat;
        0.6                              // radiusScale;
    });
    
    tree.setup(opt);
    setPointsAndBuild();
    vboLines.setMode(OF_PRIMITIVE_LINES);
    vboPoints.setMode(OF_PRIMITIVE_POINTS);
}

void ofApp::setPointsAndBuild(){
    int n = 10000;
    float r = 600;
    
    for(int i=0; i<n; i++){
        glm::vec3 p(r,0,0);
        float theta = ofDegToRad(ofRandom(-180, 180));
        float alpha = ofDegToRad(ofRandom(0, 90));
        float f = ofGetFrameNum();
        theta += ofDegToRad(ofSignedNoise(i*0.01) * 30.0f);
        alpha += ofDegToRad(ofSignedNoise(-i*0.005) * 30.0f);
        
        p = glm::rotate(p, alpha, glm::vec3(0,0,1));
        p = glm::rotate(p, theta, glm::vec3(0,1,0));
        
        p += glm::vec3(600,0,0);
        
        points.push_back(p);
        
        cout << i << " : " << p << endl;
    }
    
    tree.setLeavesPositions(points);
    tree.build();
}

//--------------------------------------------------------------
void ofApp::update(){
    ofSetBackgroundColor(ofColor(0));
    
    tree.grow();
    
    vboLines.clear();
    vector<shared_ptr<ofxSpaceColonizationBranch>> & bs = tree.getBranches();
    for(int i=0; i<bs.size(); i++){
        
        shared_ptr<ofxSpaceColonizationBranch> & b = bs[i];
        
        const glm::vec3 & st = b->getStartPos();
        const glm::vec3 & end = b->getEndPos();
        
        vboLines.addVertex(st);
        vboLines.addVertex(end);
        vboLines.addColor(ofFloatColor(1,1,1,1));
        vboLines.addColor(ofFloatColor(1,1,1,1));
    }
    
    vboPoints.clear();
    auto leaves = tree.getLeaves();
    for (auto l:leaves) {
        glm::vec3 pos = l.getPosition();
        vboPoints.addVertex(pos);
        vboPoints.addColor(ofFloatColor(1,1,1,1));
    }
}

//--------------------------------------------------------------
void ofApp::draw(){
    
    
    camera.begin();
    
    ofDrawAxis(100);
    vboPoints.draw();
    vboLines.draw();
    
    camera.end();
}

