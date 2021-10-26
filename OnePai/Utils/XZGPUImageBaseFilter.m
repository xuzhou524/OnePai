//
//  XZGPUImageBaseFilter.m
//  OnePai
//
//  Created by zhouzhou on 2019/6/1.
//  Copyright © 2019年 zhouzhou. All rights reserved.
//

#import "XZGPUImageBaseFilter.h"

@implementation XZGPUImageBaseFilter

- (id)initWithVertexShaderFromString:(NSString *)vertexShaderString
            fragmentShaderFromString:(NSString *)fragmentShaderString {
    self = [super initWithVertexShaderFromString:vertexShaderString
                        fragmentShaderFromString:fragmentShaderString];
    self.timeUniform = [filterProgram uniformIndex:@"time"];
    self.time = 0.0f;
    self.facesPoints = 0;
    self.facesPointCount = 0;
    
    return self;
}

- (void)setTime:(CGFloat)time {
    _time = time;
    
    [self setFloat:time forUniform:self.timeUniform program:filterProgram];
}

-(NSString *)coverImageName {
    return nil;
}

@end
