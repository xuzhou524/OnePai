//
//  XZSettingCell.h
//  OnePai
//
//  Created by zhouzhou on 2019/7/27.
//  Copyright © 2019年 zhouzhou. All rights reserved.
//

#import "XZSettingModel.h"

#import <UIKit/UIKit.h>

@class XZSettingCell;

@protocol XZSettingCellDelegate <NSObject>

- (void)settingCell:(XZSettingCell *)settingCell didChangedWithModel:(XZSettingModel *)model;

@end

@interface XZSettingCell : UITableViewCell

@property (nonatomic, strong) XZSettingModel *model;
@property (nonatomic, weak) id <XZSettingCellDelegate> delegate;

- (void)setOn:(BOOL)isOn;
- (BOOL)isOn;

@end
