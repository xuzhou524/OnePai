//
//  SCFilterMaterialViewCell.h
//  OnePai
//
//  Created by zhouzhou on 2019/4/13.
//  Copyright © 2019年 zhouzhou. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SCFilterMaterialModel.h"

@interface SCFilterMaterialViewCell : UICollectionViewCell

@property (nonatomic, strong) SCFilterMaterialModel *filterMaterialModel;
@property (nonatomic, assign) BOOL isSelect;  

@end
