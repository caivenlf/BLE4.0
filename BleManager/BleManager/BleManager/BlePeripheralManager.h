//
//  BlePeripheralManager.h
//  BleManager
//
//  Created by Vincent on 14-9-16.
//  Copyright (c) 2014年 Vicent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Services.h"
#import "Characteristics.h"

typedef void (^Block_ConnectedSuccess)(void);
typedef void (^Block_WriteDataResponse)(void);
typedef void (^Block_ReadValue)(NSData *receiveReadData);
typedef void (^Block_ReceiveNotifyData)(NSData *receiveNotifyData);
@interface BlePeripheralManager : NSObject<CBPeripheralDelegate>{
    Block_ConnectedSuccess returnConnectedSuccess;
    Block_WriteDataResponse returnWriteDataResponse;
    Block_ReadValue returnReadValue;
    Block_ReceiveNotifyData returnReceiveNotifyData;
}

@property (nonatomic,strong)CBPeripheral *selectedPeripheral;
@property (nonatomic,strong)NSString *LastPeripheralIndetiferStr;
- (void)connectedSuccess:(Block_ConnectedSuccess)success;
- (void)writeData:(NSData *)data WithResponse:(BOOL)response AndResponse:(Block_WriteDataResponse)writeResponse;
- (void)readCharacteristicValue:(characteristicType)characteristicType AndValue:(Block_ReadValue)data;
- (void)receiveNotifyData:(Block_ReceiveNotifyData)data;
@end
