//
//  PeripheralManager.m
//  BLE4.0
//
//  Created by Vincent on 14-8-11.
//  Copyright (c) 2014年 Vicent. All rights reserved.
//

#import "PeripheralManager.h"

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

- (void)writeOTAControlData:(NSData *)data WithResponse:(BOOL)response{
    
    if (response) {
        [selectedPeripheral writeValue:data forCharacteristic:[characteristicManager writeOtaControlCharacteristic] type:CBCharacteristicWriteWithResponse];
    }else{
        [selectedPeripheral writeValue:data forCharacteristic:[characteristicManager writeOtaControlCharacteristic] type:CBCharacteristicWriteWithoutResponse];
    }
}

- (void)writeOTAPacketData:(NSData *)data WithResponse:(BOOL)response{
    
    if (response) {
        [selectedPeripheral writeValue:data forCharacteristic:[characteristicManager writeOtaPacketCharacteristic] type:CBCharacteristicWriteWithResponse];
    }else{
        [selectedPeripheral writeValue:data forCharacteristic:[characteristicManager writeOtaPacketCharacteristic] type:CBCharacteristicWriteWithoutResponse];
    }
}

- (void)readCharacteristic:(characteristicType)type{
    
    [selectedPeripheral readValueForCharacteristic:[characteristicManager getCharacteristicByType:type]];
}

#pragma mark - CBPeripheralDelegate
- (void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    if (error) {return;}
    [[serviceManager useableServices] addObjectsFromArray:[peripheral services]];
    for (CBService *curService in [serviceManager useableServices]){
        [peripheral discoverCharacteristics:nil forService:curService];
    }
}

- (void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if (error) {return;}
    [[characteristicManager useableCharacteristics] addObjectsFromArray:[service characteristics]];
    [peripheral setNotifyValue:YES forCharacteristic:[characteristicManager notifyCharacteristic]];
}

- (void) peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error) {return;}
    returnbleReceiveData([characteristic value],characteristic);
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error) {return;}
}

- (void) peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error) {return;}
    returnbleWriteData(characteristic);
}

#pragma mark - Blocks
/**
    @func Blocks
 */
- (void)bleReceiveData:(Block_receiveData)receiveData{
    
    returnbleReceiveData = receiveData;
}

- (void)bleWriteData:(Block_writeData)writeData{
    
    returnbleWriteData = writeData;
}
@end
