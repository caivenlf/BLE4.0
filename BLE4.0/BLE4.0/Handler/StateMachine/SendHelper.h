//
//  SendHelper.h
//  StateMachine
//
//  Created by Vincent on 14-3-29.
//  Copyright (c) 2014年 Vincent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommandDelegate.h"

@interface SendHelper : NSObject{
    
}

+(void)initializeCommandWith:(enum CommandHeader)Head;
+(void)setH2DRCommand:(enum H2DRCommand)command;
+(NSData*)getCurrentDataWithHeader:(enum CommandHeader)header AndH2DRCommand:(enum H2DRCommand)h2drCommand AndNextDataLength:(int)length;
+(NSData *)getCurrentDataWithHeader:(enum CommandHeader)header AndD2HPCommand:(enum D2HPCommand)d2hpCommand AndNextDataLength:(int)length;

@end
