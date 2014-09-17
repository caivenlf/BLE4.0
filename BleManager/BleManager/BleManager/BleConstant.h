//
//  BleConstant.h
//  BleManager
//
//  Created by Vincent on 14-9-14.
//  Copyright (c) 2014年 Vicent. All rights reserved.
//

#ifndef BleManager_BleConstant_h
#define BleManager_BleConstant_h

/*!
    @param   bleState    蓝牙的状态
 */
typedef enum {
    PoweredOff,
    PoweredOn,
    Unsupported,
    Unauthorized,
    Unknown,
    Resetting,
    Other
}bleState;

/*!
    @param characteristicType   特征值的类型
 */
typedef enum {
    ReadCharacteristicType,
    WriteCharacteristicType,
    BatteryCharacteristicType,
    TimeCharacteristicType,
    DeviceInfo_ManufactureCharacteristicType,
    DeviceInfo_ModelNumberCharacteristicType,
    DeviceInfo_SerialNumberCharacteristicType,
    DeviceInfo_HardWareCharacteristicType,
    DeviceInfo_SoftWareCharacteristicType
}characteristicType;

/*!
    @param targetBleState     目标蓝牙当前状态的改变
 */
typedef enum {
    Ble_Connected,
    Ble_DisConnected
}targetBleState;

#endif
