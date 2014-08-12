//
//  BleConfig.m
//  UpdateTool
//
//  Created by Vincent on 14/8/11.
//  Copyright (c) 2014年 Vicent. All rights reserved.
//

#import "BleConfig.h"

@implementation BleConfig

+ (NSArray *)searchServiceUUIDs{
    
    return @[kCREATEUUIDFROMSTRING(SERVICES_NORMAL),kCREATEUUIDFROMSTRING(SERVICES_OTA)];
}

+ (NSArray *)setNotifyCharacteristicUUID{
    
    return @[kCREATEUUIDFROMSTRING(READCHARACTERISTIC),kCREATEUUIDFROMSTRING(WRITECHARACTERISTIC),kCREATEUUIDFROMSTRING(UPDATECONTROLCHARACTERISTIC)];
}

+ (CBUUID *)writeCharacteristicUUID{
    
    return kCREATEUUIDFROMSTRING(WRITECHARACTERISTIC);
}

+ (CBUUID *)writeOtaPacketCharacteristicUUID{
    
    return kCREATEUUIDFROMSTRING(UPDATEPACKETCHARACTERISTIC);
}

+ (CBUUID *)writeOtaControlCharacteristicUUID{
    
    return kCREATEUUIDFROMSTRING(UPDATECONTROLCHARACTERISTIC);
}

+ (CBUUID *)standardCharacteristicUUID:(characteristicType)type{
    
    CBUUID *uuid;
    switch (type) {
        case BatteryType:
            uuid = kCREATEUUIDFROMSTRING(BATTERYCHARCTERISTIC);
            break;
        case TimeType:
            uuid = kCREATEUUIDFROMSTRING(TIMECHARACTERISTIC);
            break;
        case Device_ManufactureType:
            uuid = kCREATEUUIDFROMSTRING(DVMANUFACTURECHARCTERISTIC);
            break;
        case Device_ModelumberType:
            uuid = kCREATEUUIDFROMSTRING(DVMODELNUMBERCHARCTERISTIC);
            break;
        case Device_SeruakbynverType:
            uuid = kCREATEUUIDFROMSTRING(DVSERIALNUMBERCHARCTERISTIC);
            break;
        case Device_HardWareType:
            uuid = kCREATEUUIDFROMSTRING(DVHARDWARECHARCTERISTIC);
            break;
        case Device_SoftWareType:
            uuid = kCREATEUUIDFROMSTRING(DVSOFTWARECHARCTERISTIC);
            break;
        default:
            break;
    }
    return uuid;
}

@end
