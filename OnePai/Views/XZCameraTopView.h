//
//  XZCameraTopView.h
//  OnePai
//
//  Created by zhouzhou on 2019/5/15.
//  Copyright © 2019年 zhouzhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XZCameraTopView;

@protocol XZCameraTopViewDelegate <NSObject>

- (void)cameraTopViewDidClickRotateButton:(XZCameraTopView *)cameraTopView;
- (void)cameraTopViewDidClickFlashButton:(XZCameraTopView *)cameraTopView;
- (void)cameraTopViewDidClickRatioButton:(XZCameraTopView *)cameraTopView;
- (void)cameraTopViewDidClickCloseButton:(XZCameraTopView *)cameraTopView;
- (void)cameraTopViewDidClickSettingButton:(XZCameraTopView *)cameraTopView;

@end

@interface XZCameraTopView : UIView

@property (nonatomic, strong, readonly) UIButton *rotateButton;  // 切换前后置按钮
@property (nonatomic, strong, readonly) UIButton *flashButton;  // 闪光灯按钮
@property (nonatomic, strong, readonly) UIButton *ratioButton;  // 比例按钮
@property (nonatomic, strong, readonly) UIButton *closeButton;  // 关闭按钮
@property (nonatomic, strong, readonly) UIButton *settingButton;  // 设置按钮

@property (nonatomic, weak) id <XZCameraTopViewDelegate> delegate;

@end
