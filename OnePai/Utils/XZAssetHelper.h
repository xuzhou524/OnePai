//
//  XZAssetHelper.h
//  OnePai
//
//  Created by zhouzhou on 2019/5/25.
//  Copyright © 2019年 zhouzhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZAssetHelper : NSObject

/// 获取视频的第一帧
+ (UIImage *)videoPreviewImageWithURL:(NSURL *)url;

/// 合并视频
+ (void)mergeVideos:(NSArray *)videoPaths toExportPath:(NSString *)exportPath completion:(void (^)(void))completion;

@end
