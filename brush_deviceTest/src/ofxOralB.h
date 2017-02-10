//
//  ofxOralB.h
//
//  Created by hiroshi matoba on 08/02/2017.
//
//

#pragma once

#import <OBTSDK/OBTSDK.h>

@interface ofxOralBDelegate : NSObject<OBTSDKDelegate>{
};

//@property UITableView* tableView;

- (id) init;
- (void) nearbyToothbrushesDidChange:(NSArray *)nearbyToothbrushes;
- (void) developerAuthChanged:(NSNotification *)notification;
- (void) userAuthChanged:(NSNotification *)notification;
- (void) addNotification;
- (void) removeNotification;
@end


#include "ofMain.h"

class ofxOralB
{
    
public:
    
    ofxOralB();
    ~ofxOralB();
    
    void setupWithAppID(string appID, string appKey);
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
    
protected:
    ofxOralBDelegate * oralB;

};

class ofxOralBApp{

public:
    ofxOralBApp() {}
    virtual ~ofxOralBApp(){}
    virtual void nearbyToothbrushesDidChange(){}

};
