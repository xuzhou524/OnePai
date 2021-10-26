//
//  XZCameraViewController.m
//  OnePai
//
//  Created by zhouzhou on 2019/4/6.
//  Copyright © 2019年 zhouzhou. All rights reserved.
//

#import "XZCameraViewController+Private.h"

#import "XZCameraViewController.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"

@implementation XZCameraViewController

- (void)dealloc {
    [self removeObserver];
    [self endVideoTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self commonInit];
    
    XZCameraManager *cameraManager = [XZCameraManager shareManager];
    [cameraManager licenseFacepp];
    [cameraManager addOutputView:self.cameraView];
    [cameraManager startCapturing];
    
     [self updateDarkOrNormalModeWithRatio:cameraManager.ratio];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[XZCameraManager shareManager] updateFlash];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[XZCameraManager shareManager] closeFlashIfNeed];
}

#pragma mark - Public

#pragma mark - Private

- (void)commonInit {
    [self setupData];
    [self setupUI];
    [self setupTap];
    [self addObserver];
}

- (void)setupTap {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

- (void)setupData {
    self.videos = [[NSMutableArray alloc] init];
    self.currentVideoScale = 1.0f;
}

- (void)forwardToPhotoResultWith:(UIImage *)image {
    XZPhotoResultViewController *resultVC = [[XZPhotoResultViewController alloc] init];
    resultVC.resultImage = image;
    [self.navigationController pushViewController:resultVC animated:NO];
}

- (void)forwardToVideoResult {
    XZVideoResultViewController *vc = [[XZVideoResultViewController alloc] init];
    vc.videos = self.videos;
    [self.videos removeAllObjects];
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma mark - Custom Accessor

- (NSArray<XZFilterMaterialModel *> *)defaultFilterMaterials {
    if (!_defaultFilterMaterials) {
        _defaultFilterMaterials = [[XZFilterManager shareManager] defaultFilters];
    }
    return _defaultFilterMaterials;
}

- (NSArray<XZFilterMaterialModel *> *)tikTokFilterMaterials {
    if (!_tikTokFilterMaterials) {
        _tikTokFilterMaterials = [[XZFilterManager shareManager] tiktokFilters];
    }
    return _tikTokFilterMaterials;
}

- (NSArray<XZFilterMaterialModel *> *)faceRecognizerFilterMaterials {
    if (!_faceRecognizerFilterMaterials) {
        _faceRecognizerFilterMaterials = [[XZFilterManager shareManager] faceRecognizerFilters];
    }
    return _faceRecognizerFilterMaterials;
}

- (NSArray<XZFilterMaterialModel *> *)splitFilterMaterials {
    if (!_splitFilterMaterials) {
        _splitFilterMaterials = [[XZFilterManager shareManager] splitFilters];
    }
    return _splitFilterMaterials;
}

#pragma mark - Action

- (void)filterAction:(id)sender {
    [self setFilterBarViewHidden:NO
                        animated:YES
                      completion:NULL];
    
    [self refreshUIWhenFilterBarShowOrHide];
    
    // 第一次展开的时候，添加数据
    if (!self.filterBarView.defaultFilterMaterials) {
        self.filterBarView.defaultFilterMaterials = self.defaultFilterMaterials;
    }
}

- (void)nextAction:(id)sender {
    [self forwardToVideoResult];
    [self refreshUIWhenRecordVideo];
}

- (void)tapAction:(UITapGestureRecognizer *)gestureRecognizer {
    [self setFilterBarViewHidden:YES
                        animated:YES
                      completion:NULL];
    
    [self refreshUIWhenFilterBarShowOrHide];
}

- (void)cameraViewTapAction:(UITapGestureRecognizer *)tap {
    if (self.filterBarView.showing) {
        [self tapAction:nil];
        return;
    }
    
    CGPoint location = [tap locationInView:self.cameraView];
    [[XZCameraManager shareManager] setFocusPoint:location];
    [self showFocusViewAtLocation:location];
}

- (void)cameraViewPinchAction:(UIPinchGestureRecognizer *)pinch {
    XZCameraManager *manager = [XZCameraManager shareManager];
    CGFloat scale = pinch.scale * self.currentVideoScale;
    scale = [manager availableVideoScaleWithScale:scale];
    [manager setVideoScale:scale];
    
    if (pinch.state == UIGestureRecognizerStateEnded) {
        self.currentVideoScale = scale;
    }
}

#pragma mark - SCCapturingButtonDelegate

- (void)capturingButtonDidClicked:(SCCapturingButton *)button {
    if (self.modeSwitchView.type == SCCapturingModeSwitchTypeImage) {
        [self takePhoto];
    } else if (self.modeSwitchView.type == SCCapturingModeSwitchTypeVideo) {
        if (self.isRecordingVideo) {
            [self stopRecordVideo];
        } else {
            [self startRecordVideo];
        }
    }
}

#pragma mark - SCFilterBarViewDelegate

- (void)filterBarView:(SCFilterBarView *)filterBarView categoryDidScrollToIndex:(NSUInteger)index {
    if (index == 0 && !self.filterBarView.defaultFilterMaterials) {
        self.filterBarView.defaultFilterMaterials = self.defaultFilterMaterials;
    } else if (index == 1 && !self.filterBarView.tikTokFilterMaterials) {
        self.filterBarView.tikTokFilterMaterials = self.tikTokFilterMaterials;
    } else if (index == 2 && !self.filterBarView.faceRecognizerFilterMaterials) {
        self.filterBarView.faceRecognizerFilterMaterials = self.faceRecognizerFilterMaterials;
    } else if (index == 3 && !self.filterBarView.splitFilterMaterials) {
        self.filterBarView.splitFilterMaterials = self.splitFilterMaterials;
    }
}

- (void)filterBarView:(SCFilterBarView *)filterBarView materialDidScrollToIndex:(NSUInteger)index {
    NSArray<XZFilterMaterialModel *> *models = [self filtersWithCategoryIndex:self.filterBarView.currentCategoryIndex];
    
    XZFilterMaterialModel *model = models[index];
    [[XZCameraManager shareManager].currentFilterHandler setEffectFilter:[[XZFilterManager shareManager] filterWithFilterID:model.filterID]];
}

- (void)filterBarView:(SCFilterBarView *)filterBarView beautifySwitchIsOn:(BOOL)isOn {
    if (isOn) {
        [self addBeautifyFilter];
    } else {
        [self removeBeautifyFilter];
    }
}

- (void)filterBarView:(SCFilterBarView *)filterBarView beautifySliderChangeToValue:(CGFloat)value {
    [XZCameraManager shareManager].currentFilterHandler.beautifyFilterDegree = value;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.filterBarView]) {
        return NO;
    }
    return YES;
}

