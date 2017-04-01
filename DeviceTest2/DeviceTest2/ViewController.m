//
//  ViewController.m
//  DeviceTest2
//
//  Created by hiroshi matoba on 05/03/2017.
//  Copyright © 2017 hiroshi matoba. All rights reserved.
//

#import "ViewController.h"
#import <OBTSDK/OBTSDK.h>
//#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * myKey = @"bd2f69d5-3896-41ac-b533-3d8275f695fe";
    NSString * myId  = @"759d22f4-53f8-41a7-8811-90928440ce8c";
    
    NSString *version = [OBTSDK version];
    int devAuthState = [OBTSDK authorizationStatus];
    
    NSLog(@"OralB Sdk version %@", version);
    NSLog(@"OralB Sdk devAuth %d", devAuthState);
    
    [OBTSDK setupWithAppID:myId appKey:myKey];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
