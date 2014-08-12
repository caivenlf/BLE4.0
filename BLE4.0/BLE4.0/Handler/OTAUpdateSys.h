//
//  OTAUpdateSys.h
//  BLE4.0
//
//  Created by Vincent on 14-8-12.
//  Copyright (c) 2014年 Vicent. All rights reserved.
//


typedef struct __attribute__((packed)){
    uint8_t opcode;
    union{
        uint16_t n_packets;
        struct __attribute__((packed)){
            uint8_t   original;
            uint8_t   response;
        };
        uint32_t n_bytes;
    };
} dfu_control_point_data_t;

typedef enum{
    START_DFU = 0x01,RECEIVE_FIRMWARE_IMAGE = 0x03,REQUEST_RECEIPT = 0x08
}Opcode;

#import <Foundation/Foundation.h>
#import "BleCenterManager.h"

@interface OTAUpdateSys : NSObject

+ (id)shareInstance;
- (void)getStart;

@end
