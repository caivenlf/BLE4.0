//
//  BleConfig.h
//  UpdateTool
//
//  Created by Vincent on 14/8/11.
//  Copyright (c) 2014年 Vicent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BleServicesAndCharacteristics.h"

typedef enum {
    BatteryType,TimeType,Device_ManufactureType,
    Device_ModelumberType,Device_SeruakbynverType,
    Device_HardWareType,Device_SoftWareType
}characteristicType;

@interface BleConfig : NSObject

/**
 *  @func   the service's uuid which will be searched/the ble sign
 */
+ (NSArray *)searchServiceUUIDs;
/**
 *  @func   the character'uuids which should be setNotify
 */
+ (NSArray *)setNotifyCharacteristicUUID;
/**
 *  @func   the character'uuids which should be write
 */
+ (CBUUID *)writeCharacteristicUUID;
/**
 *  @func the otaCharacter's uuids which should be write
 */
+ (CBUUID *)writeOtaControlCharacteristicUUID;
+ (CBUUID *)writeOtaPacketCharacteristicUUID;
/**
    @func   get the standard characteristic's uuid
 */
+ (CBUUID *)standardCharacteristicUUID:(characteristicType)type;

@end
