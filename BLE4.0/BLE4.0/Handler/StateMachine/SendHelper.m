//
//  SendHelper.m
//  StateMachine
//
//  Created by Vincent on 14-3-29.
//  Copyright (c) 2014年 Vincent. All rights reserved.
//

#import "SendHelper.h"



@implementation SendHelper
static Byte firstPacket[8];

+(void)initializeCommandWith:(enum CommandHeader)Head{
    
    NSString *headerStr;
    switch (Head) {
        case H2DR:
            headerStr = @"H2DR";
            break;
        case H2DP:
            headerStr = @"H2DP";
            break;
        case D2HR:
            headerStr = @"D2HR";
            break;
        case D2HP:
            headerStr = @"D2HP";
            break;
        default:
            break;
    }
    NSData *data = [headerStr dataUsingEncoding:NSUTF8StringEncoding];
    Byte *tmpByte = (Byte *)[data bytes];
    for(int i=0;i<4;i++){
        firstPacket[i] = tmpByte[i];
    }
}

+(void)setH2DRCommand:(enum H2DRCommand)command{
    /**
         Host命令列表：
         =1，启动扫描周围设备
         =2，停止扫描周围设备
         =3，加好友指定的设备
         =4，闪指定的设备
         =6，更新个人信息(Name-Phone)
         =7，得到手环ID
         =0x10，更新时间
         =0x11，升级代码
         =0x12，寻找设备
         =0x18，更新表盘
         =0x3A，校验无法通过
     */
    int commandValue=0;
    switch (command) {
        case QueryServerStatus:
            break;
        case ScanDV:
            commandValue=0x81;
            break;
        case StopScanDV:
            commandValue=0x82;
            break;
        case AddFriend:
            commandValue=0x83;
            break;
        case ShineDV:
            commandValue=0x84;
            break;
        case UpdateUserInfo:
            commandValue=0x86;
            break;
        case getDVID:
            commandValue=0x87;
            break;
        case ResetSetting:
            commandValue=0x88;
            break;
        case ResetWatch:
            commandValue = 0x89;
            break;
        case UpdateTime:
            commandValue=0x90;
            break;
        case UpdateSystem:
            commandValue=0x94;
            break;
        case UpdateDVName:
            commandValue=0x92;
            break;
        case UpdateMusic:
            commandValue = 0x93;
            break;
        case UpdateData:
            commandValue = 0x95;
            break;
        case UpdateDialPlate:
            commandValue=0x98;
            break;
        case LimitNotify:
            commandValue = 0x9B;
            break;
        case GetSportData:
            commandValue = 0xA0;
            break;
        case ChangeWatchUI:
            commandValue = 0x9C;
            break;
        default:
            break;
    }
    firstPacket[4] = commandValue;
}

+(void)setD2HPCommand:(enum D2HPCommand)command{
    
    int commandValue=0;
    switch (command) {
        case FindPhoneResponse:
            commandValue = 0x45;
            break;
        case PlayMusicResponse:
            commandValue = 0x43;
            break;
        case TakePictureResponse:
            commandValue = 0x59;
            break;
        case TakeVideoResponse:
            commandValue = 0x5A;
            break;
        case StopVideoResponse:
            commandValue = 0x5B;
            break;
        case TakeRecordResponse:
            commandValue = 0x58;
            break;
        case ScanDVListResponse:
            commandValue = 0x41;
            break;
        case RefuseInCallResponse:
            commandValue = 0x44;
            break;
        case PlayOrStopMusicResponse:
            commandValue = 0x50;
            break;
        case PlayNextSongResponse:
            commandValue = 0x51;
            break;
        case PlayForwardSongResponse:
            commandValue = 0x52;
            break;
        case UpdateMusicResponse:
            commandValue = 0x53;
            break;
        case GetSportDataResponse:
            commandValue = 0x62;
            break;
        case ReceiveHealthDataResponse:
            commandValue = 0x63;
        default:
            break;
    }
    firstPacket[4] = commandValue;
}

+(void)getLength:(int)length{
    firstPacket[5] = (Byte)length;
}

+(void)getWay{
    firstPacket[6] = 0x00;
}

+(void)calculateSum{
    int sum=0;
    for (int i=0; i<7; i++) {
        sum+=firstPacket[i];
		
		printf("%i ",firstPacket[i]);
    }
    sum=sum&0xff;
    firstPacket[7]=sum;
}

+(NSData*)getCurrentDataWithHeader:(enum CommandHeader)header AndH2DRCommand:(enum H2DRCommand)h2drCommand AndNextDataLength:(int)length{
    
    [SendHelper initializeCommandWith:header];
    [SendHelper setH2DRCommand:h2drCommand];
    [SendHelper getLength:length];
    [SendHelper getWay];
    [SendHelper calculateSum];
    return [[NSData alloc] initWithBytes:firstPacket length:8];
}

+(NSData *)getCurrentDataWithHeader:(enum CommandHeader)header AndD2HPCommand:(enum D2HPCommand)d2hpCommand AndNextDataLength:(int)length{
    
    [SendHelper initializeCommandWith:header];
    [SendHelper setD2HPCommand:d2hpCommand];
    [SendHelper getLength:length];
    [SendHelper getWay];
    [SendHelper calculateSum];
    return [[NSData alloc] initWithBytes:firstPacket length:8];
}

@end
