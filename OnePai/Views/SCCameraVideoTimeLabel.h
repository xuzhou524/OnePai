//
//  SCCameraVideoTimeLabel.h
//  OnePai
//
//  Created by Lyman on 2019/6/3.
//  Copyright © 2019 zhouzhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCCameraVideoTimeLabel : UIView

@property (nonatomic, assign) NSInteger timestamp;
@property (nonatomic, assign) BOOL isDarkMode;

// 重置时间
- (void)resetTime;

@end

