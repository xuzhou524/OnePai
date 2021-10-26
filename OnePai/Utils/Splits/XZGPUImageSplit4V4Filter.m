//
//  XZGPUImageSplit4V4Filter.m
//  OnePai
//
//  Created by zhouzhou on 2019/11/9.
//  Copyright © 2019 zhouzhou. All rights reserved.
//

#import "XZGPUImageSplit4V4Filter.h"

@implementation XZGPUImageSplit4V4Filter

- (instancetype)init {
    self = [super init];
    if (self) {
        self.horizontal = 4.0;
        self.vertical = 4.0;
    }
    return self;
}

@end
