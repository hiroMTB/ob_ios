#pragma once

#include "ofxiOS.h"

namespace ob {
    namespace util{
        
        void saveImage() {
            ofxiPhoneAppDelegate * delegate = ofxiPhoneGetAppDelegate();
            ofxiPhoneScreenGrab(delegate);
        }
        
    }
}