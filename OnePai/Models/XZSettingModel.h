//
//  XZSettingModel.h
//  OnePai
//
//  Created by zhouzhou on 2019/7/27.
//  Copyright © 2019年 zhouzhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZSettingModel : NSObject

@property (nonatomic, strong) NSString *modelID;
@property (nonatomic, strong) NSString *modelTitle;
@property (nonatomic, assign) BOOL isSwitchOn;

@property (nonatomic, copy) void (^switchChangedAction)(BOOL isOn);

@end
