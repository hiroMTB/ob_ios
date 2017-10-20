#pragma once

#include "ofMain.h"
#include "ofxJSON.h"
#include "ofxiOSAlerts.h"
#include "boost/date_time.hpp"

using namespace boost::date_time;
using namespace boost::gregorian;
using namespace boost::local_time;
using namespace boost::posix_time;

class BrushSession{
    
public:
    BrushSession(){};
    int brushingDuration;
    int pressureCount;
    int pressureTime;
    int duration;

    ptime timeEnd;
    ptime timeStart;
};

class BrushDataHandler : public ofxiOSAlertsListener{

public:
    BrushDataHandler(){};
    void getDataFromServer();
    void getDummyData(string path);
    void createSessionData(ofxJSONElement & elem);
    void launchedWithURL(string url);
    ofxJSONElement request(ofHttpRequest & req);

    string requestBearer(string appId, string appKey);
    string requestAuthUrl(string bearer);

    string baseurl = "https://api.developer.oralb.com/v1";
    string appId = "fac078cd-1cf0-4e04-82ab-385a98359d09";
    string appKey = "6bb594ec-2860-427e-8e34-891fdb33995d";
    string bear = "n.a";
    string authUrl = "n.a";
    string userToken = "n.a";
    vector<BrushSession> sessionData;
    
};
