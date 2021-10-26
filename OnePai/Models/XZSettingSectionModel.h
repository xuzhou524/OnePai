//
//  XZSettingSectionModel.h
//  OnePai
//
//  Created by zhouzhou on 2019/7/27.
//  Copyright © 2019年 zhouzhou. All rights reserved.
//

#import "XZSettingModel.h"

@interface XZSettingSectionModel : NSObject

@property (nonatomic, strong) NSString *sectionID;
@property (nonatomic, strong) NSString *sectionTitle;
@property (nonatomic, copy) NSArray <XZSettingModel *>*models;

@end
