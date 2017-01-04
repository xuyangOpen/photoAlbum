//
//  UICollectionView+Reactive.h
//  Category
//
//  Created by 徐杨 on 2016/12/7.
//  Copyright © 2016年 H&X. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseHeader.h"

@interface UICollectionView (Reactive)

+ (UICollectionView *)makeCollectionView:(void (^)(UICollectionView *))make;
+ (UICollectionView *)makeCollectionView:(void (^)(UICollectionView *))make frame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout;

- (cvFrame)cvFrame;
- (cvBackgroundColor)cvBackgroundColor;
- (cvAddToView)cvAddToView;
- (cvTag)cvTag;
- (cvCenter)cvCenter;
- (cvAlpha)cvAlpha;

- (cvDelegate)cvDelegate;
- (cvDataSource)cvDataSource;
- (cvBackgroundView)cvBackgroundView;
- (cvShowsHorizontalScrollIndicator)cvShowsHorizontalScrollIndicator;
- (cvShowsVerticalScrollIndicator)cvShowsVerticalScrollIndicator;
- (cvPagingEnabled)cvPagingEnabled;

@end
