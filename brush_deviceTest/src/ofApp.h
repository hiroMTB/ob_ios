#pragma once

#include "ofxiOS.h"
#include "ofxOpenCv.h"
#include "ofxiPhoneSocial.h"
#include "ofxOralB.h"
#include "ofxOralBApp.h"

#include "CDSPResampler.h"
using namespace r8b;

class ofApp : public ofxiOSApp, public ofxOralBApp{
    
public:
    void setup() override;
    void update() override;
    void draw() override;
    void touchDown(ofTouchEventArgs & touch) override;
    void touchMoved(ofTouchEventArgs & touch) override;
    void touchUp(ofTouchEventArgs & touch) override;
    void touchDoubleTap(ofTouchEventArgs & touch) override;
    void touchCancelled(ofTouchEventArgs & touch) override;
    void lostFocus() override;
    void gotFocus() override;
    void gotMemoryWarning() override;
    void deviceOrientationChanged(int newOrientation) override;
    void exit() override;

    void audioIn( ofSoundBuffer& buffer ) override;
    
    void audioPreProcess();
    void videoPreProcess();
    void draw_wave();
    void draw_bg();
    void draw_info();
    void draw_audioStats();
    void checkStart();
    
    // OralB event
    void developerAuthChanged() override;
    void userAuthChanged() override;
    void nearbyToothbrushesDidChange(vector<OBTBrush*> nearbyToothbrushes) override;
    void toothbrushDidConnect(OBTBrush * toothbrush) override;
    void toothbrushDidDisconnect(OBTBrush * toothbrush) override;
    void toothbrushDidFailWithError(string error) override;
    void toothbrushDidLoadSession(OBTBrush * toothbrush, OBTBrushSession * brushSession, float progress) override;
    void toothbrushDidUpdateRSSI(OBTBrush * toothbrush, float rssi) override;
    void toothbrushDidUpdateDeviceState(OBTBrush * toothbrush, OBTDeviceState deviceState) override;
    void toothbrushDidUpdateBatteryLevel(OBTBrush * toothbrush, float batteryLevel) override;
    void toothbrushDidUpdateBrushMode(OBTBrush * toothbrush, OBTBrushMode brushMode) override;
    void toothbrushDidUpdateBrushingDuration(OBTBrush * toothbrush, NSTimeInterval brushingDuration) override;
    void toothbrushDidUpdateSector(OBTBrush * toothbrush, int sector) override;
    void toothbrushDidUpdateOverpressure(OBTBrush * toothbrush, bool overpressure) override;
    
    // app
    const int       total_time_ms = 3 * 60 * 1000; // 3 mim
    const int       target_fps = 60;
    
    bool            bHandy;
    bool            bStart;
    bool            bLog;
    
    // visual
    ofRectangle     canvas;
    float           track_len;
    float           track_offset;
    float           indicator_speed;
    float           pixPerSample;
    float           pixPerSample_down;
    
    ofVec2f         start_point; // absolute pix pos
    ofVec2f         indicator;   // relative pix pos(dist from start_point)
    
    // sound
    int             totalSampleNum;
    int             currentSamplePos;
    int             prevSamplePos;
    float *         audioIn_raw;
    vector<double>  audioIn_data;
    ofSoundStream   sound_stream;

    int             sampleRate_down = 300;
    vector<float>   rms;
    
    CPtrKeeper<CDSPResampler16*> Resamps;
    ofPolyline storedWave;
    vector<double>  audioIn_data_down;
    ofVboMesh       downWave;
    
    bool bNeedSaveImg;

    ofxiPhoneSocial social;
    ofxOralB oralb;

};


