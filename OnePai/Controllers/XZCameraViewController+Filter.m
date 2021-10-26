//
//  XZCameraViewController+Filter.m
//  OnePai
//
//  Created by zhouzhou on 2019/4/6.
//  Copyright © 2019年 zhouzhou. All rights reserved.
//

#import "XZCameraViewController+Private.h"

#import "XZCameraViewController+Filter.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@implementation XZCameraViewController (Filter)

#pragma mark - Public

- (void)addBeautifyFilter {
    [XZCameraManager shareManager].currentFilterHandler.beautifyFilterEnable = YES;
}

- (void)removeBeautifyFilter {
    [XZCameraManager shareManager].currentFilterHandler.beautifyFilterEnable = NO;
}

- (NSArray<XZFilterMaterialModel *> *)filtersWithCategoryIndex:(NSInteger)index {
    if (index == 0) {
        return self.defaultFilterMaterials;
    } else if (index == 1) {
        return self.tikTokFilterMaterials;
    } else if (index == 2) {
        return self.faceRecognizerFilterMaterials;
    } else if (index == 3) {
        return self.splitFilterMaterials;
    }
    return nil;
}

@end

#pragma clang diagnostic pop
