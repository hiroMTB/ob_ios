//
//  ofxOralB.mm
//
//  Created by hiroshi matoba on 08/02/2017.
//
//

#include "ofxOralB.h"

/*
 
    obj c
 
 */

@implementation ofxOralBDelegate{
    
}

- (id) init
{
    self = [super init];
    [self addNotification];
    return self;
}

- (void)nearbyToothbrushesDidChange:(NSArray *)nearbyToothbrushes
{
    NSLog(@"nearbyToothbrushesDidChange");
    [nearbyToothbrushes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%d: %@", idx, obj);
    }];
    
    /*
     dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:TableViewSectionToothbrushes] withRowAnimation:UITableViewRowAnimationAutomatic];
    });
     */
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

- (void)developerAuthChanged:(NSNotification *)notification
{
    NSLog(@"ofxOralB : developerAuthChanged:");
}

- (void)userAuthChanged:(NSNotification *)notification
{
    NSLog(@"ofxOralB : userAuthChanged:");
}


@end


/*

    c++

*/
ofxOralB::ofxOralB(){
    oralB = [ [ofxOralBDelegate alloc] init];
    [oralB addNotification];
}

ofxOralB::~ofxOralB(){
    [oralB removeNotification];
    [oralB release];
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

