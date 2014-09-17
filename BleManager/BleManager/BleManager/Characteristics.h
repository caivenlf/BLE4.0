//
//  Characteristics.h
//  BleManager
//
//  Created by Vincent on 14-9-16.
//  Copyright (c) 2014年 Vicent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BleUUIDs.h"
#import "BleConstant.h"
@interface Characteristics : NSObject

//UUIDs
@property (nonatomic,strong)CBUUID *readCharacteristicsUUID;
@property (nonatomic,strong)CBUUID *writeCharacteristicsUUID;
@property (nonatomic,strong)CBUUID *batteryCharacteristicsUUID;
@property (nonatomic,strong)CBUUID *timeCharacteristicsUUID;
@property (nonatomic,strong)CBUUID *deviceInfo_ManufactureUUID;
@property (nonatomic,strong)CBUUID *deviceInfo_ModelNumberUUID;
@property (nonatomic,strong)CBUUID *deviceInfo_SerialNumberUUID;
@property (nonatomic,strong)CBUUID *deviceInfo_HardWareUUID;
@property (nonatomic,strong)CBUUID *deviceInfo_SoftWareUUID;
//Characteristics
@property (nonatomic,strong)CBCharacteristic *readCharacteristic;
@property (nonatomic,strong)CBCharacteristic *writeCharacteristic;
@property (nonatomic,strong)CBCharacteristic *batteryCharacteristic;
@property (nonatomic,strong)CBCharacteristic *timeCharacteristic;
@property (nonatomic,strong)CBCharacteristic *deviceInfo_ManufactureCharacteristic;
@property (nonatomic,strong)CBCharacteristic *deviceInfo_ModelNumberCharacteristic;
@property (nonatomic,strong)CBCharacteristic *deviceInfo_SerialNumberCharacteristic;
@property (nonatomic,strong)CBCharacteristic *deviceInfo_HardWareCharacteristic;
@property (nonatomic,strong)CBCharacteristic *deviceInfo_SoftWareCharacteristic;
@end
