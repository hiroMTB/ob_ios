#include "ofApp.h"
#include "obGeoDrawer.hpp"
#include "obStats.hpp"
#include "obUtil.hpp"
#import <OBTSDK/OBTBrush.h>

//
//  if n<0 -1
//  if n=0  0
//  if n>0  1
//
template<typename T>
inline int signval(T n){
    return (n > 0) - (n < 0);
}

void ofApp::setup(){
    
    string appID = "120307cc-05a3-4f07-9e02-2cd40c966e6b";
    string appKey = "387d8361-0345-423d-ac0c-752f57dacd41";
    
    oralb.setupWithAppID( appID, appKey);
    ofSetFrameRate(target_fps);
    ofSetVerticalSync(true);
    //ofSetWindowShape(1920, 1080);
    ofSetWindowPosition(0, 0);
    ofEnableAlphaBlending();
    ofDisableAntiAliasing();
    ofDisableSmoothing();
    
    ofSetOrientation( OF_ORIENTATION_DEFAULT );
    
    bStart = false;
    
    bLog = true;
    audioIn_raw = NULL;
    
    // sound
    int bufferSize = 1920;
    int nCh = 1;
    int sampleRate = 48000;
    currentSamplePos = 0;
    prevSamplePos = 0;
    
    bool audioOk = sound_stream.setup(this, 0, nCh, sampleRate, bufferSize, 4);
    if( !audioOk ){
        ofLogError("soundStream", "cant setup sound_stream");
    }else{
        ofLogNotice("soundStream", "soundStream ok");
    }
    
    // visual
    int w = ofGetWindowWidth();
    int h = ofGetWindowHeight();
    bHandy = w<h;
    
    float longside = bHandy ? h:w;
    float shortside = bHandy ? w:h;
    canvas.set(0, 0, longside, shortside);
    
    track_len = longside * 0.9f;
    track_offset = longside * 0.05;
    start_point.x = track_offset;
    start_point.y = shortside/2;
    indicator.set(0, 0);
    
    bNeedSaveImg = false;
    ofSetLogLevel(OF_LOG_VERBOSE);
    
#ifdef USE_GRABBER
    // video
    grbW = 360;
    grbH = 240;
    grabber.listDevices();
    grabber.setDeviceID(1);
    grabber.setUseTexture(false);
    grabber.setPixelFormat( OF_PIXELS_RGB );
    grabber.setDesiredFrameRate( target_fps );
    grabber.setPixelFormat(OF_PIXELS_MONO);
    grabber.setup( grbW, grbH );
    
    colorImg.allocate( grbW, grbH );
    grayImg.allocate( grbW, grbH );
#endif
    
}

void ofApp::audioIn(float * input, int bufferSize, int nCh){
    if( bStart ){
        audioIn_raw = input;
        currentSamplePos += bufferSize;
    }else{
        audioIn_raw = NULL;
    }
}

void ofApp::clearAudioData(){
    audioIn_data.clear();
}

void ofApp::audioPreProcess(){
    
    if( audioIn_raw==NULL ) return;
    
    // copy
    {
        int bufferSize = 2048;
        int nCh = sound_stream.getNumInputChannels();
        audioIn_data.clear();
        audioIn_data.insert( audioIn_data.begin(), audioIn_raw, audioIn_raw+bufferSize*nCh );
    }
    
    // LOG scale
    if(bLog){
        float strength = 3;
        float base = log10(1+strength);
        
        for_each(audioIn_data.begin(), audioIn_data.end(), [&](float &val){
            float sign = signval<float>(val);
            float log = log10(1+abs(val)*strength) / base;
            val = log * sign;
        });
    }
    
    // lowpass
    if(1){
        for(int i=2; i<audioIn_data.size()-2; i++){
            float v1 = audioIn_data[i-2] * 0.1;
            float v2 = audioIn_data[i-1] * 0.3;
            float v3 = audioIn_data[i-0] * 0.5;
            float v4 = audioIn_data[i+1] * 0.3;
            float v5 = audioIn_data[i+2] * 0.1;
            audioIn_data[i] = (v1+v2+v3+v4+v5)/1.3f;
        }
    }
    
    // stats
    if( ofGetFrameNum() % (target_fps/20) == 0){
        //ob::clear();
        ob::calc(audioIn_data);
    }else{
        ob::dim();
    }
}