#pragma mark - SCCameraTopViewDelegate

- (void)cameraTopViewDidClickRotateButton:(SCCameraTopView *)cameraTopView {
    dispatch_async(dispatch_get_main_queue(), ^{
        XZCameraManager *cameraManager = [XZCameraManager shareManager];
        [cameraManager rotateCamera];
        self.currentVideoScale = 1.0f;  // 切换摄像头，重置缩放比例
        // 前置摄像头，禁用闪光灯
        if ([cameraManager isPositionFront]) {
            [self setFlashEnable:NO];
            cameraManager.flashMode = SCCameraFlashModeOff;
            [self updateFlashButtonWithFlashMode:SCCameraFlashModeOff];
        } else {
            [self setFlashEnable:YES];
        }
    });
}

- (void)cameraTopViewDidClickFlashButton:(SCCameraTopView *)cameraTopView {
    SCCameraFlashMode mode = [XZCameraManager shareManager].flashMode;
    mode = (mode + 1) % 4;
    [XZCameraManager shareManager].flashMode = mode;
    [self updateFlashButtonWithFlashMode:mode];
}

- (void)cameraTopViewDidClickRatioButton:(SCCameraTopView *)cameraTopView {
    if (self.isChangingRatio) {
        return;
    }
    self.isChangingRatio = YES;
    
    XZCameraManager *manager =[XZCameraManager shareManager];
    SCCameraRatio ratio = manager.ratio;
    NSInteger ratioCount = [UIDevice is_iPhoneX_Series] ? 4 : 3;
    SCCameraRatio nextRatio = (ratio + 1) % ratioCount;
    
    [self changeViewToRatio:nextRatio animated:YES completion:^{
        manager.ratio = nextRatio;
    }];
    
    [self updateRatioButtonWithRatio:nextRatio];
    [self updateDarkOrNormalModeWithRatio:nextRatio];
}

- (void)cameraTopViewDidClickCloseButton:(SCCameraTopView *)cameraTopView {
    [self.videos removeAllObjects];
    [self refreshUIWhenRecordVideo];
}

- (void)cameraTopViewDidClickSettingButton:(SCCameraTopView *)cameraTopView {
    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:[[XZSettingViewController alloc] init]];
    navigationVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navigationVC
                       animated:YES
                     completion:NULL];
}

#pragma mark - SCCapturingModeSwitchViewDelegate

- (void)capturingModeSwitchView:(SCCapturingModeSwitchView *)view
                didChangeToType:(SCCapturingModeSwitchType)type {
}

@end

#pragma clang diagnostic pop
