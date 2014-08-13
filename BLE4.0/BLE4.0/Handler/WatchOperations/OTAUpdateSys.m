//
//  OTAUpdateSys.m
//  BLE4.0
//
//  Created by Vincent on 14-8-12.
//  Copyright (c) 2014年 Vicent. All rights reserved.
//

#import "OTAUpdateSys.h"
#define MAX_PACKET_SIZE             20
#define DESIRED_NOTIFICATION_STEPS  80

@interface OTAUpdateSys(){
    
    int sendStage;
    int receiveStage;
    NSData *watchFileData;
    int firmwareDataBytesSent;
    int notificationPacketInterval;
    int appSize;
}

@end

@implementation OTAUpdateSys

+ (id)shareInstance{
    
    static OTAUpdateSys *this;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        this = [[OTAUpdateSys alloc] init];
    });
    return this;
}

- (id)init{
    
    self = [super init];
    if (self) {
        
        NSURL *watchFileURL = [[NSBundle mainBundle] URLForResource:@"ble_app_ancs" withExtension:@"bin"];
        watchFileData = [NSData dataWithContentsOfURL:watchFileURL];
        appSize = (int)watchFileData.length;
        notificationPacketInterval = appSize/(MAX_PACKET_SIZE*DESIRED_NOTIFICATION_STEPS);
    }
    return self;
}

- (void)getStart{
    [self bleBlocks];
    firmwareDataBytesSent = 0;
    sendStage = 0;
    [self sendCommandAtStage:sendStage];
}

- (void)getProgeress:(Block_otaUpdateProgress)progress{
    
    returnProgress = progress;
}

- (void)bleBlocks{
    
    [[BleCenterManager sharedInstance] bleReceiveData:^(NSData *receiveData, CBCharacteristic *characteristic) {
        
        dfu_control_point_data_t *packet = (dfu_control_point_data_t *) characteristic.value.bytes;
        if (sendStage == 2) {
            [self sendCommandAtStage:sendStage];
            sendStage = 3;
        }else if (sendStage==4){
            if (packet->original == RECEIVE_FIRMWARE_IMAGE) {
                [self sendValidateCommand];
                sendStage = 5;
            }else{
                sendStage = 4;
            }
            [self sendCommandAtStage:sendStage];
        }
    }];
    [[BleCenterManager sharedInstance] bleWriteData:^(CBCharacteristic *characteristic) {
        
        if (sendStage==1) {
            [self sendCommandAtStage:sendStage];
            sendStage = 2;
        }else if (sendStage==3){
            [self sendCommandAtStage:sendStage];
            sendStage = 4;
        }
    }];
}

- (void)sendCommandAtStage:(int)stage{
    
    switch (stage) {
        case 0:
            [self sendNotificationRequest:notificationPacketInterval];
            sendStage = 1;
            break;
        case 1:
            [self sendStartCommand:appSize];
        case 2:
            [self sendReceiveCommand];
            break;
        case 3:
            [self sendFirmwareChunk];
            break;
        case 4:
            [self sendFirmwareChunk];
            break;
        case 5:
            [self sendResetAndActivate];
            break;
        default:
            break;
    }
}

- (void)sendNotificationRequest:(int)interval{
    
    dfu_control_point_data_t data;
    data.opcode = REQUEST_RECEIPT;
    data.n_packets = interval;
    NSData *commandData = [NSData dataWithBytes:&data length:3];
    [[BleCenterManager sharedInstance] writeOTAControlData:commandData WithResponse:YES];
}

- (void)sendStartCommand:(int)firmwareLength{
    
    dfu_control_point_data_t data;
    data.opcode = START_DFU;
    NSData *commandData = [NSData dataWithBytes:&data length:1];
    [[BleCenterManager sharedInstance] writeOTAControlData:commandData WithResponse:YES];
    NSData *sizeData = [NSData dataWithBytes:&firmwareLength length:sizeof(firmwareLength)];
    [[BleCenterManager sharedInstance] writeOTAPacketData:sizeData WithResponse:NO];
}

- (void)sendReceiveCommand{
    
    dfu_control_point_data_t data;
    data.opcode = RECEIVE_FIRMWARE_IMAGE;
    NSData *commandData = [NSData dataWithBytes:&data length:1];
    [[BleCenterManager sharedInstance] writeOTAControlData:commandData WithResponse:YES];
}

- (void) sendFirmwareChunk{
    
    int currentDataSent = 0;
    for (int i = 0; i < notificationPacketInterval && firmwareDataBytesSent < appSize; i++){
        unsigned long length = (appSize - firmwareDataBytesSent) > MAX_PACKET_SIZE ? MAX_PACKET_SIZE : appSize-firmwareDataBytesSent;
        NSRange currentRange = NSMakeRange(firmwareDataBytesSent, length);
        NSData *currentData = [watchFileData subdataWithRange:currentRange];
        [[BleCenterManager sharedInstance] writeOTAPacketData:currentData WithResponse:NO];
        firmwareDataBytesSent += length;
        currentDataSent += length;
    }
    returnProgress(firmwareDataBytesSent*1.0/appSize);
}

- (void) sendValidateCommand{
    
    dfu_control_point_data_t data;
    data.opcode = VALIDATE_FIRMWARE;
    NSData *commandData = [NSData dataWithBytes:&data length:1];
    [[BleCenterManager sharedInstance] writeOTAControlData:commandData WithResponse:YES];
}

- (void) sendResetAndActivate{
    
    dfu_control_point_data_t data;
    data.opcode = ACTIVATE_RESET;
    NSData *commandData = [NSData dataWithBytes:&data length:1];
    [[BleCenterManager sharedInstance] writeOTAControlData:commandData WithResponse:YES];
}
@end