void ofApp::videoPreProcess(){

#ifdef USE_GRABBER
    grabber.update();
    
    if( grabber.isFrameNew() ){
        
        if (grabber.getPixels().getData()!=NULL) {
            
            colorImg.setFromPixels( grabber.getPixels().getData(), grbW, grbH  );
            grayImg = colorImg;
            grayImg.threshold(70);
            
            unsigned char * data = grayImg.getPixels().getData();
            size_t step = sizeof(unsigned char) * grbW;
            cv::Mat mat( grbH, grbW, CV_8UC1, data, step );
            vector<cv::KeyPoint> keys;
            
            auto detector = cv::ORB(500, 1.2f, 16, 0, 0, 4);
            //auto detector = cv::BRISK(10, 1, 1.f);
            //auto detector = cv::MSER( 5, 60, 14400);
            //auto detector = cv::FastFeatureDetector( 30, true, cv::FastFeatureDetector::TYPE_9_16 );
            detector.detect(mat, keys);
            
            feat.clear();
            for( int i=0; i<keys.size(); i++ ){
                cv::Point2f & p = keys[i].pt;
                feat.push_back( ofVec2f(p.x, p.y) );
            }
            
            feat.push_back(ofVec2f(0,0));
            feat.push_back(ofVec2f(0,grbH));
            feat.push_back(ofVec2f(grbW,0));
            feat.push_back(ofVec2f(grbW,grbH));
            
        }
    }
#endif
    
}

void ofApp::update(){
    
    
    audioPreProcess();
    //videoPreProcess();
    
    if( !bStart ) return;
    
    float sampleRate = sound_stream.getSampleRate();
    int totalSampleNum = total_time_ms/1000 * sampleRate;
    indicator.x = (float)currentSamplePos/totalSampleNum * track_len;
    
    if (indicator.x >= track_len) {
        cout << "tracking finished : " << ofGetElapsedTimef() << endl;
        //bStart = false;
    }
    
    prevSamplePos = currentSamplePos;
}

void ofApp::draw(){
    
    ofSetLineWidth(1);
    //glPointSize(1);
    ofBackground(255);

    ofPushMatrix();{
        
        if(bHandy){
            ofRotateZ(90.0);
            ofTranslate(0, -ofGetWindowWidth());
        }
        
        ofPushMatrix();{
            ofTranslate(start_point);
            draw_bg();
            if(bStart) draw_wave();
            if(bStart) draw_audioStats();
        }ofPopMatrix();
        
        draw_info();
    }ofPopMatrix();
    
    draw_vid();

}

void ofApp::draw_bg(){
    
    ofSetColor(0, 0, 0);
    float yy = canvas.height/2*0.8;
    ofDrawLine(indicator.x, +yy+10, indicator.x, +yy);
    ofDrawLine(indicator.x, -yy-10, indicator.x, -yy);
    ofDrawLine(0, +yy+10, 0, +yy);
    ofDrawLine(0, -yy-10, 0, -yy);
    
    ofDrawLine(          0,    -5,         0,      +5);
    ofDrawLine(  track_len,    -5, track_len,      +5);
    
    ofSetRectMode(OF_RECTMODE_CORNER);
    ofSetColor(255,255,0,255);
    ofFill();
    ofDrawRectangle(0, -yy, indicator.x, yy*2);
    
    // text sec
    float sampleRate = sound_stream.getSampleRate();
    ofSetColor(0);
    ofDrawBitmapString(ofToString(currentSamplePos/sampleRate), indicator.x, yy+40);
    
}

void ofApp::draw_wave(){
    
    if(audioIn_data.size()!=0){
        
        ob::DrawerSettings & s = ob::dset;
        s.app = this;
        s.indicator = indicator;
        s.data = &audioIn_data;
        s.track_len = track_len;
        s.buffer_size = 2048;
        s.xrate = track_len/s.buffer_size;
        s.global_amp = canvas.height/2 * 0.8;
        
        int start = 0;
        const int end = s.buffer_size;
        bool loop = true;
        
        while( loop ){
            
            float n1 = ofNoise( ofGetDay(), ofGetElapsedTimef(), start );
            int type_max = 7;
            int type = round(n1 * type_max);
            
            float n2 = ofNoise( ofGetHours() , ofGetFrameNum()*2.0, start );
            n2 = pow(n2, 8) * ofRandom(1.0f,10.0f);
            
            int num_min = s.buffer_size * 0.01;
            int num_max = s.buffer_size * 0.05;
            int num = num_min + n2*num_max;
            
            if(type == 3) num*=0.25;
            
            if((start+num)>=end){
                num =  end-start-1;
                loop = false;
                if(num<=2) break;
            }
            
            glPointSize( 1 );
            
            switch (type) {
                case 0: ob::draw_line_wave(start, num); break;
                case 1: ob::draw_dot_wave(start, num); break;
                case 2: ob::draw_prep_line(start, num); break;
                case 3: ob::draw_circle(start, num); break;
                case 4: ob::draw_rect(start, num); break;
                case 5: ob::draw_log_wave(start, num); break;
                case 6: ob::draw_arc(start, num, 0.5); break;
                case 7: ob::draw_prep_line_inv(start, num, 0.33f); break;
                    
                default: break;
            }
            
            start += num;
        }
    }
}

