//
//  PeripheralManager.m
//  BLE4.0
//
//  Created by Vincent on 14-8-11.
//  Copyright (c) 2014年 Vicent. All rights reserved.
//

#import "PeripheralManager.h"
#import "ServicesManager.h"
#import "PeripheralManager.h"

@interface PeripheralManager(){
  
    ServicesManager *serviceManager;
    PeripheralManager *peripheralManager;
}
@end

@implementation PeripheralManager
@synthesize selectedPeripheral;

- (id)init{
    
    self = [super init];
    if (self) {
        
        peripheralManager = [[PeripheralManager alloc] init];
    }
    return self;
}

- (void)startDiscoverService{
    
    
    serviceManager = [[ServicesManager alloc] init];
    [[serviceManager useableServices] removeAllObjects];
    [selectedPeripheral setDelegate:self];
    [selectedPeripheral discoverServices:nil];
}

- (void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    
    [[serviceManager useableServices] addObjectsFromArray:[peripheral services]];
    for (CBService *curService in [serviceManager useableServices]){
        [peripheral discoverCharacteristics:nil forService:curService];
    }
}

- (void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    
}
@end
