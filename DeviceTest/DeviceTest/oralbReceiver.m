//
//  oralbReceiver.m
//
//  Created by hiroshi matoba on 25/02/2017.
//  Copyright © 2017 hiroshi matoba. All rights reserved.
//

#import "oralbReceiver.h"

@implementation oralbReceiver

-(id) init
{
    self = [super init];

    if(self){
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(developerAuthChanged:) name:OBT_NOTIFICATION_DEVELOPER_AUTHENTICATION_STATUS_CHANGED object:nil];
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAuthChanged:) name:OBT_NOTIFICATION_USER_AUTHENTICATION_STATUS_CHANGED object:nil];

    }
    
    return self;
}

- (void) setup
{

    //OBTSDK * sdk = [[OBTSDK alloc] init];

    NSString * myId  = @"120307cc-05a3-4f07-9e02-2cd40c966e6b";
    NSString * myKey = @"387d8361-0345-423d-ac0c-752f57dacd41";
    int st = [OBTSDK authorizationStatus];
    //[OBTSDK setupWithAppID:myId appKey:myKey];
    
}

- (void) developerAuthChanged : (NSNotification *) notification
{
    if([OBTSDK authorizationStatus] == 1){
        [OBTSDK addDelegate:self];
        [OBTSDK startScanning];
    }
}

- (void) userAuthChanged : (NSNotification *) notification
{

}

- (void) nearbyToothbrushesDidChange : (NSArray *)nearbyToothbrushes{
    
    for(int i=0; i<nearbyToothbrushes.count; i++){
        OBTBrush * brush = [nearbyToothbrushes objectAtIndex:i];
        NSLog( @"Nearby ToothbrushesDidChange%@", brush.name );
    }
}

@end
