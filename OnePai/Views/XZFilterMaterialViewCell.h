//
//  XZFilterMaterialViewCell.h
//  OnePai
//
//  Created by zhouzhou on 2019/4/13.
//  Copyright © 2019年 zhouzhou. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XZFilterMaterialModel.h"

@interface XZFilterMaterialViewCell : UICollectionViewCell

@property (nonatomic, strong) XZFilterMaterialModel *filterMaterialModel;
@property (nonatomic, assign) BOOL isSelect;  

@end
