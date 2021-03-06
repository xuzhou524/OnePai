//
//  XZCameraManager.m
//  OnePai
//
//  Created by zhouzhou on 2019/4/6.
//  Copyright © 2019年 zhouzhou. All rights reserved.
//

#import "XZFileHelper.h"
#import "XZFaceDetectorManager.h"

#import "XZCameraManager.h"

static CGFloat const kMaxVideoScale = 6.0f;
static CGFloat const kMinVideoScale = 1.0f;

static XZCameraManager *_cameraManager;

@interface XZCameraManager () <GPUImageVideoCameraDelegate>

@property (nonatomic, strong, readwrite) GPUImageStillCamera *camera;
@property (nonatomic, weak) GPUImageView *outputView;
@property (nonatomic, strong, readwrite) XZFilterHandler *currentFilterHandler;
@property (nonatomic, strong) GPUImageMovieWriter *movieWriter;
@property (nonatomic, copy) NSString *currentTmpVideoPath;

@property (nonatomic, assign) CGSize videoSize;

@end

@implementation XZCameraManager

+ (XZCameraManager *)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _cameraManager = [[XZCameraManager alloc] init];
    });
    return _cameraManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

#pragma mark - Public

- (void)licenseFacepp {
    [[XZFaceDetectorManager shareManager] licenseFacepp];
}

- (void)takePhotoWtihCompletion:(TakePhotoResult)completion {
    GPUImageFilter *lastFilter = self.currentFilterHandler.lastFilter;
    [self.camera capturePhotoAsImageProcessedUpToFilter:lastFilter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
        if (error && completion) {
            completion(nil, error);
            return;
        }
        if (completion) {
            completion(processedImage, nil);
        }
    }];
}

- (void)recordVideo {
    [self setupMovieWriter];
    [self.movieWriter startRecording];
}

- (void)stopRecordVideoWithCompletion:(RecordVideoResult)completion {
    @weakify(self);
    [self.movieWriter finishRecordingWithCompletionHandler:^{
        @strongify(self);
        [self removeMovieWriter];
        if (completion) {
            completion(self.currentTmpVideoPath);
        }
    }];
}

- (void)addOutputView:(GPUImageView *)outputView {
    self.outputView = outputView;
}

- (void)startCapturing {
    if (!self.outputView) {
        NSAssert(NO, @"output 未被赋值");
        return;
    }
    [self setupCamera];
    
    [self.camera addTarget:self.currentFilterHandler.firstFilter];
    [self.currentFilterHandler.lastFilter addTarget:self.outputView];
    
    [self.camera startCameraCapture];
}

- (void)rotateCamera {
    [self.camera rotateCamera];
    // 切换摄像头，同步一下闪光灯
    [self syncFlashState];
}

- (void)closeFlashIfNeed {
    AVCaptureDevice *device = self.camera.inputCamera;
    if ([device hasFlash] && device.torchMode == AVCaptureTorchModeOn) {
        [device lockForConfiguration:nil];
        device.torchMode = AVCaptureTorchModeOff;
        device.flashMode = AVCaptureFlashModeOff;
        [device unlockForConfiguration];
    }
}

- (void)updateFlash {
    [self syncFlashState];
}

- (CGFloat)availableVideoScaleWithScale:(CGFloat)scale {
    AVCaptureDevice *device = self.camera.inputCamera;
    
    CGFloat maxScale = kMaxVideoScale;
    CGFloat minScale = kMinVideoScale;
    if (@available(iOS 11.0, *)) {
        maxScale = device.maxAvailableVideoZoomFactor;
    }
    
    scale = MAX(scale, minScale);
    scale = MIN(scale, maxScale);
    
    return scale;
}

- (NSTimeInterval)currentDuration {
    NSTimeInterval time = CMTimeGetSeconds(self.movieWriter.duration);
    return time;
}

- (BOOL)isPositionFront {
    return self.camera.cameraPosition == AVCaptureDevicePositionFront;
}

