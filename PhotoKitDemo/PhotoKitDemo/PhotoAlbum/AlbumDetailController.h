//
//  AlbumDetailController.h
//  PhotoKit读取相册内容
//
//  Created by 徐杨 on 2016/12/21.
//  Copyright © 2016年 H&X. All rights reserved.
//

#import "BaseViewController.h"
#import <Photos/Photos.h>

typedef void(^loadCountClosure)();

@interface AlbumDetailController : BaseViewController

@property (nonatomic, strong) UICollectionView *photoCollectionView;

@property (nonatomic, copy) loadCountClosure loadBlock;

- (instancetype)initWithAlbum:(PHAssetCollection *)album;

///更新底部视图
- (void)reloadBottomInfo;

@end
