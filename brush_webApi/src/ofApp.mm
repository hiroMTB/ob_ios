#define USE_DUMMY_DATA

#include "ofApp.h"
#include "Sandbox.h"

using namespace ob::plot;

ofApp::ofApp(){
    
    radiusData = {
        {TYPE::HOUR,  0.2},
        {TYPE::DAY,   0.3},
        {TYPE::WEEK,  0.4},
        {TYPE::MONTH, 0.6},
        {TYPE::YEAR,  0.7}
    };
}

void ofApp::setup(){
 
    ofSetLogLevel(OF_LOG_VERBOSE);
    ofSetCircleResolution(360);
    ofLogNotice("setup") << "width : " << ofGetWidth() << ", height : " << ofGetHeight();

#ifdef USE_DUMMY_DATA
    ofxJSONElement json = handler.getDataFromDummyFile("sessionExample.json");
    BrushData::createData(json, data);
    viz.composePlotData(data, radiusData);
#else
    ofRegisterURLNotification(this);
    handler.getDataFromServer();
#endif

    float minRad, maxRad;
    minRad = -PI;
    maxRad = PI;
    voro.addVertices(data, TYPE::HOUR, minRad, maxRad);
    voro.addVertices(data, TYPE::DAY,  minRad, maxRad);
    voro.addVertices(data, TYPE::WEEK, minRad, maxRad);
    voro.addVertices(data, TYPE::MONTH,minRad, maxRad);
    voro.addVertices(data, TYPE::YEAR, minRad, maxRad);

    voro.vPs.push_back(vPoint(0,0)); // put a vertex at center
    voro.create();

//    minRad = -PI/2;
//    maxRad =  PI;
    np.pos.push_back(glm::vec2(0,0));
    np.addVertices(data, TYPE::HOUR,  minRad, maxRad);
    np.addVertices(data, TYPE::DAY,   minRad, maxRad);
    np.addVertices(data, TYPE::WEEK,  minRad, maxRad);
    np.addVertices(data, TYPE::MONTH, minRad, maxRad);
    np.addVertices(data, TYPE::YEAR,  minRad, maxRad);
    np.create(3, 30, 150);
    
//    minRad = 0;
//    maxRad = PI;
    int n = 12;
    colos.assign(n, Colo());
    for(int i=0; i<n; i++){
        Colo & colo = colos[i];
        float angle = (TWO_PI/n) * i;
        float radius = radiusData[TYPE::HOUR] * ofGetWidth()/2;
        glm::vec3 offset(radius, 0, 0);
        offset = glm::rotate(offset, angle, glm::vec3(0,0,1));
        colos[i].setOffset(offset);
        
        //colo.addVertices(data, TYPE::HOUR, minRad, maxRad);
        //colo.addVertices(data, TYPE::DAY,  minRad, maxRad);
        colo.addVertices(data, TYPE::WEEK, minRad, maxRad);
        colo.addVertices(data, TYPE::MONTH,minRad, maxRad);
        colo.addVertices(data, TYPE::YEAR, minRad, maxRad);
        colo.create();
    }

    guide.create(radiusData);

    bInitialized = true;
}

void ofApp::update(){
    
    if(!bInitialized) return;
    num = ofGetFrameNum()*0.5f;
    num = MIN(data.size(), num);

    for(int j=0; j<1; j++){
        for(int i=0; i<colos.size(); i++){
            Colo & colo = colos[i];
            colo.update();
        }
    }
}

void ofApp::draw(){

    ofBackground(255);
    if(!bInitialized) return;

    float x = ofGetWidth()/2;
    float y = ofGetHeight()/2;
    float rad = ofGetWidth()/2;

    ofPushMatrix();{
        ofTranslate(x, y);
        
        for(int i=0; i<colos.size(); i++){
            Colo & colo = colos[i];
            colo.draw();
        }
        
        ofSetLineWidth(1);
        ofFill();
        ofSetColor(255);
        ofDrawCircle(0, 0, rad*0.18);
        
        voro.draw();
        np.draw();
        
        ofFill();
        viz.draw_hour   (rad * radiusData[TYPE::HOUR], data, num);
        viz.draw_day    (rad * radiusData[TYPE::DAY], data, num);
        viz.draw_week   (rad * radiusData[TYPE::WEEK], data, num);
        viz.draw_month  (rad * radiusData[TYPE::MONTH], data, num);
        viz.draw_year   (rad * radiusData[TYPE::YEAR], data, num);
        
        guide.draw();

    }ofPopMatrix();
}

void ofApp::urlResponse(ofHttpResponse & response){
    string name = response.request.name;
    
    if(response.status==200){
        ofxJSONElement json;
        ofBuffer buf = response.data;
        string raw = ofToString(buf);
        json.parse(raw);
        
        if(name == "session data"){
            BrushData::createData(json, data);
            viz.composePlotData(data, radiusData);
        }
    }
}

void ofApp::exit() {
    ofxiOSAlerts.removeListener(this);
    ofUnregisterURLNotification(this);
}
