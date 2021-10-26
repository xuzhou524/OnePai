//
//  XZCameraViewController+RecordVideo.m
//  OnePai
//
//  Created by zhouzhou on 2019/5/18.
//  Copyright © 2019年 zhouzhou. All rights reserved.
//

#import "XZCameraViewController+Private.h"
#import "XZCameraViewController+RecordVideo.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@implementation XZCameraViewController (RecordVideo)

#pragma mark - Public

- (void)startRecordVideo {
    if (self.isRecordingVideo) {
        return;
    }
    self.capturingButton.capturingState = SCCapturingButtonStateRecording;
    self.isRecordingVideo = YES;
    
    [[XZCameraManager shareManager] recordVideo];
    [self startVideoTimer];
    
    [self refreshUIWhenRecordVideo];
}

- (void)stopRecordVideo {
    if (!self.isRecordingVideo) {
        return;
    }
    self.capturingButton.capturingState = SCCapturingButtonStateNormal;
    @weakify(self);
    [[XZCameraManager shareManager] stopRecordVideoWithCompletion:^(NSString *videoPath) {
        @strongify(self);
        
        self.isRecordingVideo = NO;
        
        AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:videoPath]];
        XZVideoModel *videoModel = [[XZVideoModel alloc] init];
        videoModel.filePath = videoPath;
        videoModel.asset = asset;
        [self.videos addObject:videoModel];
        
        [self endVideoTimer];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshUIWhenRecordVideo];
        });
    }];
}

- (void)startVideoTimer {
    self.videoTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(videoTimerAction) userInfo:nil repeats:YES];
    [self.videoTimer fire];
}

- (void)endVideoTimer {
    [self.videoTimer invalidate];
    self.videoTimer = nil;
}

#pragma mark - Action

- (void)videoTimerAction {
    CMTime savedTime = kCMTimeZero;
    for (XZVideoModel *model in self.videos) {
        savedTime = CMTimeAdd(savedTime, model.asset.duration);
    }
    NSInteger timestamp = round(CMTimeGetSeconds(savedTime) + [XZCameraManager shareManager].currentDuration);
    self.videoTimeLabel.timestamp = timestamp;
}

@end

#pragma clang diagnostic pop
