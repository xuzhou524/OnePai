//
//  XZViewController.m
//  OnePai
//
//  Created by zhouzhou on 2019/4/6.
//  Copyright © 2019年 zhouzhou. All rights reserved.
//

#import "XZViewController.h"

@interface XZViewController ()

@end

@implementation XZViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
