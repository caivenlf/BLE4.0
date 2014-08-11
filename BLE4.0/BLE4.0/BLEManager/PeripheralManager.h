//
//  PeripheralManager.h
//  BLE4.0
//
//  Created by Vincent on 14-8-11.
//  Copyright (c) 2014年 Vicent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
@interface PeripheralManager : NSObject<CBPeripheralDelegate>

@property (nonatomic,strong)CBPeripheral *selectedPeripheral;

- (void)startDiscoverService;

@end
