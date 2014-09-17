//
//  BleTableViewCtl.m
//  BleManager
//
//  Created by Vincent on 14-9-15.
//  Copyright (c) 2014年 Vicent. All rights reserved.
//

#import "BleTableViewCtl.h"
#import "BleCenterManager.h"
#import "BleCell.h"
@interface BleTableViewCtl (){
    NSMutableArray *blePeripherals;
}

@end

@implementation BleTableViewCtl

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[BleCenterManager shareInstance] reconnectPeripheral];
    blePeripherals = [[NSMutableArray alloc] initWithCapacity:10];
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    [self.refreshControl addTarget:self action:@selector(RefreshViewControlEventValueChanged) forControlEvents:UIControlEventValueChanged];
    [[BleCenterManager shareInstance] startScan:^(NSArray *peripherals) {
        [blePeripherals removeAllObjects];
        [[BleCenterManager shareInstance] retriveConnectedPeripherals:^(NSArray *connectedPeripheral) {
            if (connectedPeripheral.count>0) {
                [blePeripherals insertObject:connectedPeripheral.firstObject atIndex:0];
            }
        }];
        [blePeripherals addObjectsFromArray:peripherals];
        [self.tableView reloadData];
    }];
    
    [[BleCenterManager shareInstance] receiveNotifyData:^(NSData *receiveNotifyData) {
        NSLog(@"%@",receiveNotifyData);
    }];
    [[BleCenterManager shareInstance] bleCurrentState:^(targetBleState type) {
        if (type==Ble_Connected) {
            NSLog(@"Connected Success");
        }else if (type==Ble_DisConnected){
            NSLog(@"DisConnected");
            [[BleCenterManager shareInstance] reconnectPeripheral];
        }
    }];
    
    [[BleCenterManager shareInstance] bleStateOn:^(bleState state) {
        if (state==PoweredOn) {
            [[BleCenterManager shareInstance] reconnectPeripheral];
        }
    }];
}

- (void)RefreshViewControlEventValueChanged{
//        [[BleCenterManager shareInstance] startScan:^(NSArray *peripherals) {
//            blePeripherals = [NSArray arrayWithArray:peripherals];
//            [self.tableView reloadData];
//        }];
//    [self.refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [blePeripherals count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BLECELL" forIndexPath:indexPath];
    cell.bleName.text = [(CBPeripheral *)[blePeripherals objectAtIndex:indexPath.row] name];
    cell.bleRssi.text = [NSString stringWithFormat:@"%ld",[[(CBPeripheral *)[blePeripherals objectAtIndex:indexPath.row] RSSI] integerValue]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [[BleCenterManager shareInstance] connectPeripheral:[blePeripherals objectAtIndex:indexPath.row] AndSuccess:^{
        [[BleCenterManager shareInstance] readCharacteristicValue:TimeCharacteristicType AndValue:^(NSData *receiveReadData) {
            NSLog(@"TimeValue->%@",receiveReadData);
        }];
        NSLog(@"Success");
    } AndFail:^(NSError *error) {
        NSLog(@"Fail");
    }];
}

@end
