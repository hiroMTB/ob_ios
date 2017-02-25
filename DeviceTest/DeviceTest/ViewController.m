//
//  ViewController.m
//  DeviceTest
//
//  Created by hiroshi matoba on 25/02/2017.
//  Copyright © 2017 hiroshi matoba. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.orec = [[oralbReceiver alloc] init];
    [self.orec setup];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
