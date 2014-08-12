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

- (CBCharacteristic *)writeCharacteristic{
    
    for (CBCharacteristic *characteristic in useableCharacteristics) {
        if ([characteristic.UUID isEqual:[BleConfig writeCharacteristicUUID]]) {
            return characteristic;
        }
    }
    return nil;
}

- (CBCharacteristic *)writeOtaControlCharacteristic{
    
    for (CBCharacteristic *characteristic in useableCharacteristics) {
        if ([characteristic.UUID isEqual:[BleConfig writeOtaControlCharacteristicUUID]]) {
            return characteristic;
        }
    }
    return nil;
}

- (CBCharacteristic *)writeOtaPacketCharacteristic{
    
    for (CBCharacteristic *characteristic in useableCharacteristics) {
        if ([characteristic.UUID isEqual:[BleConfig writeOtaPacketCharacteristicUUID]]) {
            return characteristic;
        }
    }
    return nil;
}

- (CBCharacteristic *)notifyCharacteristic{
    
    for (CBCharacteristic *characteristic in useableCharacteristics) {
        if ([[BleConfig setNotifyCharacteristicUUID] containsObject:characteristic.UUID]) {
            return characteristic;
        }
    }
    return nil;
}

- (CBCharacteristic *)getCharacteristicByType:(characteristicType)type{
    
    CBUUID *typeCharacteristicUUID = [BleConfig standardCharacteristicUUID:type];
    
    for (CBCharacteristic *characteristic in useableCharacteristics) {
        if ([characteristic.UUID isEqual:typeCharacteristicUUID]) {
            return characteristic;
        }
    }
    return nil;
}


@end
