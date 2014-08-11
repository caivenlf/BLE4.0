//
//  BleManager.m
//  UpdateTool
//
//  Created by Vincent on 14/8/10.
//  Copyright (c) 2014年 Vicent. All rights reserved.
//

#import "BleCenterManager.h"

@interface BleCenterManager(){
    
    PeripheralManager *perpheralManager;
}
@end

@implementation BleCenterManager
@synthesize centralManager;

+ (id)sharedInstance{
    
    static BleCenterManager *this;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        this = [[BleCenterManager alloc] init];
    });
    return this;
}

- (id)init{
    
    self = [super init];
    if (self) {
        centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    }
    return self;
}

#pragma mark - Self Method
- (void)startScan{
    
    NSArray	*serviceUUIDs=[ServicesManager getTargetServiceUUID];
    NSDictionary *scanOptions= [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    [centralManager scanForPeripheralsWithServices:serviceUUIDs options:scanOptions];
}

- (void)stopScan{
    
    [centralManager stopScan];
}

-(void)connectPeripheral:(CBPeripheral*)peripheral{
    
    [centralManager connectPeripheral:peripheral options:nil];
}

- (void)disConnectPeripheral{
    if (perpheralManager.selectedPeripheral) {
        [centralManager cancelPeripheralConnection:perpheralManager.selectedPeripheral];
    }
}

#pragma mark - Bluetooth Delegate
//bluetoothCenterManger's delegate required
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
    switch ([centralManager state]) {
        case CBCentralManagerStatePoweredOff:
            returnBleState(PoweredOff);
            break;
        case CBCentralManagerStatePoweredOn:
            returnBleState(PoweredOn);
            break;
        case CBCentralManagerStateUnsupported:
            returnBleState(Unsupported);
            break;
        case CBCentralManagerStateUnauthorized:
            returnBleState(Unauthorized);
            break;
        case CBCentralManagerStateUnknown:
            returnBleState(Unknown);
            break;
        case CBCentralManagerStateResetting:
            returnBleState(Resetting);
            break;
        default:
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    returnBleDidDiscover(peripheral,advertisementData,RSSI);
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    returnBleDidConnect(peripheral);
    perpheralManager = [[PeripheralManager alloc] init];
    perpheralManager.selectedPeripheral = peripheral;
    [perpheralManager startDiscoverService];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    returnBleDidDisConnect(peripheral);
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    returnBleDidFailConnect(peripheral);
}

/**
 *      @para   Blocks ->Required
 */
- (void)bleStateOn:(Block_blePowerState)powerState{
    returnBleState = powerState;
}
- (void)bleDidConnect:(Block_bleDidConnect)didConnect{
    returnBleDidConnect = didConnect;
}
- (void)bleDidDisConnect:(Block_bleDidDisConnect)didDisConnect{
    returnBleDidDisConnect = didDisConnect;
}
- (void)bleDidFailConnect:(Block_bleDidFailConnect)didFailConnect{
    returnBleDidFailConnect = didFailConnect;
}
- (void)bleDidDiscover:(Block_bleDidDiscover)didDiscover{
    returnBleDidDiscover = didDiscover;
}

@end
