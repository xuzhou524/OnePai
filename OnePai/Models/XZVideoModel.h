//
//  XZVideoModel.h
//  OnePai
//
//  Created by zhouzhou on 2019/5/18.
//  Copyright © 2019年 zhouzhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface XZVideoModel : NSObject

@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, strong) AVURLAsset *asset;

@end
