//
//  SCFilterBarView.h
//  OnePai
//
//  Created by zhouzhou on 2019/4/13.
//  Copyright © 2019年 zhouzhou. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SCFilterMaterialModel.h"

@class SCFilterBarView;

@protocol SCFilterBarViewDelegate <NSObject>

- (void)filterBarView:(SCFilterBarView *)filterBarView categoryDidScrollToIndex:(NSUInteger)index;
- (void)filterBarView:(SCFilterBarView *)filterBarView materialDidScrollToIndex:(NSUInteger)index;
- (void)filterBarView:(SCFilterBarView *)filterBarView beautifySwitchIsOn:(BOOL)isOn;
- (void)filterBarView:(SCFilterBarView *)filterBarView beautifySliderChangeToValue:(CGFloat)value;

@end

@interface SCFilterBarView : UIView

@property (nonatomic, assign) BOOL showing;
@property (nonatomic, weak) id <SCFilterBarViewDelegate> delegate;

/// 内置滤镜
@property (nonatomic, copy) NSArray<SCFilterMaterialModel *> *defaultFilterMaterials;

/// 抖音滤镜
@property (nonatomic, copy) NSArray<SCFilterMaterialModel *> *tikTokFilterMaterials;

/// 人脸识别滤镜
@property (nonatomic, copy) NSArray<SCFilterMaterialModel *> *faceRecognizerFilterMaterials;

/// 分屏滤镜
@property (nonatomic, copy) NSArray<SCFilterMaterialModel *> *splitFilterMaterials;

- (NSInteger)currentCategoryIndex;

@end
