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
 *  @para   allCharacteristics
 */
@property (nonatomic,strong)NSMutableArray *useableCharacteristics;
@property (nonatomic,strong)CBCharacteristic *writeCharacteristic;
@property (nonatomic,strong)CBCharacteristic *notifyCharacteristic;


@end
