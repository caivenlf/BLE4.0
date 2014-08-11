//
//  PeripheralManager.h
//  BLE4.0
//
//  Created by Vincent on 14-8-11.
//  Copyright (c) 2014年 Vicent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

typedef void (^Block_receiveData)(NSData *receiveData);

@interface PeripheralManager : NSObject<CBPeripheralDelegate>{
    
    Block_receiveData returnbleReceiveData;
}

@property (nonatomic,strong)CBPeripheral *selectedPeripheral;

- (void)startDiscoverService;
- (void)writeData:(NSData *)data WithResponse:(BOOL)response;


/**
 *  @func Blocks
 */
- (void)bleReceiveData:(Block_receiveData)receiveData;
@end