#pragma mark - Custom Accessor

- (void)setFlashMode:(SCCameraFlashMode)flashMode {
    _flashMode = flashMode;
    
    [self syncFlashState];
}

- (void)setFocusPoint:(CGPoint)focusPoint {
    _focusPoint = focusPoint;
    
    AVCaptureDevice *device = self.camera.inputCamera;
    
    // 坐标转换
    CGPoint currentPoint = CGPointMake(focusPoint.y / self.outputView.bounds.size.height, 1 - focusPoint.x / self.outputView.bounds.size.width);
    if ([self isPositionFront]) {
        currentPoint = CGPointMake(currentPoint.x, 1 - currentPoint.y);
    }
    
    [device lockForConfiguration:nil];
    
    if ([device isFocusPointOfInterestSupported] &&
        [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        [device setFocusPointOfInterest:currentPoint];
        [device setFocusMode:AVCaptureFocusModeAutoFocus];
    }
    if ([device isExposurePointOfInterestSupported] &&
        [device isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
        [device setExposurePointOfInterest:currentPoint];
        [device setExposureMode:AVCaptureExposureModeAutoExpose];
    }
 
    [device unlockForConfiguration];
}

- (void)setVideoScale:(CGFloat)videoScale {
    _videoScale = videoScale;
    
    videoScale = [self availableVideoScaleWithScale:videoScale];
    
    AVCaptureDevice *device = self.camera.inputCamera;
    [device lockForConfiguration:nil];
    device.videoZoomFactor = videoScale;
    [device unlockForConfiguration];
}

- (void)setRatio:(SCCameraRatio)ratio {
    _ratio = ratio;
    
    CGRect rect = [self cropRectWithRatio:ratio];
    [self.currentFilterHandler setCropRect:rect];
    self.videoSize = [self videoSizeWithRatio:ratio];
    CGSize videoSize = [self videoSizeWithRatio:self.ratio];
    [XZFaceDetectorManager shareManager].videoSize = videoSize;
    [XZFaceDetectorManager shareManager].sampleBufferTopOffset = rect.origin.y / rect.size.height * videoSize.height;
    [XZFaceDetectorManager shareManager].sampleBufferLeftOffset = rect.origin.x / rect.size.width * videoSize.width;
}

#pragma mark - Private

- (void)commonInit {
    [self setupFilterHandler];
    self.videoScale = 1;
    self.flashMode = SCCameraFlashModeOff;
    self.ratio = SCCameraRatio4v3;
    self.videoSize = [self videoSizeWithRatio:self.ratio];
    
    [XZFaceDetectorManager shareManager].videoSize = [self videoSizeWithRatio:self.ratio];
    [XZFaceDetectorManager shareManager].sampleBufferTopOffset = 0;
    [XZFaceDetectorManager shareManager].sampleBufferLeftOffset = 0;
}

/**
 初始化相机
 */
- (void)setupCamera {
    self.camera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionFront];
    self.camera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.camera.horizontallyMirrorFrontFacingCamera = YES;
    [self.camera addAudioInputsAndOutputs];
    self.camera.delegate = self;
    self.camera.frameRate = 30;
    
    self.currentFilterHandler.source = self.camera;
}

/**
 初始化 MovieWriter
 */
- (void)setupMovieWriter {
    NSString *videoPath = [XZFileHelper randomFilePathInTmpWithSuffix:@".m4v"];
    NSURL *videoURL = [NSURL fileURLWithPath:videoPath];
    CGSize videoSize = self.videoSize;
    
    self.movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:videoURL
                                                                size:videoSize];
    
    GPUImageFilter *lastFilter = self.currentFilterHandler.lastFilter;
    [lastFilter addTarget:self.movieWriter];
    self.camera.audioEncodingTarget = self.movieWriter;
    self.movieWriter.shouldPassthroughAudio = YES;
    
    self.currentTmpVideoPath = videoPath;
}

