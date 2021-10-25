//
//  SCCameraViewController+Filter.m
//  OnePai
//
//  Created by zhouzhou on 2019/4/6.
//  Copyright © 2019年 zhouzhou. All rights reserved.
//

#import "SCCameraViewController+Private.h"

#import "SCCameraViewController+Filter.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@implementation SCCameraViewController (Filter)

#pragma mark - Public

- (void)addBeautifyFilter {
    [SCCameraManager shareManager].currentFilterHandler.beautifyFilterEnable = YES;
}

- (void)removeBeautifyFilter {
    [SCCameraManager shareManager].currentFilterHandler.beautifyFilterEnable = NO;
}

- (NSArray<SCFilterMaterialModel *> *)filtersWithCategoryIndex:(NSInteger)index {
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
