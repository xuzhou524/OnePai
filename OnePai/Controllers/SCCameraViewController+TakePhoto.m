//
//  SCCameraViewController+TakePhoto.m
//  OnePai
//
//  Created by zhouzhou on 2019/4/6.
//  Copyright © 2019年 zhouzhou. All rights reserved.
//

#import "SCCameraViewController+Private.h"

#import "SCCameraViewController+TakePhoto.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@implementation SCCameraViewController (TakePhoto)

- (void)takePhoto {
    @weakify(self);
    [[SCCameraManager shareManager] takePhotoWtihCompletion:^(UIImage *resultImage,
                                                              NSError *error) {
        @strongify(self);
        [self forwardToPhotoResultWith:resultImage];
    }];
}

@end

#pragma clang diagnostic pop
