//
//  XZCameraViewController+Private.h
//  OnePai
//
//  Created by zhouzhou on 2019/4/6.
//  Copyright © 2019年 zhouzhou. All rights reserved.
//

#import <GPUImage.h>
#import "XZCapturingButton.h"
#import "XZFilterBarView.h"
#import "XZCameraTopView.h"
#import "XZCapturingModeSwitchView.h"
#import "XZVisualEffectView.h"
#import "XZCameraVideoTimeLabel.h"

#import "XZCameraManager.h"
#import "XZFilterManager.h"
#import "XZFilterHandler.h"

#import "XZVideoModel.h"
#import "LFGPUImageBeautyFilter.h"

#import "XZVideoResultViewController.h"
#import "XZPhotoResultViewController.h"
#import "XZSettingViewController.h"

#import "XZCameraViewController.h"

@interface XZCameraViewController () <
    XZCapturingButtonDelegate,
    XZFilterBarViewDelegate,
    XZCameraTopViewDelegate,
    XZCapturingModeSwitchViewDelegate,
    UIGestureRecognizerDelegate>

@property (nonatomic, strong) GPUImageView *cameraView;

@property (nonatomic, strong) XZCapturingButton *capturingButton;
@property (nonatomic, strong) XZFilterBarView *filterBarView;
@property (nonatomic, strong) UIButton *filterButton;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) XZCameraTopView *cameraTopView;
@property (nonatomic, strong) XZCapturingModeSwitchView *modeSwitchView;
@property (nonatomic, strong) XZCameraVideoTimeLabel *videoTimeLabel;
@property (nonatomic, strong) UIView *cameraFocusView;  // 聚焦框
@property (nonatomic, strong) XZVisualEffectView *ratioBlurView;  // 切换比例的时候的模糊蒙层

@property (nonatomic, assign) BOOL isRecordingVideo;  // 是否正在录制视频
@property (nonatomic, assign) BOOL isChangingRatio;  // 是否正在改变比例

@property (nonatomic, strong) NSMutableArray <XZVideoModel *>*videos;

@property (nonatomic, assign) CGFloat currentVideoScale;  // 当前预览屏的缩放倍数，默认1

@property (nonatomic, strong) NSTimer *videoTimer;  // 用于刷新录制中视频的时间

@property (nonatomic, copy) NSArray<XZFilterMaterialModel *> *defaultFilterMaterials;
@property (nonatomic, copy) NSArray<XZFilterMaterialModel *> *tikTokFilterMaterials;
@property (nonatomic, copy) NSArray<XZFilterMaterialModel *> *faceRecognizerFilterMaterials;
@property (nonatomic, copy) NSArray<XZFilterMaterialModel *> *splitFilterMaterials;

#pragma mark - UI

- (void)setupUI;

/// 设置滤镜栏显示或隐藏
- (void)setFilterBarViewHidden:(BOOL)hidden
                      animated:(BOOL)animated
                    completion:(void (^)(void))completion;

/// 在录制视频的时候，刷新UI
- (void)refreshUIWhenRecordVideo;

/// 在滤镜栏显示或隐藏的时候，刷新UI
- (void)refreshUIWhenFilterBarShowOrHide;

/// 刷新闪光灯按钮
- (void)updateFlashButtonWithFlashMode:(SCCameraFlashMode)mode;

/// 刷新比例按钮
- (void)updateRatioButtonWithRatio:(SCCameraRatio)ratio;

/// 刷新黑暗模式或正常模式
- (void)updateDarkOrNormalModeWithRatio:(SCCameraRatio)ratio;

/// 显示聚焦框
- (void)showFocusViewAtLocation:(CGPoint)location;

/// 修改控件的比例
- (void)changeViewToRatio:(SCCameraRatio)ratio
                 animated:(BOOL)animated
               completion:(void (^)(void))completion;

/// 设置闪光灯功能是否可用
- (void)setFlashEnable:(BOOL)enable;

#pragma mark - Action

- (void)filterAction:(id)sender;

#pragma mark - Filter

/// 添加美颜滤镜
- (void)addBeautifyFilter;

/// 移除美颜滤镜
- (void)removeBeautifyFilter;

/// 根据分类索引，获取滤镜列表
- (NSArray<XZFilterMaterialModel *> *)filtersWithCategoryIndex:(NSInteger)index;

#pragma mark - TakePhoto

- (void)takePhoto;

#pragma mark - RecordVideo

- (void)startRecordVideo;

- (void)stopRecordVideo;

- (void)startVideoTimer;

- (void)endVideoTimer;

#pragma mark - Notification

/**
 添加监听
 */
- (void)addObserver;

/**
 移除监听
 */
- (void)removeObserver;

#pragma mark - Forward

/**
 跳转到图片拍后
 */
- (void)forwardToPhotoResultWith:(UIImage *)image;

/**
 跳转到视频拍后
 */
- (void)forwardToVideoResult;

@end
