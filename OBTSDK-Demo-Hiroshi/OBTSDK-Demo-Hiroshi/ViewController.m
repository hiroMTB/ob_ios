//
//  ViewController.m
//  OBTSDK-Demo-Hiroshi
//
//  Created by Christian Weinberger on 19/04/17.
//  Copyright © 2017 iconmobile GmbH. All rights reserved.
//

#import "ViewController.h"
#import <OBTSDK/OBTSDK.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "Reachability.h"

@interface ViewController () <OBTSDKDelegate, CBCentralManagerDelegate>{
    CBCentralManager * bluetoothManager;
    Reachability * reach;
}
@end

@implementation ViewController


/*
    1. check internet is reachable -> wait until reachable
    2. check BLE is available and enabled -> wait until enabled
    3. ask developer auth -> wait
    (4. ask user auth -> redirect)
    5. scanStart
    6. connect
 
*/
- (ViewController*) init {
    NSLog(@"init ViewController");
    return self;
}

// test without xib file
//-(void) loadView{
//    CGRect frame = [[UIScreen mainScreen] applicationFrame];
//    UIView *contentView = [[UIView alloc] initWithFrame:frame];
//    contentView.backgroundColor = [UIColor greenColor];
//    self.view = contentView;
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 40, 100, 40)];
//    [label setText:@"Label created in ScrollerController.loadView"];
//    [self.view addSubview:label];
//}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    [self addReachability];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(developerAuthChanged:) name:OBTDeveloperAuthenticationStatusChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAuthChanged:) name:OBTUserAuthenticationStatusChangedNotification object:nil];
}


- (void) addReachability {
    self->reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    [self->reach startNotifier];
    [self detectInternet : reach];
}

- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self detectInternet:curReach];
}

-(void) detectInternet : (Reachability *) curReach
{
    switch([curReach currentReachabilityStatus]){
        case ReachableViaWiFi:
        case ReachableViaWWAN:
            NSLog(@"Internet is reachable");
            [self detectBluetooth];

            break;
        case NotReachable:
            NSLog(@"Internet is NOT reachable");
            break;
    }
}


 - (void)detectBluetooth
{
    if(!self->bluetoothManager)
    {
        // Put on main queue so we can call UIAlertView from delegate callbacks.
        self->bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()] ;
    }
    [self centralManagerDidUpdateState:self->bluetoothManager]; // Show initial state
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    
    switch(bluetoothManager.state)
    {
        case CBCentralManagerStateResetting:
            NSLog(@"The connection with the system service was momentarily lost, update imminent.");
            break;
            
        case CBCentralManagerStateUnsupported:
            NSLog(@"The platform doesn't support Bluetooth Low Energy.");
            exit(0);
            break;
            
        case CBCentralManagerStateUnauthorized:
            NSLog(@"The app is not authorized to use Bluetooth Low Energy.");
            break;
        case CBCentralManagerStatePoweredOff:
            NSLog(@"Bluetooth is currently powered off, powered ON first.");
            break;
            
        case CBCentralManagerStatePoweredOn:
            {
                NSLog(@"Bluetooth is currently powered ON.");
                NSString * myId  = @"120307cc-05a3-4f07-9e02-2cd40c966e6b";
                NSString * myKey = @"387d8361-0345-423d-ac0c-752f57dacd41";
                [OBTSDK setupWithAppID:myId appKey:myKey];
            }
            break;
            
        default:
            NSLog(@"State unknown, update imminent.");
            break;
    }
}

- (void) developerAuthChanged : (NSNotification *) notification
{
    NSLog(@"dev authorization changed to %@", [OBTSDK authorizationStatus] ? @"OK" : @"Error");
    if([OBTSDK authorizationStatus] == 1){
        [OBTSDK addDelegate:self];
        [OBTSDK startScanning];
        NSLog(@"Start Scanning");
    }
}

- (void) userAuthChanged : (NSNotification *) notification
{
    NSLog(@"user authorization Changed to %@", [OBTSDK userAuthorizationStatus]==OBTUserAuthorizationStatusAuthorized ? @"OK" : @"Error");
}


- (void) askUserAuth {
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
