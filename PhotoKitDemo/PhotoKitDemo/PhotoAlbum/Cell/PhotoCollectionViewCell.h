//
//  PhotoCollectionViewCell.h
//  PhotoKitDemo
//
//  Created by 徐杨 on 2016/12/26.
//  Copyright © 2016年 H&X. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExtensionHeader.h"
#import <Photos/Photos.h>
#import "PhotoKitTool.h"

@protocol PhotoCollectionViewCellDelegate <NSObject>

- (void)showOrHideOperationToolBar;

@end

@interface PhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id<PhotoCollectionViewCellDelegate> delegate;

@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) AssetModel *model;
@property (nonatomic, copy) NSString *representedAssetIdentifier;
@property (nonatomic, assign) PHImageRequestID imageRequestID;

@end
