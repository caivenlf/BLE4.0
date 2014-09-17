//
//  BlePeripheralManager.m
//  BleManager
//
//  Created by Vincent on 14-9-16.
//  Copyright (c) 2014年 Vicent. All rights reserved.
//

#import "BlePeripheralManager.h"
#define ErrorReturn if(error){return;}
@interface BlePeripheralManager(){
    Characteristics *_characteristic;
    CBPeripheral *_selectedPeripheral;
    CBCharacteristic *_beReadCharacteristic;
}
@end
@implementation BlePeripheralManager

- (id)init{
    self = [super init];
    if (self) {
        _characteristic = [[Characteristics alloc] init];
    }
    return self;
}
#pragma mark - Self Methods
- (void)connectedSuccess:(Block_ConnectedSuccess)success{
    returnConnectedSuccess = success;
}

- (void)writeData:(NSData *)data WithResponse:(BOOL)response AndResponse:(Block_WriteDataResponse)writeResponse{
    returnWriteDataResponse = writeResponse;
    if (_selectedPeripheral) {
        if (response) {
            [_selectedPeripheral writeValue:data forCharacteristic:_characteristic.writeCharacteristic type:CBCharacteristicWriteWithResponse];
        }else{
            [_selectedPeripheral writeValue:data forCharacteristic:_characteristic.writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
        }
    }
}

- (void)readCharacteristicValue:(characteristicType)characteristicType AndValue:(Block_ReadValue)data{
    returnReadValue = data;
    CBCharacteristic *characteristic;
    switch (characteristicType) {
        case ReadCharacteristicType:
            characteristic = _characteristic.readCharacteristic;
            break;
        case BatteryCharacteristicType:
            characteristic = _characteristic.batteryCharacteristic;
            break;
        case TimeCharacteristicType:
            characteristic = _characteristic.timeCharacteristic;
            break;
        case DeviceInfo_ManufactureCharacteristicType:
            characteristic = _characteristic.deviceInfo_ManufactureCharacteristic;
            break;
        case DeviceInfo_ModelNumberCharacteristicType:
            characteristic = _characteristic.deviceInfo_ModelNumberCharacteristic;
            break;
        case DeviceInfo_SerialNumberCharacteristicType:
            characteristic = _characteristic.deviceInfo_SerialNumberCharacteristic;
            break;
        case DeviceInfo_HardWareCharacteristicType:
            characteristic = _characteristic.deviceInfo_HardWareCharacteristic;
            break;
        case DeviceInfo_SoftWareCharacteristicType:
            characteristic = _characteristic.deviceInfo_SoftWareCharacteristic;
            break;
        default:
            break;
    }
    _beReadCharacteristic = characteristic;
    [_selectedPeripheral readValueForCharacteristic:characteristic];
}

- (void)receiveNotifyData:(Block_ReceiveNotifyData)data{
    returnReceiveNotifyData = data;
}

#pragma mark - Set and Get Method
- (void)setSelectedPeripheral:(CBPeripheral *)selectedPeripheral{
    _selectedPeripheral = selectedPeripheral;
    [selectedPeripheral setDelegate:self];
    [selectedPeripheral discoverServices:nil];
}

#pragma mark - Protocol
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    ErrorReturn;
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    ErrorReturn;
    for (CBCharacteristic *characteristic in [service characteristics]) {
        if ([characteristic.UUID isEqual:_characteristic.readCharacteristicsUUID]) {
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            self.LastPeripheralIndetiferStr = peripheral.identifier.UUIDString;
        }else if ([characteristic.UUID isEqual:_characteristic.writeCharacteristicsUUID]){
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            _characteristic.writeCharacteristic = characteristic;
        }else if ([characteristic.UUID isEqual:_characteristic.batteryCharacteristicsUUID]){
            _characteristic.batteryCharacteristic = characteristic;
        }else if ([characteristic.UUID isEqual:_characteristic.timeCharacteristicsUUID]){
            _characteristic.timeCharacteristic = characteristic;
        }else if ([characteristic.UUID isEqual:_characteristic.deviceInfo_ManufactureUUID]){
            _characteristic.deviceInfo_ManufactureCharacteristic = characteristic;
        }else if ([characteristic.UUID isEqual:_characteristic.deviceInfo_ModelNumberUUID]){
            _characteristic.deviceInfo_ModelNumberCharacteristic = characteristic;
        }else if ([characteristic.UUID isEqual:_characteristic.deviceInfo_SerialNumberUUID]){
            _characteristic.deviceInfo_SerialNumberCharacteristic = characteristic;
        }else if ([characteristic.UUID isEqual:_characteristic.deviceInfo_HardWareUUID]){
            _characteristic.deviceInfo_HardWareCharacteristic = characteristic;
        }else if ([characteristic.UUID isEqual:_characteristic.deviceInfo_SoftWareUUID]){
            _characteristic.deviceInfo_SoftWareCharacteristic = characteristic;
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    ErrorReturn;
    if ([characteristic.UUID isEqual:_characteristic.readCharacteristicsUUID]) {
        if (returnConnectedSuccess) {
            returnConnectedSuccess();
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if ([_beReadCharacteristic isEqual:characteristic]) {
        if (returnReadValue) {
            returnReadValue([characteristic value]);
        }
        _beReadCharacteristic = nil;
    }else if ([characteristic.UUID isEqual:_characteristic.readCharacteristicsUUID]){
        if (returnReceiveNotifyData) {
            returnReceiveNotifyData([characteristic value]);
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    ErrorReturn;
     if (returnWriteDataResponse) {
         returnWriteDataResponse();
     }
}
@end
