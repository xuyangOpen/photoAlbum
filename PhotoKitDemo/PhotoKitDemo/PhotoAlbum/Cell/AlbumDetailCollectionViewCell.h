//
//  AlbumDetailCollectionViewCell.h
//  PhotoKit读取相册内容
//
//  Created by 徐杨 on 2016/12/21.
//  Copyright © 2016年 H&X. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExtensionHeader.h"
#import <Photos/Photos.h>
#import "PhotoKitTool.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class AlbumDetailCollectionViewCell;
typedef void(^SelectionBlock)(AssetModel *, BOOL , AlbumDetailCollectionViewCell *);

@interface AlbumDetailCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) ASImageNode *photoImageView;
@property (nonatomic, strong) AssetModel *model;
@property (nonatomic, copy) NSString *representedAssetIdentifier;
@property (nonatomic, assign) PHImageRequestID imageRequestID;
@property (nonatomic, strong) UIButton *circle;
@property (nonatomic, assign) BOOL isSelected;

///选中时的回调
@property (nonatomic, copy) SelectionBlock selectClosure;

- (instancetype)initWithFrame:(CGRect)frame;

@end
