//
//  ReceiveHelper.m
//  StateMachine
//
//  Created by Vincent on 14-3-29.
//  Copyright (c) 2014年 Vincent. All rights reserved.
//

#import "ReceiveHelper.h"

@implementation ReceiveHelper
static id<WatchResponsDelegate>watchPDelegate;
static id<CommandDelegate>watchRDelegate;
static id<WatchDataDelegate>watchDDelegate;
static Byte receivePacket[8];
static enum H2DPCommand currentH2DPEvent;
static enum D2HRCommand currentD2HREvent;

-(id)init{
    self=[super init];
    if (self) {
        
    }
    return self;
}
+(void)getOnePacketFromData:(NSData*)datas{

    [self getCurrentData:datas];
    Byte *tmpbyte = (Byte*)[datas bytes];
    if ([datas length]==0) {
        return;
    }
    for(int i=0;i<8;i++){
        receivePacket[i] = tmpbyte[i];
    }
    if([self checkPacket]){
        NSData *header =  [[NSData alloc] initWithBytes:tmpbyte length:4];
        NSString *headerString = [[NSString alloc] initWithData:header encoding:NSASCIIStringEncoding];
        if ([headerString isEqualToString:@"D2HR"]) {
            [self getCurrentRequestCommand];
        }else if([headerString isEqualToString:@"H2DP"]){
            [self getCurrentResponseCommand];
        }else{
            
        }
    }else{
    }
}
//check packet
+(BOOL)checkPacket{
    int sum=0;
    for (int i=0; i<7; i++) {
        sum+=receivePacket[i];
    }
    sum=sum&0xff;
    if (sum==receivePacket[7]) {
        return YES;
    }
    return NO;
}

+(enum D2HRCommand)getCurrentRequestCommand{

    switch (receivePacket[4]){
        case 0x41:
            currentD2HREvent = ScanDVList;
            break;
        case 0x59:
            currentD2HREvent = TakePicture;
            break;
        case 0x5A:
            currentD2HREvent = TakeVideo;
            break;
        case 0x5B:
            currentD2HREvent = StopVideo;
            break;
        case 0x58:
            currentD2HREvent = TakeRecorder;
            break;
        case 0x50:
            currentD2HREvent = PlayOrStopMusic;
            break;
        case 0x51:
            currentD2HREvent = PlayNextSong;
            break;
        case 0x53:
            currentD2HREvent = GetMusicInfo;
            break;
        case 0x52:
            currentD2HREvent = PlayForwardSong;
            break;
        case 0x44:
            currentD2HREvent = RefuseInCall;
            break;
        case 0x45:
            currentD2HREvent = FindPhone;
            break;
        case 0x46:
            currentD2HREvent = ForgetDevice;
            break;
        case 0x62:
            currentD2HREvent = SendSportData;
            break;
        default:
            break;
    }
    
    if(watchRDelegate != nil){
        [watchRDelegate receiveEventHappend:currentD2HREvent];
    }
    return currentD2HREvent;
}

+(void)getCurrentData:(NSData*)data{
    
    if([watchPDelegate respondsToSelector:@selector(receiveData:)]){
        [watchDDelegate receiveData:data];
    }
}

+(enum H2DPCommand)getCurrentResponseCommand{
    
    switch (receivePacket[4]) {
        case 0x81:
            currentH2DPEvent = AcceptScanDV;
            break;
        case 0x82:
            currentH2DPEvent = AcceptStopScanDV;
            break;
        case 0x83:
            currentH2DPEvent = AcceptAddFriend;
            break;
        case 0x84:
            currentH2DPEvent = AcceptShineDV;
            break;
        case 0x86:
            currentH2DPEvent = AcceptUpdateUserInfo;
            break;
        case 0x87:
            currentH2DPEvent = AcceptDVID;
            break;
        case 0x88:
            currentH2DPEvent = AcceptResetSetting;
            break;
        case 0x89:
            currentH2DPEvent = AcceptResetWatch;
            break;
        case 0x90:
            currentH2DPEvent= AcceptUpdateTime;
            break;
        case 0x94:
            currentH2DPEvent = AcceptUpdateSystem;
            break;
        case 0x92:
            currentH2DPEvent = AcceptUpdateDVName;
            break;
        case 0x93:
            currentH2DPEvent = AcceptMusicInfo;
            break;
        case 0x95:
            currentH2DPEvent = AcceptUpdateData;
            break;
        case 0x98:
            currentH2DPEvent = AcceptUpdateDialPlate;
            break;
        case 0x9B:
            currentH2DPEvent = AcceptFilterData;
            break;
        case 0xA0:
            currentH2DPEvent = AcceptSportDataBegin;
            break;
        case 0x9C:
            currentH2DPEvent = AcceptChangeUI;
            break;
        default:
            break;
    }
    
    if(watchPDelegate != nil){
        [watchPDelegate eventHappened:currentH2DPEvent];
    }
    return currentH2DPEvent;
}

+(void)setWatchPDelegate:(id<WatchResponsDelegate>)delegate{
    watchPDelegate = delegate;
}
+(void)setWatchRDelegate:(id<CommandDelegate>)delegate{
    watchRDelegate = delegate;
}
+(void)setWatchDDelegate:(id<WatchDataDelegate>)delegate{
    watchDDelegate = delegate;
}

@end