void ofApp::draw_audioStats(){
    
    if(bStart && ob::audioStats.min!=numeric_limits<float>::max()){
        const int bufferSize = 2048;
        const float xrate = track_len/bufferSize;
        const float amp = ob::dset.global_amp;
        
        {
            // max
            float x = ob::audioStats.index_max * xrate;
            float y = ob::audioStats.max * amp;
            ofFill();
            ofSetColor(0, 0, 200);
            ofDrawLine(track_len, y, track_len+10, y);
        }
        
        {
            // min
            float x = ob::audioStats.index_min * xrate;
            float y = ob::audioStats.min * amp;
            ofFill();
            ofSetColor(0, 0, 200);
            ofDrawLine(track_len, y, track_len+10, y);
        }
        
    }
}

void ofApp::draw_vid(){

#ifdef USE_GRABBER
    ofPushMatrix();{
        // ofScale( canvas.height/grbW, canvas.width/grbH );
        ofScale( canvas.height/grbH, canvas.width/grbH );
        //ofScale( canvas.height/grbW, canvas.width/grbW );

        ofSetColor(255,10);
        grayImg.draw(0, 0);
        
        vector<ofVec2f> lines;
        int size = feat.size();
        for( int i=0; i<size-1; i++){
            for( int j=i+1; j<size; j++){
                //int id1 = ofRandom(0, size);
                //int id2 = ofRandom(0, size);
                int id1 = i;
                int id2 = j;
                const ofVec2f & v1 = feat[id1];
                const ofVec2f & v2 = feat[id2];
                float dist = v1.distance(v2);
                float max = 10;
                float noise = ofNoise(i*j+ofRandomf());
                if( noise>0.8 ) max = 1000.0f;

                if( 1<dist && dist<max ){
                    lines.push_back(v1);
                    lines.push_back(v2);
                }
            }
        }

        ofSetLineWidth(1);
        ofSetColor(40, 55);
        ob::drawLines(lines);

        glPointSize(2);
        ofSetColor(55,155);
        ob::drawDots(feat);

    }
    ofPopMatrix();
#endif

}

void ofApp::draw_info(){
    int y = 10;
    int x = 10;
    int os = 150;
    ofSetColor(0);
    ofDrawBitmapString("fps        " + ofToString(ofGetFrameRate()), x, y);
    ofDrawBitmapString("nChannels  " + ofToString(sound_stream.getNumInputChannels() ), x+=os, y);
    //ofDrawBitmapString("bufferSize " + ofToString(2048), x+=os, y);
    ofDrawBitmapString("sampleRate " + ofToString(sound_stream.getSampleRate()), x+=os, y);
    ofDrawBitmapString("track len  " + ofToString((int)track_len), x+=os, y);

    y = 25;
    x = 10;
    os = 150;
    ofDrawBitmapString("SDK        " + oralb.getVersion(), x, y);
    ofDrawBitmapString("Bluetooth  " + ofToString((int)oralb.getBluetoothAvailableAndEnabled()), x+=os, y);
    ofDrawBitmapString("DevAuth    " + ofToString((int)oralb.getAuthorizationStatus()), x+=os, y);
    ofDrawBitmapString("UserAuth   " + ofToString((int)oralb.getUserAuthorizationStatus()), x+=os, y);
    ofDrawBitmapString("Scanning   " + ofToString((int)oralb.isScanning()), x+=os, y);
    ofDrawBitmapString("Connected  " + ofToString((int)oralb.isConnected()), x+=os, y);

    if(oralb.isConnected()){
        y = 40;
        x = 10;
        os = 150;
        OBTBrush * b = oralb.getConnectedToothbrush();
        ofDrawBitmapString("BRUSH      " + string([[b handleType] UTF8String]), x, y);
        ofDrawBitmapString("State      " + ofToString([b deviceState]), x+=os*2, y);
        ofDrawBitmapString("Mode       " + ofToString([b brushMode]), x+=os, y);
        ofDrawBitmapString("RSSI       " + ofToString([b RSSI]), x+=os, y);
        ofDrawBitmapString("Batery     " + ofToString([b batteryLevel]), x+=os, y);
    }
}

void ofApp::exit(){}
void ofApp::touchDown(ofTouchEventArgs & touch){}
void ofApp::touchMoved(ofTouchEventArgs & touch){}
void ofApp::touchUp(ofTouchEventArgs & touch){}
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){
    //ob::util::saveImage();
    
    ofPixels pixRgba;
    ofGetGLRenderer()->saveFullViewport( pixRgba );

    // convert RGBA to RGB
    ofPixels pixRgb;
    pixRgb.allocate(pixRgba.getWidth(), pixRgba.getHeight(), 3);
    pixRgb.setChannel(0, pixRgba.getChannel(0));
    pixRgb.setChannel(1, pixRgba.getChannel(1));
    pixRgb.setChannel(2, pixRgba.getChannel(2));
    ofImage img(pixRgb);
    
    social.share("Post from OralB BrushApp", img);
}

