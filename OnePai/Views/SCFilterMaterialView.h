//
//  SCFilterMaterialView.h
//  OnePai
//
//  Created by zhouzhou on 2019/4/13.
//  Copyright © 2019年 zhouzhou. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SCFilterMaterialModel.h"

@class SCFilterMaterialView;

@protocol SCFilterMaterialViewDelegate <NSObject>

- (void)filterMaterialView:(SCFilterMaterialView *)filterMaterialView didScrollToIndex:(NSUInteger)index;

@end

@interface SCFilterMaterialView : UIView

@property (nonatomic, copy) NSArray<SCFilterMaterialModel *> *itemList;
@property (nonatomic, weak) id <SCFilterMaterialViewDelegate> delegate;

@end
