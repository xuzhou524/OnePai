//
//  XZGPUImageScaleFilter.m
//  OnePai
//
//  Created by zhouzhou on 2019/6/1.
//  Copyright © 2019年 zhouzhou. All rights reserved.
//

#import "XZGPUImageScaleFilter.h"

NSString * const kSCGPUImageScaleFilterShaderString = SHADER_STRING
(
 attribute vec4 position;
 attribute vec4 inputTextureCoordinate;
 
 varying vec2 textureCoordinate;
 
 uniform float time;
 
 const float PI = 3.1415926;
 
 void main (void) {
     float duration = 0.6;
     float maxAmplitude = 0.4;

     float currentTime = mod(time, duration);
     float amplitude = 1.0 + maxAmplitude * abs(sin(currentTime * (PI / duration)));
     
     gl_Position = vec4(position.x * amplitude, position.y * amplitude, position.zw);
     textureCoordinate = inputTextureCoordinate.xy;
 }
);

@implementation XZGPUImageScaleFilter

- (id)init {
    self = [super initWithVertexShaderFromString:kSCGPUImageScaleFilterShaderString fragmentShaderFromString:kGPUImagePassthroughFragmentShaderString];
    return self;
}

@end
