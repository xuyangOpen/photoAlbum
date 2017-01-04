//
//  PhotoFlowLayout.m
//  PhotoKitDemo
//
//  Created by 徐杨 on 2016/12/26.
//  Copyright © 2016年 H&X. All rights reserved.
//

#import "PhotoFlowLayout.h"

@implementation PhotoFlowLayout

- (CGSize)collectionViewContentSize{
    NSUInteger count = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:0];
    return CGSizeMake(self.collectionView.frame.size.width*count, self.collectionView.frame.size.height);
}

#pragma mark - 设置item的frame
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    //这里必须使用copy，不然会有警告⚠️
    UICollectionViewLayoutAttributes *attr = [super layoutAttributesForItemAtIndexPath:indexPath].copy;
    
    attr.frame = [self frameForItemAtIndexPath:indexPath];
    return attr;
}

- (CGRect)frameForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = self.collectionView.frame.size.width;
    CGFloat height = self.collectionView.frame.size.height;
    return CGRectMake(indexPath.item*width, 0, width, height);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    [super layoutAttributesForElementsInRect:rect];
    NSUInteger count = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:0];
    NSMutableArray<UICollectionViewLayoutAttributes *> *attrs = [NSMutableArray array];
    for (int i=0; i<count; i++) {
        UICollectionViewLayoutAttributes *attr;
        NSIndexPath *idxPath = [NSIndexPath indexPathForRow:i inSection:0];
        CGRect itemFrame = [self frameForItemAtIndexPath:idxPath];
        if (CGRectIntersectsRect(itemFrame, rect)) {
            attr = [self layoutAttributesForItemAtIndexPath:idxPath];
            [attrs addObject:attr];
        }
    }
    return attrs;
    
}


@end