/**
 移除 MovieWriter
 */
- (void)removeMovieWriter {
    if (!self.movieWriter) {
        return;
    }
    [self.currentFilterHandler.lastFilter removeTarget:self.movieWriter];
    self.camera.audioEncodingTarget = nil;
    self.movieWriter = nil;
}

/**
 初始化 FilterHandler
 */
- (void)setupFilterHandler {
    self.currentFilterHandler = [[XZFilterHandler alloc] init];
    // 添加效果滤镜
    [self.currentFilterHandler setEffectFilter:nil];
}

/**
 将 flashMode 的值同步到设备
 */
- (void)syncFlashState {
    AVCaptureDevice *device = self.camera.inputCamera;
    if (![device hasFlash] || [self isPositionFront]) {
        [self closeFlashIfNeed];
        return;
    }
    
    [device lockForConfiguration:nil];
    
    switch (self.flashMode) {
        case SCCameraFlashModeOff:
            device.torchMode = AVCaptureTorchModeOff;
            device.flashMode = AVCaptureFlashModeOff;
            break;
        case SCCameraFlashModeOn:
            device.torchMode = AVCaptureTorchModeOff;
            device.flashMode = AVCaptureFlashModeOn;
            break;
        case SCCameraFlashModeAuto:
            device.torchMode = AVCaptureTorchModeOff;
            device.flashMode = AVCaptureFlashModeAuto;
            break;
        case SCCameraFlashModeTorch:
            device.torchMode = AVCaptureTorchModeOn;
            device.flashMode = AVCaptureFlashModeOff;
            break;
        default:
            break;
    }
    
    [device unlockForConfiguration];
}

/// 通过比例，计算出每一帧的尺寸大小
- (CGSize)videoSizeWithRatio:(SCCameraRatio)ratio {
    CGRect originRect = CGRectMake(0, 0, 720, 1280);
    CGRect cropRect = [self cropRectWithRatio:ratio];
    CGSize size = CGSizeMake(originRect.size.width * cropRect.size.width,
                             originRect.size.height * cropRect.size.height);
    return size;
}

/// 通过比例，计算裁剪区域
- (CGRect)cropRectWithRatio:(SCCameraRatio)ratio {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    if (ratio == SCCameraRatio1v1) {
        CGFloat space = (16 - 9) / 16.0; // 竖直方向应该裁剪掉的空间
        rect = CGRectMake(0, space / 2, 1, 1 - space);
    } else if (ratio == SCCameraRatio4v3) {
        CGFloat space = (16.0 / 9 - 4.0 / 3) / (16.0 / 9); // 竖直方向应该裁剪掉的空间
        rect = CGRectMake(0, space / 2, 1, 1 - space);
    } else if (ratio == SCCameraRatioFull) {
        CGFloat currentRatio = SCREEN_HEIGHT / SCREEN_WIDTH;
        if (currentRatio > 16.0 / 9.0) { // 需要在水平方向裁剪
            CGFloat resultWidth = 16.0 / currentRatio;
            CGFloat space = (9.0 - resultWidth) / 9.0;
            rect = CGRectMake(space / 2, 0, 1 - space, 1);
        } else { // 需要在竖直方向裁剪
            CGFloat resultHeight = 9.0 * currentRatio;
            CGFloat space = (16.0 - resultHeight) / 16.0;
            rect = CGRectMake(0, space / 2, 1, 1 - space);
        }
    }
    return rect;
}

#pragma mark - GPUImageVideoCameraDelegate

- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    int facePointCount = 0;
    XZFaceDetectorManager *manager = [XZFaceDetectorManager shareManager];
    float *facePoints = [manager detectWithSampleBuffer:sampleBuffer
                                         facePointCount:&facePointCount
                                               isMirror:[self isPositionFront]];
    self.currentFilterHandler.facesPoints = facePoints;
    self.currentFilterHandler.facesPointCount = facePointCount;
}

@end
