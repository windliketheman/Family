//
//  SettingTableViewCell+Password.h
//  Family
//
//  Created by jia on 15/9/23.
//  Copyright © 2015年 jia. All rights reserved.
//

#import "SettingTableViewCell.h"

typedef NS_ENUM(NSInteger, SettingCellPasswordType)
{
    SettingCellPasswordTypeNone = 0,
    SettingCellPasswordSwitch,
    SettingCellPasswordTouchID,
    SettingCellPasswordModify,
    SettingCellPasswordFind,
};

@interface SettingTableViewCell (Password)

@property (nonatomic, readwrite) SettingCellPasswordType passwordType;

@end
