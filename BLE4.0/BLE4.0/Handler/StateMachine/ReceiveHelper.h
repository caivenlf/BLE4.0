//
//  ReceiveHelper.h
//  StateMachine
//
//  Created by Vincent on 14-3-29.
//  Copyright (c) 2014年 Vincent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommandDelegate.h"

@interface ReceiveHelper : NSObject

+(void)getOnePacketFromData:(NSData*)datas;
+(enum D2HRCommand)getCurrentRequestCommand;
+(enum H2DPCommand)getCurrentResponseCommand;
+(void)getCurrentData:(NSData*)data;
+(void)setWatchPDelegate:(id<WatchResponsDelegate>)delegate;
+(void)setWatchRDelegate:(id<CommandDelegate>)delegate;
+(void)setWatchDDelegate:(id<WatchDataDelegate>)delegate;

@end
