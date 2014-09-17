//
//  Characteristics.m
//  BleManager
//
//  Created by Vincent on 14-9-16.
//  Copyright (c) 2014年 Vicent. All rights reserved.
//

#import "Characteristics.h"

@implementation Characteristics

- (CBUUID *)readCharacteristicsUUID{
    return kCReateUUIDFromString(READCHARACTERISTIC);
}
- (CBUUID *)writeCharacteristicsUUID{
    return kCReateUUIDFromString(WRITECHARACTERISTIC);
}
- (CBUUID *)timeCharacteristicsUUID{
    return kCReateUUIDFromString(TIMECHARACTERISTIC);
}
- (CBUUID *)batteryCharacteristicsUUID{
    return kCReateUUIDFromString(BATTERYCHARCTERISTIC);
}
- (CBUUID *)deviceInfo_ManufactureUUID{
    return kCReateUUIDFromString(DVMANUFACTURECHARCTERISTIC);
}
- (CBUUID *)deviceInfo_ModelNumberUUID{
    return kCReateUUIDFromString(DVMODELNUMBERCHARCTERISTIC);
}
- (CBUUID *)deviceInfo_SerialNumberUUID{
    return kCReateUUIDFromString(DVSERIALNUMBERCHARCTERISTIC);
}
- (CBUUID *)deviceInfo_HardWareUUID{
    return kCReateUUIDFromString(DVHARDWARECHARCTERISTIC);
}
- (CBUUID *)deviceInfo_SoftWareUUID{
    return kCReateUUIDFromString(DVSOFTWARECHARCTERISTIC);
}

@end
