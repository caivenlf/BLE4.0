//
//  MainCtl.m
//  BLE4.0
//
//  Created by Vincent on 14-8-11.
//  Copyright (c) 2014年 Vicent. All rights reserved.
//

#import "MainCtl.h"
#import "BleCenterManager.h"
#import "OTAUpdateSys.h"
#import "ReceiveHelper.h"

@interface MainCtl ()

@end

@implementation MainCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[BleCenterManager sharedInstance] bleStateOn:^(bleState state) {
        if (state == PoweredOn) {
            NSLog(@"hahah");
        }
    }];
    [[BleCenterManager sharedInstance] bleDidConnect:^(CBPeripheral *peripheral) {
        
    }];
    [[BleCenterManager sharedInstance] bleDidDisConnect:^(CBPeripheral *peripheral) {
        
    }];
    [[BleCenterManager sharedInstance] bleReceiveData:^(NSData *receiveData,CBCharacteristic *characteristic) {
        [ReceiveHelper getOnePacketFromData:receiveData];
    }];
    [[BleCenterManager sharedInstance] bleWriteData:^(CBCharacteristic *characteristic) {
        
        NSLog(@"Write Data Success");
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendMessage:(id)sender {
    
    [[OTAUpdateSys shareInstance] getStart];
    [[OTAUpdateSys shareInstance] getProgeress:^(float progress) {
        NSLog(@"%lf",progress);
    }];
}


@end
