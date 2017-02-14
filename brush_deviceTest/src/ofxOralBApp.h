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
    
    virtual void nearbyToothbrushesDidChange(vector<OBTBrush*> tbs){};
    
    
    
};
