//
//  UICollectionViewFlowLayout+Reactive.m
//  Category
//
//  Created by 徐杨 on 2016/12/7.
//  Copyright © 2016年 H&X. All rights reserved.
//

#import "UICollectionViewFlowLayout+Reactive.h"

@implementation UICollectionViewFlowLayout (Reactive)

#pragma mark - init
+ (UICollectionViewFlowLayout *)makeCollectionViewFlowLayout:(void (^)(UICollectionViewFlowLayout *))make{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    make(flowLayout);
    return flowLayout;
}

#pragma mark - minimumLineSpacing
- (cvfMinimumLineSpacing)cvfMinimumLineSpacing{
    return ^UICollectionViewFlowLayout *(CGFloat lineSpacing){
        self.minimumLineSpacing = lineSpacing;
        return self;
    };
}

#pragma mark - minimumInteritemSpacing
- (cvfMinimumInteritemSpacing)cvfMinimumInteritemSpacing{
    return ^UICollectionViewFlowLayout *(CGFloat itemSpacing){
        self.minimumInteritemSpacing = itemSpacing;
        return self;
    };
}

#pragma mark - itemSize
- (cvfItemSize)cvfItemSize{
    return ^UICollectionViewFlowLayout *(CGSize size){
        self.itemSize = size;
        return self;
    };
}

#pragma mark - scrollDirection
- (cvfScrollDirection)cvfScrollDirection{
    return ^UICollectionViewFlowLayout *(UICollectionViewScrollDirection direction){
        self.scrollDirection = direction;
        return self;
    };
}

#pragma mark - sectionInset
- (cvfSectionInset)cvfSectionInset{
    return ^UICollectionViewFlowLayout *(UIEdgeInsets edge){
        self.sectionInset = edge;
        return self;
    };
}

@end
