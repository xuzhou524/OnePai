//
//  UIView+Extention.h
//  OnePai
//
//  Created by zhouzhou on 2019/5/18.
//  Copyright © 2019年 zhouzhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extention)

/**
 设置显示隐藏
 */
- (void)setHidden:(BOOL)hidden animated:(BOOL)animated completion:(void (^)(void))completion;

/**
 设置阴影
 */
- (void)setShadowWithColor:(UIColor *)color alpah:(CGFloat)alpha radius:(CGFloat)radius offset:(CGSize)offset;

/**
 设置默认阴影
 */
- (void)setDefaultShadow;

/**
 清除阴影
 */
- (void)clearShadow;

@end
