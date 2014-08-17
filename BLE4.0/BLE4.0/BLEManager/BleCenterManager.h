//
//  BleManager.h
//  UpdateTool
//
//  Created by Vincent on 14/8/10.
//  Copyright (c) 2014年 Vicent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "ServicesManager.h"
#import "PeripheralManager.h"
#import "BleServicesAndCharacteristics.h"

typedef enum {
    PoweredOff,PoweredOn,Unsupported,Unauthorized,Unknown,Resetting,Other
}bleState;

//Center
typedef void (^Block_blePowerState)(bleState state);
typedef void (^Block_bleDidConnect)(CBPeripheral *peripheral);
typedef void (^Block_bleDidDisConnect)(CBPeripheral *peripheral);
typedef void (^Block_bleDidFailConnect)(CBPeripheral *peripheral);
typedef void (^Block_bleDidDiscover)(CBPeripheral *peripheral,NSDictionary *adverDic,NSNumber *rssi);
//peripheral
typedef void (^Block_receiveData)(NSData *receiveData,CBCharacteristic *charactristic);
typedef void (^Block_writeData)(CBCharacteristic *characteristic);

@interface BleCenterManager : NSObject<CBCentralManagerDelegate>{
    
    Block_blePowerState returnBleState;
    Block_bleDidConnect returnBleDidConnect;
    Block_bleDidDisConnect returnBleDidDisConnect;
    Block_bleDidDisConnect returnBleDidFailConnect;
    Block_bleDidDiscover returnBleDidDiscover;
    
    Block_receiveData returnBleReceiveData;
    Block_writeData returnbleWriteData;
}
@property (nonatomic,strong)CBCentralManager *centralManager;

/**
 *  @func   self method about ble operation
 */
+ (id)sharedInstance;
- (void)startScan;
- (void)stopScan;
- (void)connectPeripheral:(CBPeripheral*)peripheral;
- (void)connectRetrivePeripheral;
- (void)disConnectPeripheral;
- (void)writeData:(NSData *)data WithResponse:(BOOL)response;
- (void)writeOTAControlData:(NSData *)data WithResponse:(BOOL)response;
- (void)writeOTAPacketData:(NSData *)data WithResponse:(BOOL)response;
- (void)readValue:(characteristicType)type;

/**
 *  @func  blocks
 *      @required:bleStateOn:
 */
- (void)bleStateOn:(Block_blePowerState)powerState;
//option
- (void)bleDidConnect:(Block_bleDidConnect)didConnect;
- (void)bleDidDisConnect:(Block_bleDidDisConnect)didDisConnect;
- (void)bleDidFailConnect:(Block_bleDidFailConnect)didFailConnect;
- (void)bleDidDiscover:(Block_bleDidDiscover)didDiscover;
//Peripheral Blocks
- (void)bleReceiveData:(Block_receiveData)receiveData;
- (void)bleWriteData:(Block_writeData)writeData;
@end
