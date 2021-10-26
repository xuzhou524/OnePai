//
//  XZFilterManager.h
//  OnePai
//
//  Created by zhouzhou on 2019/4/13.
//  Copyright © 2019年 zhouzhou. All rights reserved.
//

#import <GPUImage.h>

#import <Foundation/Foundation.h>

#import "XZFilterMaterialModel.h"

@interface XZFilterManager : NSObject

/// GPUImage 自带滤镜列表
@property (nonatomic, strong, readonly) NSArray<XZFilterMaterialModel *> *defaultFilters;
/// 抖音滤镜列表
@property (nonatomic, strong, readonly) NSArray<XZFilterMaterialModel *> *tiktokFilters;
/// 人脸识别滤镜列表
@property (nonatomic, strong, readonly) NSArray<XZFilterMaterialModel *> *faceRecognizerFilters;
/// 分屏滤镜列表
@property (nonatomic, strong, readonly) NSArray<XZFilterMaterialModel *> *splitFilters;

/**
 获取实例
 */
+ (XZFilterManager *)shareManager;

/**
 通过滤镜 ID 返回滤镜对象
 */
- (GPUImageFilter *)filterWithFilterID:(NSString *)filterID;

@end
