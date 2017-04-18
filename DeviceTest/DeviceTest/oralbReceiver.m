//
//  oralbReceiver.m
//
//  Created by hiroshi matoba on 25/02/2017.
//  Copyright © 2017 hiroshi matoba. All rights reserved.
//

#import "oralbReceiver.h"
#import "ViewController.h"
#import "AppDelegate.h"

@implementation oralbReceiver{
    ViewController * view;
}
@synthesize bluetoothManager;

-(id) init
{
    self = [super init];

    if(self){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(developerAuthChanged:) name:OBTDeveloperAuthenticationStatusChangedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAuthChanged:) name:OBTUserAuthenticationStatusChangedNotification object:nil];
    }
    
    return self;
}


- (void) setup
{
    NSLog(@"HEYYYYY");
    
    NSString * myId  = @"120307cc-05a3-4f07-9e02-2cd40c966e6b";
    NSString * myKey = @"387d8361-0345-423d-ac0c-752f57dacd41";
    [OBTSDK setupWithAppID:myId appKey:myKey];

    NSString * version = [OBTSDK version];
    NSLog(@"OBTSDK version %@", version);
    bool bluetoothOK = [OBTSDK bluetoothAvailableAndEnabled];
    if(bluetoothOK) NSLog(@"bluetooth is avairable");
    else NSLog(@"bluetooth is NOT avairable");
    [self detectBluetooth];
}

- (void) developerAuthChanged : (NSNotification *) notification
{
    if([OBTSDK authorizationStatus] == 1){
        [OBTSDK addDelegate:self];
        //[OBTSDK startScanning];
        NSLog(@"dev authorization OK");
    }
}

- (void) userAuthChanged : (NSNotification *) notification
{
    
}

- (void) nearbyToothbrushesDidChange : (NSArray *)nearbyToothbrushes
{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ViewController* vc = (ViewController*) del.window.rootViewController;
    vc.tableData = [NSArray arrayWithObjects:@"1111", @"222", @"333", @"4444", nil];
    
    NSIndexSet * indexset = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [nearbyToothbrushes count]-1)];
    dispatch_async( dispatch_get_main_queue(), ^{
        [vc.tableView reloadSections:indexset withRowAnimation:UITableViewRowAnimationAutomatic];
    });
    
    for(int i=0; i<nearbyToothbrushes.count; i++){
        OBTBrush * brush = [nearbyToothbrushes objectAtIndex:i];
        NSLog( @"Nearby ToothbrushesDidChange%@", brush.name );
    }
}

//check bluetooth connection
- (void)detectBluetooth
{
    
    if(!self.bluetoothManager)
    {
        // Put on main queue so we can call UIAlertView from delegate callbacks.
        self.bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()] ;
    }
    [self centralManagerDidUpdateState:self.bluetoothManager]; // Show initial state
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
            break;
            
        case CBCentralManagerStateUnauthorized:
            NSLog(@"The app is not authorized to use Bluetooth Low Energy.");
            break;
        case CBCentralManagerStatePoweredOff:
            NSLog(@"Bluetooth is currently powered off , powered ON first.");
            break;
        case CBCentralManagerStatePoweredOn:
            NSLog(@"Bluetooth is currently powered ON.");
            break;
        default:
            NSLog(@"State unknown, update imminent.");
            break;
    }
    
    
    
    
}


@end
