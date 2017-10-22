#include "BrushDataHandler.h"

void BrushDataHandler::getDummyData(string path){

    ofLogNotice("BrushDataHandler") << "Loading Dummy file";
    
    ofxJSONElement result;
    bool parsingSuccessful = result.open(path);
    
    if (parsingSuccessful){
        ofLogNotice("BrushDataHandler") << "parse JSON file : OK";
        //cout << result.getRawString() << endl;
        createData(result);
    }else{
        ofLogError("BrushDataHandler")  << "parse JSON file : ERROR";
    }
    
    ofLogNotice("dummy data") << result.getRawString();
}

void BrushDataHandler::getDataFromServer(){
    ofLogNotice("BrushDataHandler") << "Loading from server";

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
    
    string bear = json["bearerToken"].asString();
    ofLogNotice("BrushDataHandler") << "got bearer " << bear;
    
    return bear;
}

string BrushDataHandler::requestAuthUrl(string bearer){
    ofHttpRequest req;
    req.url = baseurl + "/authorize";
    req.headers["Authorization"] = "Bearer " + bearer;
    req.name = "Request Authorize";
    ofxJSONElement json = request(req);
    string url = json["url"].asString();
    ofLogNotice("BrushDataHandler") << "got authURL " << url;
    return url;
}

void BrushDataHandler::createData( ofxJSONElement & elem){
    
    const Json::Value& sessions = elem["sessions"];
    int size = sessions.size();
    data.clear();
    data.assign(size, BrushData());
    
    for (Json::ArrayIndex i=0; i<size; ++i){
        
        BrushData & b = data[i];
        
        // ISO 8601 extended format
        // "timeEnd" : "2017-10-13T17:38:40.000+02:00"
        
        // Get std::tm

        if(1){
            string start_s   = sessions[i]["timeStart"].asString().substr(0, 19);
            string end_s  = sessions[i]["timeEnd"].asString().substr(0, 19);
            strptime(start_s.c_str(), "%Y-%m-%dT%H:%M:%S", &b.start);
            strptime(end_s.c_str(), "%Y-%m-%dT%H:%M:%S", &b.end);
        }else{
            std::istringstream st (sessions[i]["timeStart"].asString().substr(0, 19));
            std::istringstream end(sessions[i]["timeEnd"].asString().substr(0, 19));
            st  >> std::get_time(&b.start, "%Y-%m-%dT%H:%M:%S");
            end >> std::get_time(&b.end, "%Y-%m-%dT%H:%M:%S");
        }
        std::mktime(&b.start);
        std::mktime(&b.end);

        b.duration      = sessions[i]["brushingDuration"].asInt();
        b.pressureCount = sessions[i]["pressureCount"].asInt();
        b.pressureTime  = sessions[i]["pressureTime"].asInt();
    }
    
    ofLogNotice("BrushDataHandler") << "created " << data.size() << " sesion data";
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
    cout << json.getRawString() << endl;

    createData(json);
}


local_date_time BrushDataHandler::get_ldt(string s){
    local_date_time ldt(not_a_date_time);
    stringstream ss(s);

    try
    {
        boost::local_time::local_time_input_facet* ifc= new boost::local_time::local_time_input_facet("%Y-%m-%dT%H:%M:%S%F%Q");
        ifc->set_iso_extended_format();
        ss.imbue(std::locale(ss.getloc(), ifc));
        ss >> ldt;
    }
    catch( std::exception const& e )
    {
        cout << "ERROR:" << e.what() <<std::endl;
    }
 
    return ldt;
}
