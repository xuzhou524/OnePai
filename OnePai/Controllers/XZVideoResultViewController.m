//
//  XZVideoResultViewController.m
//  OnePai
//
//  Created by zhouzhou on 2019/5/18.
//  Copyright © 2019年 zhouzhou. All rights reserved.
//

#import "XZVideoResultViewController+Private.h"
#import "XZVideoResultViewController.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"

@implementation XZVideoResultViewController

- (void)dealloc {
    [self stopVideo];
    
    [[GPUImageContext sharedImageProcessingContext].framebufferCache purgeAllUnassignedFramebuffers];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self commonInit];
    [self showPreview];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self playVideoWithIndex:self.currentVideoIndex];
    });
}

#pragma mark - Private

- (void)commonInit {
    [self setupUI];
    self.currentVideoIndex = 0;
}

/// 显示视频预览
- (void)showPreview {
    NSURL *url = [NSURL fileURLWithPath:self.videos.firstObject.filePath];
    UIImage *previewImage = [XZAssetHelper videoPreviewImageWithURL:url];
    
    self.lastPlayerLayer = [[CALayer alloc] init];
    self.lastPlayerLayer.frame = self.playerContainerView.bounds;
    [self.playerContainerView.layer addSublayer:self.lastPlayerLayer];
    self.lastPlayerLayer.contents = (__bridge id)(previewImage.CGImage);
}

/// 播放视频
- (void)playVideoWithIndex:(NSInteger)index {
    NSString *path = self.videos[index].filePath;
    NSURL *videoURL = [NSURL fileURLWithPath:path];
    self.player = [AVPlayer playerWithURL:videoURL];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = self.playerContainerView.bounds;
    [self.playerContainerView.layer addSublayer:self.playerLayer];
    [self addObserverForPlayerItem:self.player.currentItem];
    [self.player play];
}

- (void)stopVideo {
    [self removeObserverForPlayerItem:self.player.currentItem];
    [self.player pause];
    [self.lastPlayerLayer removeFromSuperlayer];
    self.lastPlayerLayer = self.playerLayer;
    self.player = nil;
}

- (void)backToCamera {
    [self.navigationController popViewControllerAnimated:NO];
}

/// 添加播放结束监听
- (void)addObserverForPlayerItem:(AVPlayerItem *)playerItem {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playbackFinished:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:playerItem];
}

/// 移除播放结束监听
- (void)removeObserverForPlayerItem:(AVPlayerItem *)playerItem {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVPlayerItemDidPlayToEndTimeNotification
                                                  object:playerItem];
}

// 保存视频
- (void)saveVideo:(NSString *)path completion:(void (^)(BOOL success))completion {
    void (^saveBlock)(void) = ^ {
        NSURL *url = [NSURL fileURLWithPath:path];
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:url];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (completion) {
                completion(success);
            }
        }];
    };
    
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    if (authStatus == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                saveBlock();
            } else {
                if (completion) {
                    completion(NO);
                }
            }
        }];
    } else if (authStatus != PHAuthorizationStatusAuthorized) {
        if (completion) {
            completion(NO);
        }
    } else {
        saveBlock();
    }
}

#pragma mark - Action

- (void)confirmAction:(id)sender {
    [self.view makeToastActivity:CSToastPositionCenter];
    void (^saveBlock)(NSString *) = ^ (NSString *path) {
        @weakify(self);
        [self saveVideo:path completion:^(BOOL success) {
            @strongify(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view hideToastActivity];
                if (success) {
                    [self backToCamera];
                    [self.view.window makeToast:@"保存成功"];
                } else {
                    [self.view.window makeToast:@"保存失败"];
                }
            });
        }];
    };
    
    if (self.videos.count == 1) {
        NSString *path = [self.videos firstObject].filePath;
        saveBlock(path);
    } else {
        NSMutableArray *videoPaths = [[NSMutableArray alloc] init];
        for (XZVideoModel *model in self.videos) {
            [videoPaths addObject:model.filePath];
        }
        NSString *exportPath = [XZFileHelper randomFilePathInTmpWithSuffix:@".m4v"];
        [XZAssetHelper mergeVideos:videoPaths toExportPath:exportPath completion:^{
            saveBlock(exportPath);
        }];
    }
}

- (void)backAction:(id)sender {
    [self backToCamera];
}

- (void)playbackFinished:(NSNotification *)notification {
    [self stopVideo];
    self.currentVideoIndex = (self.currentVideoIndex + 1) % self.videos.count;
    [self playVideoWithIndex:self.currentVideoIndex];
}

#pragma clang diagnostic pop

@end
