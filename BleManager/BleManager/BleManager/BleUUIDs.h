//
//  BleUUIDs.h
//  BleManager
//
//  Created by Vincent on 14-9-14.
//  Copyright (c) 2014年 Vicent. All rights reserved.
//

#ifndef BleManager_BleUUIDs_h
#define BleManager_BleUUIDs_h
#import <CoreBluetooth/CoreBluetooth.h>

/*!
    @param      自定义协议
 */
#define SERVICES_NORMAL             @"6e400001-b5a3-f393-e0a9-77656c6f6f70"
#define READCHARACTERISTIC          @"6e400003-b5a3-f393-e0a9-77656c6f6f70"
#define WRITECHARACTERISTIC         @"6e400002-b5a3-f393-e0a9-77656c6f6f70"

/*!
    @param      标准协议
 */
//电池协议
#define BATTERYSERVICE              @"180F"
#define BATTERYCHARCTERISTIC        @"2A19"
//时间协议
#define TIMESERVICE                 @"1805"
#define TIMECHARACTERISTIC          @"2A2B"
/**
 设备信息服务标准协议
 */
#define DVINFOSERVICE               @"180A"
#define DVMANUFACTURECHARCTERISTIC  @"2A29"
#define DVMODELNUMBERCHARCTERISTIC  @"2A24"
#define DVSERIALNUMBERCHARCTERISTIC @"2A25"
#define DVHARDWARECHARCTERISTIC     @"2A27"
#define DVSOFTWARECHARCTERISTIC     @"2A28"
/*!
    @param  kCReateUUIDFromString(UUIDSTR)  生成UUID
 */
#define kCReateUUIDFromString(UUIDSTR)   [CBUUID UUIDWithString:UUIDSTR]

#endif
