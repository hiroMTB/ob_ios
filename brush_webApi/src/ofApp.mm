#include "ofApp.h"

void ofApp::setup(){

    // 1.request
    {
        ofURLFileLoader loader;
        ofHttpRequest req;
        ofHttpResponse response;
        ofxJSONElement json;
        
        string url = baseurl + "/bearertoken/" + appId + "?key=" + appKey;
        req.url = url;
        req.name = "Request Bearertoken";
        response = loader.handleRequest(req);
        if(response.status != 200) {
            cout << "ERROR " << response.status << " : " << response.error << endl;
            return;
        }
        
        ofBuffer buf = response.data;
        string raw = ofToString(buf);
        bool ok = json.parse(raw);
        if(ok) bear = json["bearerToken"].asString();
        
        result = json;
    }
    
    
    // 2.request
    {
        ofURLFileLoader loader;
        ofHttpResponse response;
        ofHttpRequest req;
        ofxJSONElement json;
        string url = baseurl + "/authorize";
        req.url = url;
        req.headers["Authorization"] = "Bearer " + bear;
        req.name = "Request Authorize";
        response = loader.handleRequest(req);
        if(response.status != 200) {
            cout << "ERROR " << response.status << " : " << response.error << endl;
            return;
        }
        
        ofBuffer buf = response.data;
        string raw = ofToString(buf);
        bool ok = json.parse(raw);
        
        if(ok){
            authUrl = json["url"].asString();
            //ofLoadURL( authUrl );
            ofxiOSLaunchBrowser(authUrl);
            cout << authUrl << endl;
        }
        
        result = json;
    }
}


void ofApp::draw(){
    
    ofBackground(0);
    ofPushMatrix();{
        ofTranslate(20, 20);
        ofSetHexColor(0x00FF00);
        draw_json(result);
    }ofPopMatrix();
    
}

/*
 *      parse everything with iterator
 *      alphabetical order because of map container
 */
void ofApp::draw_json( ofxJSONElement & elem){
    
    std::stringstream ss;
    
    Json::Value::iterator itrA = elem.begin();
    
    for( ; itrA!=elem.end(); itrA++){
        
        string name = itrA.memberName();
        string data = (*itrA).asString();
        ss << name << " : " << data << "\n";
        
        Json::Value::iterator itrB = (*itrA).begin();
        
        for( ; itrB!=(*itrA).end(); itrB++){
            string name = itrB.memberName();
            string data = (*itrB).asString();
            ss << name << " : " << data << "\n";
        }
        
        ss << "\n\n";
    }
    
    ofDrawBitmapString(ss.str(), 0, 0);
}



