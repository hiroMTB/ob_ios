//
//  ofxOralBApp.h
//
//  Created by MatobaHiroshi on 2/14/17.
//
//

#pragma once

#import <OBTSDK/OBTSDK.h>

class ofxOralBApp{
    
public:
    
    virtual void developerAuthChanged(){};
    virtual void userAuthChanged(){};
    virtual void nearbyToothbrushesDidChange(vector<OBTBrush*> nearbyToothbrushes){};
    virtual void toothbrushDidConnect(OBTBrush * toothbrush){};
    virtual void toothbrushDidDisconnect(OBTBrush * toothbrush){};
    virtual void toothbrushDidFailWithError(string error){};
    virtual void toothbrushDidLoadSession(OBTBrush * toothbrush, OBTBrushSession * brushSession, float progress){};
    virtual void toothbrushDidUpdateRSSI(OBTBrush * toothbrush, float rssi){};
    virtual void toothbrushDidUpdateDeviceState(OBTBrush * toothbrush, OBTDeviceState deviceState){};
    virtual void toothbrushDidUpdateBatteryLevel(OBTBrush * toothbrush, float batteryLevel){};
    virtual void toothbrushDidUpdateBrushMode(OBTBrush * toothbrush, OBTBrushMode brushMode){};
    virtual void toothbrushDidUpdateBrushingDuration(OBTBrush * toothbrush, NSTimeInterval brushingDuration){};
    virtual void toothbrushDidUpdateSector(OBTBrush * toothbrush, int sector){};
    virtual void toothbrushDidUpdateOverpressure(OBTBrush * toothbrush, bool overpressure){};
    
};
