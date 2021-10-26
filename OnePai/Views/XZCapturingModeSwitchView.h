//
//  XZCapturingModeSwitchView.h
//  OnePai
//
//  Created by zhouzhou on 2019/5/18.
//  Copyright © 2019年 zhouzhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, XZCapturingModeSwitchType) {
    XZCapturingModeSwitchTypeImage,
    XZCapturingModeSwitchTypeVideo
};

@class XZCapturingModeSwitchView;

@protocol XZCapturingModeSwitchViewDelegate <NSObject>

- (void)capturingModeSwitchView:(XZCapturingModeSwitchView *)view
                didChangeToType:(XZCapturingModeSwitchType)type;

@end

@interface XZCapturingModeSwitchView : UIView

@property (nonatomic, assign, readonly) XZCapturingModeSwitchType type;

@property (nonatomic, assign) BOOL isDarkMode;

@property (nonatomic, weak) id <XZCapturingModeSwitchViewDelegate> delegate;

@end
