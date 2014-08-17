//
//  BleManager.m
//  UpdateTool
//
//  Created by Vincent on 14/8/10.
//  Copyright (c) 2014年 Vicent. All rights reserved.
//

#import "BleCenterManager.h"
#import "BleConfig.h"

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
    if (perpheralManager.selectedPeripheral) {
        [centralManager cancelPeripheralConnection:perpheralManager.selectedPeripheral];
    }
    [centralManager connectPeripheral:peripheral options:nil];
}

- (void)connectRetrivePeripheral{
    CBPeripheral *peripheral = [perpheralManager reReviewPeripheral:[centralManager retrieveConnectedPeripheralsWithServices:[BleConfig searchServiceUUIDs]]];
    if (peripheral) {
        [centralManager connectPeripheral:peripheral options:nil];
    }
}

- (void)disConnectPeripheral{
    if (perpheralManager.selectedPeripheral) {
        [centralManager cancelPeripheralConnection:perpheralManager.selectedPeripheral];
    }
}

- (void)writeData:(NSData *)data WithResponse:(BOOL)response{
    
    [perpheralManager writeData:data WithResponse:response];
}

- (void)writeOTAControlData:(NSData *)data WithResponse:(BOOL)response{
    
    [perpheralManager writeOTAControlData:data WithResponse:response];
}

- (void)writeOTAPacketData:(NSData *)data WithResponse:(BOOL)response{
    
    [perpheralManager writeOTAPacketData:data WithResponse:response];
}

- (void)readValue:(characteristicType)type{
    
    [perpheralManager readCharacteristic:type];
}

#pragma mark - Bluetooth Delegate
//bluetoothCenterManger's delegate required
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    bleState state;
    switch ([centralManager state]) {
        case CBCentralManagerStatePoweredOff:
            state = PoweredOff;
            break;
        case CBCentralManagerStatePoweredOn:
            state = PoweredOn;
            break;
        case CBCentralManagerStateUnsupported:
            state = Unsupported;
            break;
        case CBCentralManagerStateUnauthorized:
            state = Unauthorized;
            break;
        case CBCentralManagerStateUnknown:
            state = Unknown;
            break;
        case CBCentralManagerStateResetting:
            state = Resetting;
            break;
        default:
            state = Other;
            break;
    }
    if (returnBleState) {
        returnBleState(state);
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    if (returnBleDidDiscover) {
        returnBleDidDiscover(peripheral,advertisementData,RSSI);
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    [[NSUserDefaults standardUserDefaults]setObject:[peripheral name] forKey:LastPeripheraName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    perpheralManager = [[PeripheralManager alloc] init];
    perpheralManager.selectedPeripheral = peripheral;
    [perpheralManager startDiscoverService];
    if (returnBleDidConnect) {
        returnBleDidConnect(peripheral);
    }
    [self blePeripheralBlocks:perpheralManager];
}

- (void)blePeripheralBlocks:(PeripheralManager *)peripheralMan{
    
    [perpheralManager bleReceiveData:^(NSData *receiveData, CBCharacteristic *characteristic) {
        if (returnBleReceiveData) {
            returnBleReceiveData(receiveData,characteristic);
        }
    }];
    [perpheralManager bleWriteData:^(CBCharacteristic *characteristic) {
        if (returnbleWriteData) {
            returnbleWriteData(characteristic);
        }
    }];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    if (returnBleDidDisConnect) {
        returnBleDidDisConnect(peripheral);
    }
    [self connectPeripheral:perpheralManager.selectedPeripheral];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    if (returnBleDidFailConnect) {
        returnBleDidFailConnect(peripheral);
    }
}

#pragma mark - Blocks
/**
 *      @para   Blocks
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

- (void)bleReceiveData:(Block_receiveData)receiveData{
    returnBleReceiveData = receiveData;
}
- (void)bleWriteData:(Block_writeData)writeData{
    returnbleWriteData = writeData;
}

@end
