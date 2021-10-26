//
//  XZGPUImageSplit3V2Filter.m
//  OnePai
//
//  Created by zhouzhou on 2019/11/9.
//  Copyright © 2019 zhouzhou. All rights reserved.
//

#import "XZGPUImageSplit3V2Filter.h"

@implementation XZGPUImageSplit3V2Filter

- (instancetype)init {
    self = [super init];
    if (self) {
        self.horizontal = 3.0;
        self.vertical = 2.0;
    }
    return self;
}

@end
