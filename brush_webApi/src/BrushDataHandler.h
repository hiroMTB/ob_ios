#pragma once

#include "ofMain.h"
#include "ofxJSON.h"
#include <unordered_map>

class BrushDataHandler{

public:
    
    void getDataFromServer();
    
    void draw_json( ofxJSONElement & elem);
    void createSessionData(ofxJSONElement & elem);
    
    ofxJSONElement request(ofHttpRequest & req);
    void launchedWithURL(string url);

    
    string requestBearer(string appId, string appKey);
    string requestAuthUrl(string bearer);

    string baseurl = "https://api.developer.oralb.com/v1";
    string appId = "fac078cd-1cf0-4e04-82ab-385a98359d09";
    string appKey = "6bb594ec-2860-427e-8e34-891fdb33995d";
    string bear = "n.a";
    string authUrl = "n.a";
    string userToken = "n.a";
    vector<unordered_map<string, int>> sessionData;
    
};