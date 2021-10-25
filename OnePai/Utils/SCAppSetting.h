//
//  SCAppSetting.h
//  OnePai
//
//  Created by zhouzhou on 2019/7/27.
//  Copyright © 2019年 zhouzhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCAppSetting : NSObject

/// 设置是否使用 Face++ 引擎
+ (void)setUsingFaceppEngine:(BOOL)isUsingFaceppEngine;
/// 是否使用 Face++ 引擎
+ (BOOL)isUsingFaceppEngine;

/// 本地是否保存了使用哪个人脸识别引擎，用于在第一次启动的时候，设置默认值
+ (BOOL)hasSaveFaceDetectEngine;

@end
