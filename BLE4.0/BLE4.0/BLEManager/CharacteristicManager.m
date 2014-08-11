//
//  CharacteristicManager.m
//  BLE4.0
//
//  Created by Vincent on 14-8-11.
//  Copyright (c) 2014年 Vicent. All rights reserved.
//

#import "CharacteristicManager.h"

@implementation CharacteristicManager
@synthesize useableCharacteristics;

- (id)init{
    
    self = [super init];
    if (self) {
        
        useableCharacteristics = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}

- (void)setNotifyForCharacteristic:(CBCharacteristic *)characteristic ByPeripheral:(CBPeripheral *)peripheral{
    
}

@end
