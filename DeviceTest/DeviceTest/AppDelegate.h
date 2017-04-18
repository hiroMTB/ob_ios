//
//  AppDelegate.h
//  DeviceTest
//
//  Created by hiroshi matoba on 25/02/2017.
//  Copyright © 2017 hiroshi matoba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "oralbReceiver.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property oralbReceiver * orec;

@end

