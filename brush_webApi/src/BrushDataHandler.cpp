#include "BrushDataHandler.h"

void BrushDataHandler::getDummyData(string path){

    ofLogNotice("BrushDataHandler") << "Loading Dummy file";
    
    ofxJSONElement result;
    bool parsingSuccessful = result.open(path);
    
    if (parsingSuccessful){
        ofLogNotice("BrushDataHandler") << "parse JSON file : OK";
        cout << result.getRawString() << endl;
        createSessionData(result);
    }else{
        ofLogError("BrushDataHandler")  << "parse JSON file : ERROR";
    }
}

void BrushDataHandler::getDataFromServer(){
    ofxiOSAlerts.addListener(this);
    bear = requestBearer(appId, appKey);
    authUrl = requestAuthUrl(bear);
    ofLaunchBrowser(authUrl);
}

ofxJSONElement BrushDataHandler::request(ofHttpRequest & req){
    ofURLFileLoader loader;
    ofHttpResponse response;
    ofxJSONElement json;
    
    response = loader.handleRequest(req);
    if(response.status != 200) {
        ofLogError() << response.status << " : " << response.error;
        return json;
    }
    
    ofBuffer buf = response.data;
    string raw = ofToString(buf);
    bool ok = json.parse(raw);
    return json;
}

string BrushDataHandler::requestBearer(string appId, string appKey){
    ofHttpRequest req;
    req.url = baseurl + "/bearertoken/" + appId + "?key=" + appKey;
    req.name = "Request Bearertoken";
    ofxJSONElement json = request(req);
    return json["bearerToken"].asString();;
}

string BrushDataHandler::requestAuthUrl(string bearer){
    ofHttpRequest req;
    req.url = baseurl + "/authorize";
    req.headers["Authorization"] = "Bearer " + bearer;
    req.name = "Request Authorize";
    ofxJSONElement json = request(req);
    
    return json["url"].asString();
}

void BrushDataHandler::createSessionData( ofxJSONElement & elem){
    
    const Json::Value& sessions = elem["sessions"];
    int size = sessions.size();
    sessionData.clear();
    sessionData.assign(size, BrushSession());
    
    for (Json::ArrayIndex i=0; i<size; ++i){
        
        BrushSession & b = sessionData[i];
        
        // "timeEnd" : "2017-10-13T17:38:40.000+02:00",
        std::istringstream st (sessions[i]["timeStart"].asString().substr(0, 19));
        std::istringstream end(sessions[i]["timeEnd"].asString().substr(0, 19));
        
        st  >> std::get_time(&b.timeStart, "%Y-%m-%dT%H:%M:%S");
        end >> std::get_time(&b.timeEnd, "%Y-%m-%dT%H:%M:%S");
        b.duration      = sessions[i]["brushingDuration"].asInt();
        b.pressureCount = sessions[i]["pressureCount"].asInt();
        b.pressureTime  = sessions[i]["pressureTime"].asInt();

        if(ofGetLogLevel() == OF_LOG_VERBOSE){
            if (st.fail()) {
                ofLogError("createSessionData") << "Date format Parse failed\n";
            } else {
                ofLogNotice("createSessionData") << ofToString(i,2) << " : " << std::put_time(&b.timeStart,"%c");
            }
        }
    }
}

void BrushDataHandler::launchedWithURL(string url){
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
