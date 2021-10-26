//
//  XZFilterHandler.h
//  OnePai
//
//  Created by zhouzhou on 2019/5/25.
//  Copyright © 2019年 zhouzhou. All rights reserved.
//

#import <GPUImage.h>

#import <Foundation/Foundation.h>

@interface XZFilterHandler : NSObject

/// 设置美颜滤镜是否可用
@property (nonatomic, assign) BOOL beautifyFilterEnable;

/// 美颜滤镜的程度，0～1，默认 0.5，当 beautifyFilterEnable 为 YES 的时候，设置才有效
@property (nonatomic, assign) CGFloat beautifyFilterDegree;

/// 滤镜链源头
@property (nonatomic, weak) GPUImageOutput *source;

/// 人脸点
@property (nonatomic, assign) GLfloat *facesPoints;

/// 人脸点个数
@property (nonatomic, assign) int facesPointCount;

/// 滤镜链第一个滤镜
- (GPUImageFilter *)firstFilter;

/// 滤镜链最后一个滤镜
- (GPUImageFilter *)lastFilter;

/// 设置裁剪比例，用于设置特殊的相机比例
- (void)setCropRect:(CGRect)rect;

/// 往末尾添加一个滤镜
- (void)addFilter:(GPUImageFilter *)filter;

/// 设置效果滤镜
- (void)setEffectFilter:(GPUImageFilter *)filter;

@end
