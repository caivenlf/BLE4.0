//
//  ServicesManager.m
//  BleManager
//
//  Created by Vincent on 14-9-14.
//  Copyright (c) 2014年 Vicent. All rights reserved.
//

#import "Services.h"

@implementation Services

- (NSArray *)beSearchedServicesUUIDs{
    return @[kCReateUUIDFromString(SERVICES_NORMAL)];
}
@end
