//
//  XZSettingModel.m
//  OnePai
//
//  Created by zhouzhou on 2019/7/27.
//  Copyright © 2019年 zhouzhou. All rights reserved.
//

#import "XZSettingModel.h"

@implementation XZSettingModel

- (void)setIsSwitchOn:(BOOL)isSwitchOn {
    _isSwitchOn = isSwitchOn;
    
    if (self.switchChangedAction) {
        self.switchChangedAction(isSwitchOn);
    }
}

@end
