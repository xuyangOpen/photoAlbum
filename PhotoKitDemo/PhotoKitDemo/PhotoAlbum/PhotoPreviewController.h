//
//  PhotoPreviewController.h
//  PhotoKitDemo
//
//  Created by 徐杨 on 2016/12/26.
//  Copyright © 2016年 H&X. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

///返回时的回调，参数1、是否需要刷新
typedef void(^AfterTheEndNeedRefresh)(BOOL);

@interface PhotoPreviewController : BaseViewController

//刷新回调块
@property (nonatomic, copy) AfterTheEndNeedRefresh refreshComplete;
///底部操作栏
@property (nonatomic, strong) UIView *bottomToolView;

@property (nonatomic, strong) UICollectionView *photoCollectionView;
///当前显示的图片下标
@property (nonatomic, assign) NSUInteger currentIndex;

- initWithAssets:(NSArray<PHAsset *> *)assets atIndex:(int)index  magic:(BOOL)magic;

@end
