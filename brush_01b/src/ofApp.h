#pragma once

#define USE_GRABBER

#include "ofxiOS.h"
#include "ofxOpenCv.h"

class ofApp : public ofxiOSApp{
    
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

    void audioIn(float * input, int bufferSize, int nChannels) override;
    
    void audioPreProcess();
    void videoPreProcess();
    void draw_wave();
    void draw_bg();
    void draw_info();
    void draw_audioStats();
    void draw_vid();
    
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
    
    ofVec2f         start_point; // absolute pix pos
    ofVec2f         indicator;   // relative pix pos(dist from start_point)
    
    // sound
    int             currentSamplePos;
    int             prevSamplePos;
    float *         audioIn_raw;
    vector<float>   audioIn_data;
    ofSoundStream   sound_stream;
    
#ifdef USE_GRABBER
    // video
    ofVideoGrabber  grabber;
    int             grbW;
    int             grbH;
    
    // cv
    vector<ofVec2f>     feat;
    ofxCvColorImage     colorImg;
    ofxCvGrayscaleImage grayImg;
#endif
    
    bool bNeedSaveImg;

};


