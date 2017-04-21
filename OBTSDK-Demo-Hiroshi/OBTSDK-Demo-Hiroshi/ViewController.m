//
//  ViewController.m
//  OBTSDK-Demo-Hiroshi
//
//  Created by Christian Weinberger on 19/04/17.
//  Copyright © 2017 iconmobile GmbH. All rights reserved.
//

#import "ViewController.h"
#import <OBTSDK/OBTSDK.h>

@interface ViewController () <OBTSDKDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(developerAuthChanged:) name:OBTDeveloperAuthenticationStatusChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAuthChanged:) name:OBTUserAuthenticationStatusChangedNotification object:nil];
    
    NSLog(@"Let's start!");
    NSLog(@"BT available and enabled? %@", [OBTSDK bluetoothAvailableAndEnabled] ? @"YES" : @"NO");
    // this needs some time:
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSLog(@"BT available and enabled? %@", [OBTSDK bluetoothAvailableAndEnabled] ? @"YES" : @"NO");
    });
    
    // this needs some time as well
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [OBTSDK presentUserAuthorizationFromViewController:self completion:^(BOOL success, NSError *error) {
            if(success) {
                NSLog(@"back from usr auth page : User Auth OK");
            } else {
                NSLog(@"back from user auth page : User Auth faile");
                NSLog(@"Error : %@, %@", error.localizedDescription, error.localizedFailureReason);
            }
        }];
    });
    
    [OBTSDK addDelegate:self];
    NSString * myId  = @"120307cc-05a3-4f07-9e02-2cd40c966e6b";
    NSString * myKey = @"387d8361-0345-423d-ac0c-752f57dacd41";
    [OBTSDK setupWithAppID:myId appKey:myKey];
    [OBTSDK startScanning];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - OBTSDKDelegate

- (void)nearbyToothbrushesDidChange:(NSArray *)nearbyToothbrushes
{
    NSLog(@"nearbyToothbrushesDidChange: %@", nearbyToothbrushes);
    if(nearbyToothbrushes.count >= 1) {
        OBTBrush *brush = nearbyToothbrushes[0];
        [OBTSDK connectToothbrush:brush];
    }
}

- (void)toothbrushDidConnect:(OBTBrush *)toothbrush
{
    NSLog(@"toothbrushDidConnect: %@", toothbrush);
}

- (void)toothbrushDidDisconnect:(OBTBrush *)toothbrush
{
    NSLog(@"toothbrushDidDisconnect: %@", toothbrush);
}

- (void)toothbrush:(OBTBrush *)toothbrush didUpdateDeviceState:(OBTDeviceState)deviceState
{
    NSLog(@"toothbrush:didUpdateDeviceState: %@", NSStringFromOBTDeviceState(deviceState));
}

- (void)toothbrush:(OBTBrush *)toothbrush didUpdateBrushingDuration:(NSTimeInterval)brushingDuration
{
    NSLog(@"toothbrush:didUpdateBrushingDuration: %f s", brushingDuration);
}

- (void)toothbrush:(OBTBrush *)toothbrush didUpdateOverpressure:(BOOL)overpressure
{
    NSLog(@"toothbrush:didUpdateOverpressure: %@", overpressure ? @"overpressure" : @"normal pressure");
}

- (void)toothbrushDidFailWithError:(NSError *)error;
{
    NSLog(@"toothbrushDidFailWithError: %@", error);
}

- (void) developerAuthChanged : (NSNotification *) notification
{
    if([OBTSDK authorizationStatus] == 1){
        [OBTSDK addDelegate:self];
        [OBTSDK startScanning];
        NSLog(@"dev authorization OK");
    }
}

- (void) userAuthChanged : (NSNotification *) notification
{
    NSLog(@"user authorization Changed to %@", [OBTSDK userAuthorizationStatus]==OBTUserAuthorizationStatusAuthorized ? @"OK" : @"Error");
}

@end
