//
//  SCGPUImageStaticSplitFilter.h
//  OnePai
//
//  Created by zhouzhou on 2019/11/9.
//  Copyright © 2019 zhouzhou. All rights reserved.
//

#import "SCGPUImageBaseFilter.h"

@interface SCGPUImageStaticSplitFilter : SCGPUImageBaseFilter

/// 水平分割数，默认 2.0，最小 1.0
@property (nonatomic, assign) CGFloat horizontal;

/// 竖直分割数，默认 2.0，最小 1.0
@property (nonatomic, assign) CGFloat vertical;

@end
