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
    
    NSLog(@"Let's start!");
    NSLog(@"BT available and enabled? %@", [OBTSDK bluetoothAvailableAndEnabled] ? @"YES" : @"NO");
    // this needs some time:
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSLog(@"BT available and enabled? %@", [OBTSDK bluetoothAvailableAndEnabled] ? @"YES" : @"NO");
    });
    
    
    [OBTSDK addDelegate:self];
    [OBTSDK setupWithAppID:@"YOUR_APP_ID" appKey:@"YOUR_APP_KEY"];
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

@end
