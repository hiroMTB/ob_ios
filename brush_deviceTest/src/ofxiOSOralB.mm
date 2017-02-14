//
//  ofxiOSOralB.m
//
//  Created by MatobaHiroshi on 2/13/17.
//
//

#import <Foundation/Foundation.h>

#include "ofxOralB.h"
#include "ofxOralBApp.h"
#include "ofMain.h"

/*
        obj c callback
 */
@interface ofxiOSOralBDelegate : NSObject<OBTSDKDelegate>
@end

static ofxiOSOralBDelegate * iOSOralBDelegate;

@implementation ofxiOSOralBDelegate
- (id) init
{
    self = [super init];
    return self;
}

- (void) addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(developerAuthChanged:) name:OBT_NOTIFICATION_DEVELOPER_AUTHENTICATION_STATUS_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAuthChanged:) name:OBT_NOTIFICATION_USER_AUTHENTICATION_STATUS_CHANGED object:nil];
}

- (void) removeNotification
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}

- (void) developerAuthChanged : (NSNotification *) notification
{
    NSLog(@"ofxOralB : developerAuthChanged:");
}

- (void) userAuthChanged : (NSNotification *) notification
{
    NSLog(@"ofxOralB : userAuthChanged:");
}

- (void) nearbyToothbrushesDidChange : (NSArray *)nearbyToothbrushes{
    NSLog(@"nearbyToothbrushesDidChange");
    
    vector<OBTBrush*> br;
    for(int i=0; i<nearbyToothbrushes.count; i++){
        OBTBrush * brush = [nearbyToothbrushes objectAtIndex:i];
        br.push_back( brush );
    };

    ofxOralBApp * obApp = (ofxOralBApp*)( ofGetAppPtr() );
    obApp->nearbyToothbrushesDidChange(br);
}

@end


/*
        C++ impl
*/
ofxOralB::ofxOralB(){
    iOSOralBDelegate = [ [ofxiOSOralBDelegate alloc] init];
    [iOSOralBDelegate addNotification];
}

ofxOralB::~ofxOralB(){
    [iOSOralBDelegate removeNotification];
    [iOSOralBDelegate release];
}

void ofxOralB::setupWithAppID( string _appID, string _appKey){
    
    [OBTSDK setupWithAppID:[NSString stringWithUTF8String:_appID.c_str()]
                    appKey:[NSString stringWithUTF8String:_appKey.c_str()]
     ];
}

int ofxOralB::getAuthorizationStatus(){
    return [OBTSDK authorizationStatus];
}

int ofxOralB::getUserAuthorizationStatus(){
    return [OBTSDK userAuthorizationStatus];
}

bool ofxOralB::getBluetoothAvailableAndEnabled(){
    return [OBTSDK bluetoothAvailableAndEnabled];
}

void ofxOralB::startScanning(){
    [OBTSDK startScanning];
}

void ofxOralB::stopScannng(){
    [OBTSDK stopScanning];
}

void ofxOralB::connectToothbrush(OBTBrush *toothbrush){
    [OBTSDK connectToothbrush: toothbrush];
}

void ofxOralB::disconnectToothbrush(){
    [OBTSDK disconnectToothbrush];
}

bool ofxOralB::isConnected(){
    return [OBTSDK isConnected];
}

bool ofxOralB::isScanning(){
    return [OBTSDK isScanning];
}

OBTBrush * ofxOralB::getConnectedToothbrush(){
    return [OBTSDK connectedToothbrush];
}

NSArray * ofxOralB::getNearbyToothbrushes(){
    return [OBTSDK nearbyToothbrushes];
}

string ofxOralB::getVersion(){
    return [[OBTSDK version] UTF8String];
}

