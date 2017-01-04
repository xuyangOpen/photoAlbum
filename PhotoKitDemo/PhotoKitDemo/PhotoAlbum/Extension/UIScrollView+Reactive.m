//
//  UIScrollView+Reactive.m
//  Category
//
//  Created by 徐杨 on 2016/12/7.
//  Copyright © 2016年 H&X. All rights reserved.
//

#import "UIScrollView+Reactive.h"

@implementation UIScrollView (Reactive)

+ (UIScrollView *)makeScrollView:(void (^)(UIScrollView *))make{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    make(scrollView);
    return scrollView;
}

#pragma mark - frame
- (svFrame)svFrame{
    return ^UIScrollView *(CGRect frame){
        self.frame = frame;
        return self;
    };
}

#pragma mark - backgroundColor
- (svBackgroundColor)svBackgroundColor{
    return ^UIScrollView *(UIColor *color){
        [self setBackgroundColor:color];
        return self;
    };
}

#pragma mark - addToView
- (svAddToView)svAddToView{
    return ^UIScrollView *(UIView *parentView){
        [parentView addSubview:self];
        return self;
    };
}

#pragma mark - tag
- (svTag)svTag{
    return ^UIScrollView *(NSInteger tag){
        self.tag = tag;
        return self;
    };
}

#pragma mark - center
- (svCenter)svCenter{
    return ^UIScrollView *(CGPoint center){
        self.center = center;
        return self;
    };
}

#pragma mark - alpha
- (svAlpha)svAlpha{
    return ^UIScrollView *(CGFloat alpha){
        self.alpha = alpha;
        return self;
    };
}

#pragma mark - delegate
- (svDelegate)svDelegate{
    return ^UIScrollView *(id<UIScrollViewDelegate> delegate){
        self.delegate = delegate;
        return self;
    };
}

#pragma mark - contentOffset
- (svContentOffset)svContentOffset{
    return ^UIScrollView *(CGPoint offset){
        self.contentOffset = offset;
        return self;
    };
}

#pragma mark - contentSize
- (svContentSize)svContentSize{
    return ^UIScrollView *(CGSize size){
        self.contentSize = size;
        return self;
    };
}

#pragma mark - contentInset
- (svContentInset)svContentInset{
    return ^UIScrollView *(UIEdgeInsets edge){
        self.contentInset = edge;
        return self;
    };
}

#pragma mark - bounces
- (svBounces)svBounces{
    return ^UIScrollView *(BOOL flag){
        self.bounces = flag;
        return self;
    };
}

#pragma mark - alwaysBounceVertical
- (svAlwaysBounceVertical)svAlwaysBounceVertical{
    return ^UIScrollView *(BOOL flag){
        self.alwaysBounceVertical = flag;
        return self;
    };
}

#pragma mark - alwaysBounceHorizontal
- (svAlwaysBounceHorizontal)svAlwaysBounceHorizontal{
    return ^UIScrollView *(BOOL flag){
        self.alwaysBounceHorizontal = flag;
        return self;
    };
}

#pragma mark - pagingEnabled
- (svPagingEnabled)svPagingEnabled{
    return ^UIScrollView *(BOOL flag){
        self.pagingEnabled = flag;
        return self;
    };
}

#pragma mark - scrollEnabled
- (svScrollEnabled)svScrollEnabled{
    return ^UIScrollView *(BOOL flag){
        self.scrollEnabled = flag;
        return self;
    };
}

#pragma mark - showsVerticalScrollIndicator
- (svShowsVerticalScrollIndicator)svShowsVerticalScrollIndicator{
    return ^UIScrollView *(BOOL flag){
        self.showsVerticalScrollIndicator = flag;
        return self;
    };
}

#pragma mark - showsHorizontalScrollIndicator
- (svShowsHorizontalScrollIndicator)svShowsHorizontalScrollIndicator{
    return ^UIScrollView *(BOOL flag){
        self.showsHorizontalScrollIndicator = flag;
        return self;
    };
}

#pragma mark - zoomScale
- (svZoomScale)svZoomScale{
    return ^UIScrollView *(CGFloat scale){
        self.zoomScale = scale;
        return self;
    };
}

#pragma mark - minimumZoomScale
- (svMinimumZoomScale)svMinimumZoomScale{
    return ^UIScrollView *(CGFloat minimumZoomScale){
        self.minimumZoomScale = minimumZoomScale;
        return self;
    };
}

#pragma mark - maximumZoomScale
- (svMaximumZoomScale)svMaximumZoomScale{
    return ^UIScrollView *(CGFloat maximumZoomScale){
        self.maximumZoomScale = maximumZoomScale;
        return self;
    };
}

@end
