//
//  BleCenterManager.m
//  BleManager
//
//  Created by Vincent on 14-9-14.
//  Copyright (c) 2014年 Vicent. All rights reserved.
//

#import "BleCenterManager.h"

@interface BleCenterManager (){
    
    Services *services;
    BlePeripheralManager *peripheralManager;
    NSMutableArray *foundPeripherals;
}
@property (nonatomic,strong)CBCentralManager *centralManager;
@end

@implementation BleCenterManager
@synthesize centralManager;

+ (id)shareInstance
{
    static BleCenterManager *this;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        this = [[BleCenterManager alloc] init];
    });
    return this;
}

- (id)init
{
    self = [super init];
    if (self) {
        centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
        peripheralManager = [[BlePeripheralManager alloc] init];
        foundPeripherals = [[NSMutableArray alloc] initWithCapacity:10];
        services = [[Services alloc] init];
    }
    return self;
}

#pragma mark - SelfMethod
- (void)startScan:(Block_Periperals)peripherals{
    returnPeripherals = peripherals;
    [self stopScan];
    [foundPeripherals removeAllObjects];
    NSArray	*serviceUUIDs = services.beSearchedServicesUUIDs;
    NSDictionary *scanOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    [centralManager scanForPeripheralsWithServices:serviceUUIDs options:scanOptions];
}

- (void)stopScan{
    [centralManager stopScan];
}

- (void)retriveConnectedPeripherals:(void(^)(NSArray *connectedPeripheral))peripherals{
    peripherals([centralManager retrieveConnectedPeripheralsWithServices:services.beSearchedServicesUUIDs]);
}

- (void)reconnectPeripheral{
    [self retriveConnectedPeripherals:^(NSArray *connectedPeripheral) {
        if (connectedPeripheral.count>0) {
            [centralManager connectPeripheral:connectedPeripheral.firstObject options:nil];
        }else{
            NSArray *periperals;
            if (peripheralManager.LastPeripheralIndetiferStr) {
                periperals = [centralManager retrievePeripheralsWithIdentifiers:@[[CBUUID UUIDWithString:peripheralManager.LastPeripheralIndetiferStr]]];
            }
            if (periperals.firstObject) {
                [centralManager connectPeripheral:periperals.firstObject options:nil];
            }
        }
    }];
}

- (void)connectPeripheral:(CBPeripheral*)peripheral AndSuccess:(void(^)(void))success AndFail:(Block_connectedFail)fail{
    returnConnectedFail = fail;
    [centralManager connectPeripheral:peripheral options:nil];
    [peripheralManager connectedSuccess:^{
        success();
    }];
}

- (void)disConnectPeripheral:(void(^)(CBPeripheral *))peripheral{
    if (peripheralManager.selectedPeripheral) {
        peripheral(peripheralManager.selectedPeripheral);
        [centralManager cancelPeripheralConnection:peripheralManager.selectedPeripheral];
    }
}

- (void)writeData:(NSData *)data WithResponse:(BOOL)response AndResponse:(void(^)(void))responseDescriptor{
    if (response) {
        [peripheralManager writeData:data WithResponse:response AndResponse:^{
            responseDescriptor();
        }];
    }
}

- (void)readCharacteristicValue:(characteristicType)characteristicType AndValue:(void(^)(NSData *))data{
    [peripheralManager readCharacteristicValue:characteristicType AndValue:^(NSData *receiveReadData) {
        data(data);
    }];
}

- (void)receiveNotifyData:(void(^)(NSData *))data{
    [peripheralManager receiveNotifyData:^(NSData *receiveNotifyData) {
        data(receiveNotifyData);
    }];
}

#pragma mark - Blocks
- (void)bleStateOn:(Block_bleState)powerState{
    returnBleState = powerState;
}

- (void)bleCurrentState:(Block_targetBleState)state{
    returnTargetBleState = state;
}

#pragma mark - CenterManagerDelegate
/*!
    @required
 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    bleState state;
    switch ([centralManager state]) {
        case CBCentralManagerStatePoweredOff:
            state = PoweredOff;
            if (returnTargetBleState) {
                returnTargetBleState(Ble_DisConnected);
            }
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

/*!
    @option
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    if (foundPeripherals.count==0) {
        [foundPeripherals addObject:peripheral];
    }else{
        if (![foundPeripherals containsObject:peripheral]) {
            [foundPeripherals addObject:peripheral];
        }
    }
    if (returnPeripherals) {
        returnPeripherals(foundPeripherals);
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    peripheralManager.selectedPeripheral = peripheral;
    if (returnTargetBleState) {
        returnTargetBleState(Ble_Connected);
    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    returnConnectedFail(error);
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    if (returnTargetBleState) {
        returnTargetBleState(Ble_DisConnected);
    }
}
@end
