//
//  oralbReceiver.h
//  DeviceTest
//
//  Created by hiroshi matoba on 25/02/2017.
//  Copyright © 2017 hiroshi matoba. All rights reserved.
//

#ifndef oralbReceiver_h
#define oralbReceiver_h

#import <UIKit/UIKit.h>
#import <OBTSDK/OBTSDK.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface oralbReceiver : NSObject<OBTSDKDelegate, CBCentralManagerDelegate>

- (void) setup;
- (void) nearbyToothbrushesDidChange : (NSArray *)nearbyToothbrushes;
@property CBCentralManager * bluetoothManager;

@end

#endif /* oralbReceiver_h */
