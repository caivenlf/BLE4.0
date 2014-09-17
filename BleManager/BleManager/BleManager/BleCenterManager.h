//
//  BleCenterManager.h
//  BleManager
//
//  Created by Vincent on 14-9-14.
//  Copyright (c) 2014年 Vicent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlePeripheralManager.h"

//blocks propertys:
typedef void (^Block_bleState)(bleState state);
typedef void (^Block_connectedFail)(NSError *error);
typedef void (^Block_Periperals)(NSArray *peripherals);
typedef void (^Block_targetBleState)(targetBleState type);
@interface BleCenterManager : NSObject<CBCentralManagerDelegate>{
    Block_bleState returnBleState;
    Block_Periperals returnPeripherals;
    Block_targetBleState returnTargetBleState;
    Block_connectedFail returnConnectedFail;
}

+ (id)shareInstance;
/*!
    @func 开始扫描设备
 */
- (void)startScan:(Block_Periperals)peripherals;
/*!
    @func 停止扫描
 */
- (void)stopScan;
/*!
    @func 检索已连接上的设备
 */
- (void)retriveConnectedPeripherals:(void(^)(NSArray *connectedPeripheral))peripherals;
/*!
    @func 自动重连
 */
- (void)reconnectPeripheral;
/*!
    @func 连接设备
 */
- (void)connectPeripheral:(CBPeripheral*)peripheral AndSuccess:(void(^)(void))success AndFail:(Block_connectedFail)fail;
/*!
    @func 手动断开连接
 */
- (void)disConnectPeripheral:(void(^)(CBPeripheral *))peripheral;
/*!
    @func 写数据
 */
- (void)writeData:(NSData *)data WithResponse:(BOOL)response AndResponse:(void(^)(void))responseDescriptor;
/*!
    @func 读取特征值Value
 */
- (void)readCharacteristicValue:(characteristicType)characteristicType AndValue:(void(^)(NSData *))data;
/*!
    @func 接收蓝牙Value
 */
- (void)receiveNotifyData:(void(^)(NSData *))data;

//@protocols
/*!
    @func 蓝牙设备的当前状态
 */
- (void)bleStateOn:(Block_bleState)powerState;
/*!
    @func 被连接蓝牙信号的状态
 */
- (void)bleCurrentState:(Block_targetBleState)state;
@end
