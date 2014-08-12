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
    
    return [self getCharacteristicFromUUID:[BleConfig writeCharacteristicUUID]];
}

- (CBCharacteristic *)writeOtaControlCharacteristic{
    
    return [self getCharacteristicFromUUID:[BleConfig writeOtaControlCharacteristicUUID]];
}

- (CBCharacteristic *)writeOtaPacketCharacteristic{
    
    return [self getCharacteristicFromUUID:[BleConfig writeOtaPacketCharacteristicUUID]];
}

- (CBCharacteristic *)getCharacteristicFromUUID:(CBUUID *)uuid{
    
    for (CBCharacteristic *characteristic in useableCharacteristics) {
        if ([characteristic.UUID isEqual:uuid]) {
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
