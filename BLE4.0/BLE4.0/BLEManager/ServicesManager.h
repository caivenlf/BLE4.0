//
//  ServicesManager.h
//  UpdateTool
//
//  Created by Vincent on 14/8/10.
//  Copyright (c) 2014年 Vicent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BleConfig.h"

@interface ServicesManager : NSObject

/**
 *  @para   allServices
 */
@property (nonatomic,strong) NSMutableArray *useableServices;

/**
 @func -> the service's uuid which will be searched
 */
+ (NSArray *)getTargetServiceUUID;
- (CBService*)getServiceByUUID:(CBUUID*)uuid;

@end
