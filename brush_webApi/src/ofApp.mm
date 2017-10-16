#include "ofApp.h"

ofxJSONElement ofApp::request(ofHttpRequest & req){
    ofURLFileLoader loader;
    ofHttpResponse response;
    ofxJSONElement json;
    
    response = loader.handleRequest(req);
    if(response.status != 200) {
        cout << "ERROR " << response.status << " : " << response.error << endl;
        return json;
    }
    
    ofBuffer buf = response.data;
    string raw = ofToString(buf);
    bool ok = json.parse(raw);    
    return json;
}

void ofApp::setup(){
    
    cout << "setup : " << endl;
    
    // 1.request bearerToken
    {
        ofHttpRequest req;
        req.url = baseurl + "/bearertoken/" + appId + "?key=" + appKey;
        req.name = "Request Bearertoken";
        ofxJSONElement json = request(req);
        bear = json["bearerToken"].asString();
        ofLogNotice("setup") << "got BearerToken : "  << bear;
        result = json;
    }
    
    // 2.request auth page url -> move to safari
    {
        ofHttpRequest req;
        req.url = baseurl + "/authorize";
        req.headers["Authorization"] = "Bearer " + bear;
        req.name = "Request Authorize";
        ofxJSONElement json = request(req);
        
        authUrl = json["url"].asString();
        ofxiOSLaunchBrowser(authUrl);
        ofLogNotice("setup") << "got auth URL : "  << authUrl;
        result = json;
    }
}

void ofApp::launchedWithURL(string url){
    cout << "launchedWithURL : " << url << endl;
    
    // request session data
    // example https://api.developer.oralb.com/v1/sessions?from=2015-02-20T12:40:45.327-07:00&to=
    
    userToken = url.erase(0, 9); // remove obtest://userToken
    cout << "userToken : " << userToken << endl;
    
    ofHttpRequest req;
    req.url = baseurl + "/sessions?from=2015-02-20T12:40:45.327-07:00";
    req.headers["X-User-Token"] = userToken;
    req.headers["Authorization"] = "Bearer " + bear;
    req.name = "Request Session data";
    ofxJSONElement json = request(req);
    result = json;
    cout << result.getRawString() << endl;
}

void ofApp::draw(){
    
    ofBackground(0);
    ofPushMatrix();{
        ofTranslate(20, 20);
        ofSetHexColor(0x00FF00);
        //draw_json(result);
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

