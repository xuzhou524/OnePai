//
//  UIView+Extention.m
//  OnePai
//
//  Created by zhouzhou on 2019/5/18.
//  Copyright © 2019年 zhouzhou. All rights reserved.
//

#import "UIView+Extention.h"

@implementation UIView (Extention)

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated completion:(void (^)(void))completion {
    CGFloat beginAlpha = self.alpha;
    CGFloat endAlpha = hidden ? 0 : 1;
    if (beginAlpha == endAlpha) {
        if (completion) {
            completion();
        }
        return;
    }
    
    if (!animated) {
        self.alpha = endAlpha;
        if (completion) {
            completion();
        }
        return;
    }
    
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = endAlpha;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

- (void)setShadowWithColor:(UIColor *)color alpah:(CGFloat)alpha radius:(CGFloat)radius offset:(CGSize)offset {
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOpacity = alpha;
    self.layer.shadowRadius = radius;
    self.layer.shadowOffset = offset;
}

- (void)setDefaultShadow {
    [self setShadowWithColor:[UIColor blackColor]
                       alpah:0.4
                      radius:2.0
                      offset:CGSizeMake(0, 0)];
}

- (void)clearShadow {
    [self setShadowWithColor:[UIColor clearColor]
                       alpah:0
                      radius:0
                      offset:CGSizeZero];
}

@end
