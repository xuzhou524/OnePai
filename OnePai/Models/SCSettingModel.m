//
//  SCSettingModel.m
//  OnePai
//
//  Created by zhouzhou on 2019/7/27.
//  Copyright © 2019年 zhouzhou. All rights reserved.
//

#import "SCSettingModel.h"

@implementation SCSettingModel

- (void)setIsSwitchOn:(BOOL)isSwitchOn {
    _isSwitchOn = isSwitchOn;
    
    if (self.switchChangedAction) {
        self.switchChangedAction(isSwitchOn);
    }
}

@end
