//
//  XZCameraViewController+TakePhoto.m
//  OnePai
//
//  Created by zhouzhou on 2019/4/6.
//  Copyright © 2019年 zhouzhou. All rights reserved.
//

#import "XZCameraViewController+Private.h"

#import "XZCameraViewController+TakePhoto.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@implementation XZCameraViewController (TakePhoto)

- (void)takePhoto {
    @weakify(self);
    [[XZCameraManager shareManager] takePhotoWtihCompletion:^(UIImage *resultImage,
                                                              NSError *error) {
        @strongify(self);
        [self forwardToPhotoResultWith:resultImage];
    }];
}

@end

#pragma clang diagnostic pop
