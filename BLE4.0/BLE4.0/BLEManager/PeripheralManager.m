//
//  PeripheralManager.m
//  BLE4.0
//
//  Created by Vincent on 14-8-11.
//  Copyright (c) 2014年 Vicent. All rights reserved.
//

#import "PeripheralManager.h"
#import "ServicesManager.h"
#import "CharacteristicManager.h"

@interface PeripheralManager(){
  
    ServicesManager *serviceManager;
    CharacteristicManager *characteristicManager;
}
@end

@implementation PeripheralManager
@synthesize selectedPeripheral;

- (id)init{
    
    self = [super init];
    if (self) {
        
        serviceManager = [[ServicesManager alloc] init];
        characteristicManager = [[CharacteristicManager alloc] init];
    }
    return self;
}

#pragma mark - Self Method
- (void)startDiscoverService{
    
    [[serviceManager useableServices] removeAllObjects];
    [[characteristicManager useableCharacteristics] removeAllObjects];
    [selectedPeripheral setDelegate:self];
    [selectedPeripheral discoverServices:nil];
}

- (void)writeData:(NSData *)data WithResponse:(BOOL)response{
    
    if (response) {
        [selectedPeripheral writeValue:data forCharacteristic:[characteristicManager writeCharacteristic] type:CBCharacteristicWriteWithResponse];
    }else{
        [selectedPeripheral writeValue:data forCharacteristic:[characteristicManager writeCharacteristic] type:CBCharacteristicWriteWithoutResponse];
    }
}

#pragma mark - CBPeripheralDelegate
- (void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    
    [[serviceManager useableServices] addObjectsFromArray:[peripheral services]];
    for (CBService *curService in [serviceManager useableServices]){
        [peripheral discoverCharacteristics:nil forService:curService];
    }
}

- (void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    
    [[characteristicManager useableCharacteristics] addObjectsFromArray:[service characteristics]];
    [peripheral setNotifyValue:YES forCharacteristic:[characteristicManager notifyCharacteristic]];
}

- (void) peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{

    returnbleReceiveData([characteristic value]);
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
}

- (void) peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{

}

#pragma mark - Blocks
/**
    @func Blocks
 */
- (void)bleReceiveData:(Block_receiveData)receiveData{
    
    returnbleReceiveData = receiveData;
}
@end
