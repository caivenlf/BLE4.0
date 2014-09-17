//
//  ServicesManager.h
//  BleManager
//
//  Created by Vincent on 14-9-14.
//  Copyright (c) 2014年 Vicent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BleUUIDs.h"

@interface Services : NSObject
/*!
    @param  beSearchedServicesUUIDs 被搜索的services
 */
@property (nonatomic,strong)NSArray *beSearchedServicesUUIDs;

@end