void ofApp::touchCancelled(ofTouchEventArgs & touch){
    ofLogVerbose("ofApp", "%s", __FUNCTION__);}

void ofApp::lostFocus(){
    ofLogVerbose("ofApp", "%s", __FUNCTION__);}

void ofApp::gotFocus(){
    ofLogVerbose("ofApp", "%s", __FUNCTION__);}

void ofApp::gotMemoryWarning(){
    ofLogVerbose("ofApp", "%s", __FUNCTION__);}

void ofApp::deviceOrientationChanged(int newOrientation){
    ofLogVerbose("ofApp", "%s", __FUNCTION__);}

void ofApp::developerAuthChanged(){
    bool bDevAuth = oralb.getAuthorizationStatus() == 1;
    ofLogVerbose("ofApp", "%s : dev Auth changed to %s", __FUNCTION__, (bDevAuth? "ok" : "error"));
    
    if( bDevAuth ){
        oralb.addDelegate();
        oralb.startScanning();
        cout << "start scanning..." << endl;
    }
}

void ofApp::userAuthChanged(){
    ofLogVerbose("ofApp", "%s", __FUNCTION__);
}

void ofApp::nearbyToothbrushesDidChange( vector<OBTBrush*> bs ){
    ofLogVerbose("ofApp", "%s : Found %lu brushes", __FUNCTION__, bs.size());
    if(!oralb.isConnected()){
        if(bs.size()!=0){
            oralb.connectToothbrush(bs[0]);
            //oralb.stopScanning();
            
            OBTBrush * b = oralb.getConnectedToothbrush();
            ofLogVerbose("ofApp", "%s NEW Brush connected", __FUNCTION__);
            ofLogVerbose("ofApp", "name            : %s", [[b name] UTF8String]);
            ofLogVerbose("ofApp", "handleType      : %s", [[b handleType] UTF8String]);
            ofLogVerbose("ofApp", "localHandleID   : %s", [[b localHandleID] UTF8String]);
            ofLogVerbose("ofApp", "protocolVersion : %i", [b protocolVersion]);
            ofLogVerbose("ofApp", "softwareVersion : %i", [b softwareVersion]);            
        }
    }
}

void ofApp::toothbrushDidConnect(OBTBrush *toothbrush){
    ofLogVerbose("ofApp", "%s", __FUNCTION__);
}

void ofApp::toothbrushDidDisconnect(OBTBrush * toothbrush){
    ofLogVerbose("ofApp", "%s", __FUNCTION__);
    bStart = false;
}

void ofApp::toothbrushDidFailWithError(string error){
    ofLogVerbose("ofApp", "%s", __FUNCTION__);
}

void ofApp::toothbrushDidLoadSession(OBTBrush * toothbrush, OBTBrushSession * brushSession, float progress){
    ofLogVerbose("ofApp", "%s", __FUNCTION__);
}

void ofApp::toothbrushDidUpdateRSSI(OBTBrush * toothbrush, float rssi){
    ofLogVerbose("ofApp", "%s : %f", __FUNCTION__, rssi);
}

void ofApp::toothbrushDidUpdateDeviceState(OBTBrush * toothbrush, OBTDeviceState deviceState){
    ofLogVerbose("ofApp", "%s : %i", __FUNCTION__, (int)deviceState);

    if(deviceState == OBTDeviceStateBrushing){
        bStart = true;
        cout << "ONNNNNNNNNNN" << endl;

    }else{
        bStart = false;
        //clearAudioData();
        cout << "OFFFFFFFFFFf" << endl;
    }
}

void ofApp::toothbrushDidUpdateBatteryLevel(OBTBrush * toothbrush, float batteryLevel){
    ofLogVerbose("ofApp", "%s ; %f", __FUNCTION__, batteryLevel);
}

void ofApp::toothbrushDidUpdateBrushMode(OBTBrush * toothbrush, OBTBrushMode brushMode){
    ofLogVerbose("ofApp", "%s : %i", __FUNCTION__, (int)brushMode);
}

void ofApp::toothbrushDidUpdateBrushingDuration(OBTBrush * toothbrush, NSTimeInterval brushingDuration){
    ofLogVerbose("ofApp", "%s : %f", __FUNCTION__, (float)brushingDuration);
}

void ofApp::toothbrushDidUpdateSector(OBTBrush * toothbrush, int sector){
    ofLogVerbose("ofApp", "%s : %i", __FUNCTION__, sector);
}

void ofApp::toothbrushDidUpdateOverpressure(OBTBrush * toothbrush, bool overpressure){
    ofLogVerbose("ofApp", "%s : %i", __FUNCTION__, overpressure);
}
