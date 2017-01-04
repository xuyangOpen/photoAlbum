//
//  AlbumNavigationController.h
//  PhotoKitDemo
//
//  Created by 徐杨 on 2016/12/23.
//  Copyright © 2016年 H&X. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@protocol AlbumDelegate<NSObject>

@optional
//选择完成之后的回调代理方法
- (void)finishTheSelection:(NSArray<PHAsset *> *)assets imageArray:(NSArray<UIImage *> *)imageArray isOriginal:(BOOL)isOriginal;

@end

@interface AlbumNavigationController : UINavigationController

///传入默认选中的照片资源
- (instancetype)initWithSelectedAssets:(NSArray<PHAsset *> *)assets;

///是否允许选择原图
@property (nonatomic, assign) BOOL isAllowSelectOriginal;
///是否是原图
@property (nonatomic, assign) BOOL isOriginal;
///最多允许选择的图片张数
@property (nonatomic, assign) NSInteger maxCount;
///是否允许缓存图片
@property (nonatomic, assign) BOOL enableCaching;

///代理
@property (nonatomic, weak) id<AlbumDelegate> albumDelegate;

///完成选择
- (void)finishTheSelection;

@end
