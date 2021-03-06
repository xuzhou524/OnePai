//
//  XZGPUImageBaseFilter.h
//  OnePai
//
//  Created by zhouzhou on 2019/6/1.
//  Copyright © 2019年 zhouzhou. All rights reserved.
//

#import "GPUImageFilter.h"

@interface XZGPUImageBaseFilter : GPUImageFilter

@property (nonatomic, assign) GLint timeUniform;
@property (nonatomic, assign) CGFloat time;

@property (nonatomic, assign) CGFloat beginTime;  // 滤镜开始应用的时间

@property (nonatomic, assign) GLfloat *facesPoints;
@property (nonatomic, assign) int facesPointCount;

/// 封面图片名称，如果非nil，则用改图片，否则用滤镜来生成
- (NSString *)coverImageName;

@end
