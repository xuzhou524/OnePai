//
//  XZFilterCategoryView.h
//  OnePai
//
//  Created by zhouzhou on 2019/6/1.
//  Copyright © 2019年 zhouzhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XZFilterCategoryView;

@protocol XZFilterCategoryViewDelegate <NSObject>

- (void)filterCategoryView:(XZFilterCategoryView *)filterCategoryView
          didScrollToIndex:(NSUInteger)index;

@end

@interface XZFilterCategoryView : UIView

@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, strong) UIFont *itemFont;
@property (nonatomic, strong) UIColor *itemNormalColor;
@property (nonatomic, strong) UIColor *itemSelectColor;
@property (nonatomic, assign) CGFloat bottomLineWidth;
@property (nonatomic, assign) CGFloat bottomLineHeight;

@property (nonatomic, assign, readonly) NSInteger currentIndex;

@property (nonatomic, strong) NSArray <NSString *> *itemList;

@property (nonatomic, weak) id<XZFilterCategoryViewDelegate> delegate;

- (void)scrollToIndex:(NSUInteger)index;

@end
