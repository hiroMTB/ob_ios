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
    bear = requestBearer(appId, appKey);
    authUrl = requestAuthUrl(bear);
    ofxiOSLaunchBrowser(authUrl);
}

string ofApp::requestBearer(string appId, string appKey){
    ofHttpRequest req;
    req.url = baseurl + "/bearertoken/" + appId + "?key=" + appKey;
    req.name = "Request Bearertoken";
    ofxJSONElement json = request(req);
    return json["bearerToken"].asString();;
}

string ofApp::requestAuthUrl(string bearer){
    ofHttpRequest req;
    req.url = baseurl + "/authorize";
    req.headers["Authorization"] = "Bearer " + bearer;
    req.name = "Request Authorize";
    ofxJSONElement json = request(req);

    return json["url"].asString();
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
    createSessionData(json);    
    cout << json.getRawString() << endl;
}

void ofApp::draw(){
    
    ofBackground(0);
    ofPushMatrix();{
        ofTranslate(20, 20);
        ofSetHexColor(0x00FF00);
        //draw_json(data);
    }ofPopMatrix();
}

/*
 *      parse everything with iterator
 *      alphabetical order because of map container
 */
void ofApp::createSessionData( ofxJSONElement & elem){
    
    
    const Json::Value& sessions = elem["sessions"];
    int size = sessions.size();
    sessionData.clear();
    sessionData.assign(size, unordered_map<string, int>() );
    
    for (Json::ArrayIndex i=0; i<size; ++i){
        
        unordered_map<string, int> & s = sessionData[i];
        
        string timeStart    = sessions[i]["timeStart"].asString();
        string timeEnd      = sessions[i]["timeEnd"].asString();
        s["timeStartYear"]  = ofToInt(timeStart.substr(0,4));
        s["timeStartMonth"] = ofToInt(timeStart.substr(5,7));
        s["timeStartDay"]   = ofToInt(timeStart.substr(8,10));
        s["timeEndYear"]    = ofToInt(timeEnd.substr(0,4));
        s["timeEndMonth"]   = ofToInt(timeEnd.substr(5,7));
        s["timeEndDay"]     = ofToInt(timeEnd.substr(8,10));

        s["duration"]       = sessions[i]["brushingDuration"].asInt();
        s["pressureCount"]  = sessions[i]["pressureCount"].asInt();
        s["]pressureTime"]  = sessions[i]["pressureTime"].asInt();
    }
}

