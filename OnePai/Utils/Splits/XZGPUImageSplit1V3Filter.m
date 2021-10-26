//
//  XZGPUImageSplit1V3Filter.m
//  OnePai
//
//  Created by zhouzhou on 2019/11/9.
//  Copyright © 2019 zhouzhou. All rights reserved.
//

#import "XZGPUImageSplit1V3Filter.h"

@implementation XZGPUImageSplit1V3Filter

- (instancetype)init {
    self = [super init];
    if (self) {
        self.horizontal = 1.0;
        self.vertical = 3.0;
    }
    return self;
}

@end
