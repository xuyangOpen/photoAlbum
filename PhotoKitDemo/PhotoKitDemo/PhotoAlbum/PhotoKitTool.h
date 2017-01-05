//
//  PhotoKitTool.h
//  PhotoKit读取相册内容
//
//  Created by 徐杨 on 2016/12/21.
//  Copyright © 2016年 H&X. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@class AlbumModel;
@class AssetModel;
@interface PhotoKitTool : NSObject

@property (nonatomic, assign) BOOL shouldFixOrientation;

+ (instancetype)shareInstance;


///是否允许选择原图
@property (nonatomic, assign) BOOL isAllowSelectOriginal;
///是否是原图
@property (nonatomic, assign) BOOL isOriginal;
///最多允许选择的图片张数
@property (nonatomic, assign) NSInteger maxCount;

///操作选中照片资源
@property (nonatomic, strong) NSMutableArray *selectedAssets;
///初始化传入选中照片资源数组
@property (nonatomic, strong) NSArray<PHAsset *> *defaultAssets;

///判断是否得到了授权
- (BOOL)authorizationStatusAuthorized;

///获取相册的照片数量
- (int)getAssetCountFromAlbum:(PHAssetCollection *)album;
///获取相册中的第一张图片
- (void)getFirstImageFromAlbum:(PHAssetCollection *)album imageView:(UIImageView *)imageView imageSize:(CGSize)imageSize;
///获取相册中指定的某张图片
- (void)getImageFromAlbum:(PHAssetCollection *)album AtIndex:(int)index toImageView:(UIImageView *)imageView withImageSize:(CGSize)imageSize;
///获取智能相册
- (PHFetchResult *)getSmartAlbum;
///获取用户自定义相册
- (PHFetchResult *)getUserCreatedAlbum;
///获取相册名称
- (NSString *)getAlbumName:(PHAssetCollection *)album;
///将固定英文名称的相册转为中文名
- (NSString *)translateLocalizedTitle:(NSString *)title;

///开始缓存照片
- (void)startCaching:(NSArray<PHAsset *> *)assets withImageSize:(CGSize)imageSize;
///停止缓存照片
- (void)stopCaching:(NSArray<PHAsset *> *)assets withImageSize:(CGSize)imageSize;

///获取相册album的模型
- (AlbumModel *)getAlbumModeFromAlbum:(PHAssetCollection *)album;

///从相册中获取AssetModel资源数组
- (NSArray<AssetModel *> *)getAssetsFromFetchResult:(id)result;

///获取资源id
- (NSString *)getAssetIdentifier:(id)asset;

///用Asset获取照片资源
- (PHImageRequestID)getImageWithAsset:(id)asset imageSize:(CGSize)needImageSize completion:(void (^)(UIImage *, NSDictionary *, BOOL isDegraded))completion;

///获取照片内存大小
- (void)getPhotosBytesWithAsset:(AssetModel *)model complete:(void(^)(NSString *))complete;

///获取一组图片，选择完成时
- (void)fetchGroupPhotoWithAssets:(NSArray<PHAsset *> *)assets isOriginal:(BOOL)isOriginal complete:(void (^)(NSArray<PHAsset *> *,NSArray<UIImage *> *))complete;

///转换单位
- (CGSize)transformPointsToPixel:(CGSize)originSize;


///圆点的动画
+ (void)showOscillatoryAnimationWithLayer:(CALayer *)layer;

@end
