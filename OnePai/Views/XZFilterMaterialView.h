//
//  XZFilterMaterialView.h
//  OnePai
//
//  Created by zhouzhou on 2019/4/13.
//  Copyright © 2019年 zhouzhou. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XZFilterMaterialModel.h"

@class XZFilterMaterialView;

@protocol XZFilterMaterialViewDelegate <NSObject>

- (void)filterMaterialView:(XZFilterMaterialView *)filterMaterialView didScrollToIndex:(NSUInteger)index;

@end

@interface XZFilterMaterialView : UIView

@property (nonatomic, copy) NSArray<XZFilterMaterialModel *> *itemList;
@property (nonatomic, weak) id <XZFilterMaterialViewDelegate> delegate;

@end
