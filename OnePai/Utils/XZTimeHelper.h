//
//  XZTimeHelper.h
//  OnePai
//
//  Created by Lyman on 2019/6/3.
//  Copyright © 2019 zhouzhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZTimeHelper : NSObject

/// 将时间戳转化为 12:59:59 格式
+ (NSString *)timeStringWithTimestamp:(NSInteger)timestamp;

@end
