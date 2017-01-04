//
//  UIScrollView+Reactive.h
//  Category
//
//  Created by 徐杨 on 2016/12/7.
//  Copyright © 2016年 H&X. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseHeader.h"

@interface UIScrollView (Reactive)

+ (UIScrollView *)makeScrollView:(void (^)(UIScrollView *))make;

- (svFrame)svFrame;
- (svBackgroundColor)svBackgroundColor;
- (svAddToView)svAddToView;
- (svTag)svTag;
- (svCenter)svCenter;
- (svAlpha)svAlpha;

- (svDelegate)svDelegate;
- (svContentOffset)svContentOffset;
- (svContentSize)svContentSize;
- (svContentInset)svContentInset;
- (svBounces)svBounces;
- (svAlwaysBounceVertical)svAlwaysBounceVertical;
- (svAlwaysBounceHorizontal)svAlwaysBounceHorizontal;
- (svPagingEnabled)svPagingEnabled;
- (svScrollEnabled)svScrollEnabled;
- (svShowsHorizontalScrollIndicator)svShowsHorizontalScrollIndicator;
- (svShowsVerticalScrollIndicator)svShowsVerticalScrollIndicator;
- (svZoomScale)svZoomScale;
- (svMinimumZoomScale)svMinimumZoomScale;
- (svMaximumZoomScale)svMaximumZoomScale;

@end
