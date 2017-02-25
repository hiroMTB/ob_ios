//
//  ofxOralB.h
//
//  Created by hiroshi matoba on 08/02/2017.
//
//

#pragma once

#import <OBTSDK/OBTSDK.h>

#include "ofMain.h"

class ofxOralB
{
    
public:
    
    ofxOralB();
    ~ofxOralB();

    void setupWithAppID(string appID, string appKey);
    void presentUserAuthorizationFromViewController();
    void addDelegate();
    int getAuthorizationStatus();
    int getUserAuthorizationStatus();
    bool getBluetoothAvailableAndEnabled();
    void startScanning();
    void stopScannng();
    void connectToothbrush(OBTBrush * toothbrush);
    void disconnectToothbrush();
    bool isConnected();
    bool isScanning();
    OBTBrush * getConnectedToothbrush();
    NSArray * getNearbyToothbrushes();
    string getVersion();
    
};

