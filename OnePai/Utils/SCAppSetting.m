//
//  SCAppSetting.m
//  OnePai
//
//  Created by zhouzhou on 2019/7/27.
//  Copyright © 2019年 zhouzhou. All rights reserved.
//

#import "SCAppSetting.h"

static NSString * const kUsingFaceppEngine = @"kUsingFaceppEngine";

@implementation SCAppSetting

#pragma mark - Public

+ (void)setUsingFaceppEngine:(BOOL)isUsingFaceppEngine {
    [[NSUserDefaults standardUserDefaults] setBool:isUsingFaceppEngine
                                            forKey:kUsingFaceppEngine];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isUsingFaceppEngine {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kUsingFaceppEngine];
}

+ (BOOL)hasSaveFaceDetectEngine {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUsingFaceppEngine];
}

@end
