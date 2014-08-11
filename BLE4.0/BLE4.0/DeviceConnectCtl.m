//
//  DeviceConnectCtl.m
//  BLE4.0
//
//  Created by Vincent on 14-8-11.
//  Copyright (c) 2014年 Vicent. All rights reserved.
//

#import "DeviceConnectCtl.h"
#import "BleCenterManager.h"

@interface DeviceConnectCtl (){
    
    NSMutableArray *devices;
}

@end

@implementation DeviceConnectCtl

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
    devices = [[NSMutableArray alloc] initWithCapacity:10];
    [self bleDelegateObjc];
}

- (void)bleDelegateObjc{
    
    [[BleCenterManager sharedInstance] startScan];
    [[BleCenterManager sharedInstance] bleStateOn:^(bleState state) {
        if (state == PoweredOn) {
            NSLog(@"hahah");
        }
    }];
    [[BleCenterManager sharedInstance] bleDidDiscover:^(CBPeripheral *peripheral, NSDictionary *adverDic, NSNumber *rssi) {
        [devices addObject:peripheral];
        NSLog(@"%@",[peripheral name]);
        [self.tableView reloadData];
    }];
    [[BleCenterManager sharedInstance] bleDidConnect:^(CBPeripheral *peripheral) {
        
    }];
    [[BleCenterManager sharedInstance] bleDidDisConnect:^(CBPeripheral *peripheral) {
        
    }];
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
    return [devices count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BLECELL" forIndexPath:indexPath];
    cell.textLabel.text = [(CBPeripheral*)[devices objectAtIndex:indexPath.row] name];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [[BleCenterManager sharedInstance] connectPeripheral:[devices objectAtIndex:indexPath.row]];
}
@end
