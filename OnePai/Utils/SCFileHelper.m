//
//  SCFileHelper.m
//  OnePai
//
//  Created by zhouzhou on 2019/5/18.
//  Copyright © 2019年 zhouzhou. All rights reserved.
//

#import "SCFileHelper.h"

@implementation SCFileHelper

#pragma mark - Public

+ (NSString *)temporaryDirectory {
    return NSTemporaryDirectory();
}

+ (NSString *)filePathInTmpWithName:(NSString *)name {
    return [[self temporaryDirectory] stringByAppendingPathComponent:name];
}

+ (NSString *)randomFilePathInTmpWithSuffix:(NSString *)suffix {
    long random = [[NSDate date] timeIntervalSince1970] * 1000;
    return [[self filePathInTmpWithName:[NSString stringWithFormat:@"%ld", random]] stringByAppendingString:suffix];
}

@end
