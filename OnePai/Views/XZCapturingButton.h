//
//  XZCapturingButton.h
//  OnePai
//
//  Created by zhouzhou on 2019/4/6.
//  Copyright © 2019年 zhouzhou. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 按钮状态

 - XZCapturingButtonStateNormal: 默认
 - XZCapturingButtonStateRecording: 录制中
 */
typedef NS_ENUM(NSUInteger, XZCapturingButtonState) {
    XZCapturingButtonStateNormal,
    XZCapturingButtonStateRecording,
};

@class XZCapturingButton;

@protocol XZCapturingButtonDelegate <NSObject>

/**
 拍照按钮被点击
 */
- (void)capturingButtonDidClicked:(XZCapturingButton *)button;

@end

@interface XZCapturingButton : UIButton

@property (nonatomic, assign) XZCapturingButtonState capturingState;
@property (nonatomic, weak) id <XZCapturingButtonDelegate> delegate;

@end
