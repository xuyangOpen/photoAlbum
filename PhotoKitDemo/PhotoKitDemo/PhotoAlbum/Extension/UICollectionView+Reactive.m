//
//  UICollectionView+Reactive.m
//  Category
//
//  Created by 徐杨 on 2016/12/7.
//  Copyright © 2016年 H&X. All rights reserved.
//

#import "UICollectionView+Reactive.h"

@implementation UICollectionView (Reactive)

#pragma mark - init
+ (UICollectionView *)makeCollectionView:(void (^)(UICollectionView *))make{
    UICollectionView *collectionView = [[UICollectionView alloc] init];
    make(collectionView);
    return collectionView;
}

+ (UICollectionView *)makeCollectionView:(void (^)(UICollectionView *))make frame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    make(collectionView);
    return collectionView;
}

#pragma mark - frame
- (cvFrame)cvFrame{
    return ^UICollectionView *(CGRect frame){
        self.frame = frame;
        return self;
    };
}

#pragma mark - backgroundColor
- (cvBackgroundColor)cvBackgroundColor{
    return ^UICollectionView *(UIColor *color){
        [self setBackgroundColor:color];
        return self;
    };
}

#pragma mark - addToView
- (cvAddToView)cvAddToView{
    return ^UICollectionView *(UIView *parentView){
        [parentView addSubview:self];
        return self;
    };
}

#pragma mark - tag
- (cvTag)cvTag{
    return ^UICollectionView *(NSInteger tag){
        self.tag = tag;
        return self;
    };
}

#pragma mark - center
- (cvCenter)cvCenter{
    return ^UICollectionView *(CGPoint center){
        self.center = center;
        return self;
    };
}

#pragma mark - alpha
- (cvAlpha)cvAlpha{
    return ^UICollectionView *(CGFloat alpha){
        self.alpha = alpha;
        return self;
    };
}

#pragma mark - delegate
- (cvDelegate)cvDelegate{
    return ^UICollectionView *(id<UICollectionViewDelegate> delegate){
        self.delegate = delegate;
        return self;
    };
}

#pragma mark - dataSource
- (cvDataSource)cvDataSource{
    return ^UICollectionView *(id<UICollectionViewDataSource> dataSource){
        self.dataSource = dataSource;
        return self;
    };
}

#pragma mark - backgroundView
- (cvBackgroundView)cvBackgroundView{
    return ^UICollectionView *(UIView *view){
        self.backgroundView = view;
        return self;
    };
}

#pragma mark - showsHorizontalScrollIndicator
- (cvShowsHorizontalScrollIndicator)cvShowsHorizontalScrollIndicator{
    return ^UICollectionView *(BOOL isShow){
        self.showsHorizontalScrollIndicator = isShow;
        return self;
    };
}

#pragma mark - showsVerticalScrollIndicator
- (cvShowsVerticalScrollIndicator)cvShowsVerticalScrollIndicator{
    return ^UICollectionView *(BOOL isShow){
        self.showsVerticalScrollIndicator = isShow;
        return self;
    };
}

#pragma mark - pagingEnabled
- (cvPagingEnabled)cvPagingEnabled{
    return ^UICollectionView *(BOOL pagingEnabled){
        self.pagingEnabled = pagingEnabled;
        return self;
    };
}

@end
