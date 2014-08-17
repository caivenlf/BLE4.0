//
//  PeripheralManager.h
//  BLE4.0
//
//  Created by Vincent on 14-8-11.
//  Copyright (c) 2014年 Vicent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "ServicesManager.h"
#import "CharacteristicManager.h"

#define LastPeripheraName   @"lastPeripheralName"

typedef void (^Block_receiveData)(NSData *receiveData,CBCharacteristic *characteristic);
typedef void (^Block_writeData)(CBCharacteristic *characteristic);

@interface PeripheralManager : NSObject<CBPeripheralDelegate>{
    
    Block_receiveData returnbleReceiveData;
    Block_writeData returnbleWriteData;
}

@property (nonatomic,strong)CBPeripheral *selectedPeripheral;
@property (nonatomic,strong)CBPeripheral *reReviewPeripheral;

- (void)startDiscoverService;
- (void)readCharacteristic:(characteristicType)type;
- (void)writeData:(NSData *)data WithResponse:(BOOL)response;
- (void)writeOTAControlData:(NSData *)data WithResponse:(BOOL)response;
- (void)writeOTAPacketData:(NSData *)data WithResponse:(BOOL)response;
- (CBPeripheral *)reReviewPeripheral:(NSArray *)reViewPeripherals;
/**
 *  @func Blocks
 */
- (void)bleReceiveData:(Block_receiveData)receiveData;
- (void)bleWriteData:(Block_writeData)writeData;
@end
