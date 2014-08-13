//
//  CharacteristicManager.h
//  BLE4.0
//
//  Created by Vincent on 14-8-11.
//  Copyright (c) 2014年 Vicent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BleConfig.h"



@interface CharacteristicManager : NSObject


/**
 *  @para   Characteristics
 */
@property (nonatomic,strong)CBCharacteristic *writeCharacteristic;
@property (nonatomic,strong)CBCharacteristic *writeOtaControlCharacteristic;
@property (nonatomic,strong)CBCharacteristic *writeOtaPacketCharacteristic;

@property (nonatomic,strong)NSMutableArray *useableCharacteristics;
@property (nonatomic,strong)CBCharacteristic *notifyCharacteristic;
/**
 *  @func get characteristic by type
 */
- (CBCharacteristic *)getCharacteristicByType:(characteristicType)type;

@end
