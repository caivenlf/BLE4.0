//
//  BleCell.h
//  BleManager
//
//  Created by Vincent on 14-9-15.
//  Copyright (c) 2014年 Vicent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *bleName;
@property (weak, nonatomic) IBOutlet UILabel *bleRssi;
@property (weak, nonatomic) IBOutlet UILabel *bleState;

@end
