//
//  UICollectionViewFlowLayout+Reactive.h
//  Category
//
//  Created by 徐杨 on 2016/12/7.
//  Copyright © 2016年 H&X. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseHeader.h"

@interface UICollectionViewFlowLayout (Reactive)

+ (UICollectionViewFlowLayout *)makeCollectionViewFlowLayout:(void (^)(UICollectionViewFlowLayout *))make;

- (cvfMinimumLineSpacing)cvfMinimumLineSpacing;
- (cvfMinimumInteritemSpacing)cvfMinimumInteritemSpacing;
- (cvfItemSize)cvfItemSize;
- (cvfScrollDirection)cvfScrollDirection;
- (cvfSectionInset)cvfSectionInset;

@end
