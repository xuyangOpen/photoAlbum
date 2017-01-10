//
//  PhotoKitTool.m
//  PhotoKit读取相册内容
//
//  Created by 徐杨 on 2016/12/21.
//  Copyright © 2016年 H&X. All rights reserved.
//

#import "PhotoKitTool.h"
#import "ExtensionHeader.h"

@interface PhotoKitTool()
{
    //获取相册中第一张照片筛选参数
    PHFetchOptions *fetchOptions;
    //图片加载缓存管理类
    PHCachingImageManager *imageManager;
    //图片加载缓存参数
    PHImageRequestOptions *requestOptions;
    
    //获取相册中全部照片筛选参数
    PHFetchOptions *fetchAllOptions;

}

@end

@implementation PhotoKitTool

static PhotoKitTool *tool;

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[PhotoKitTool alloc] init];
        [tool valueSettings];
    });
    return tool;
}

#pragma mark - 初始化值
- (void)valueSettings{
    //从相册获取第一张照片筛选参数
    fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:false]];
    
    //照片处理缓存类
    imageManager = [[PHCachingImageManager alloc] init];
    imageManager.allowsCachingHighQualityImages = false;
    
    requestOptions = [[PHImageRequestOptions alloc] init];
    /*deliveryMode参数说明 这个用来控制图片的质量
     1.Opportunistic表示尽可能的获取高质量图片
     2.HighQualityFormat表示不管花多少时间也要获取高质量的图片(慎用)
     3.FastFormat快速获取图片,(图片质量低,我们通常设置这种来获取缩略图)
     */
    
    //异步时，可能会返回多个结果
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    requestOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
    
    //从相册获取全部照片筛选参数
    fetchAllOptions = [[PHFetchOptions alloc] init];
    fetchAllOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:true]];
    
}

- (NSMutableArray *)selectedAssets{
    if (_selectedAssets == nil) {
        _selectedAssets = [NSMutableArray array];
    }
    return _selectedAssets;
}

#pragma mark - 判断是否得到了授权
- (BOOL)authorizationStatusAuthorized{
    return [PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized;
}

#pragma mark - 获取相册的照片数量
- (int)getAssetCountFromAlbum:(PHAssetCollection *)album{
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    //只允许选择图片
    option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsInAssetCollection:album options:option];
    return (int)assetsFetchResults.count;
}

#pragma mark - 获取相册中的第一张图片
- (void)getFirstImageFromAlbum:(PHAssetCollection *)album imageView:(UIImageView *)imageView imageSize:(CGSize)imageSize{
    //获取所有资源的集合，并将资源按时间顺序排列，最新的排在最上面
    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsInAssetCollection:album options:fetchOptions];
    //判断相册中的照片数是否大于0
    if (assetsFetchResults.count > 0) {
        PHAsset *asset = assetsFetchResults[0];
        //    NSArray<PHAsset *> *cachingArray = (NSArray<PHAsset *> *)assetsFetchResults;
        //获取图片
        [imageManager requestImageForAsset:asset targetSize:[self transformPointsToPixel:imageSize] contentMode:PHImageContentModeAspectFill options:requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            imageView.image = result;
        }];
    }
}

#pragma mark - 获取相册中指定的某张图片
- (void)getImageFromAlbum:(PHAssetCollection *)album AtIndex:(int)index toImageView:(UIImageView *)imageView withImageSize:(CGSize)imageSize{
    //获取所有资源的集合，并将资源按时间顺序排列，最新的排在最下面
    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsInAssetCollection:album options:fetchAllOptions];
    //判断相册中的照片数是否大于指定的index
    if (assetsFetchResults.count > index) {
        PHAsset *asset = assetsFetchResults[index];
//        NSArray<PHAsset *> *cachingArray = (NSArray<PHAsset *> *)assetsFetchResults;
        //获取图片
        __block int i=0;
        [imageManager requestImageForAsset:asset targetSize:[self transformPointsToPixel:imageSize] contentMode:PHImageContentModeAspectFill options:requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            imageView.image = result;
            i++;
            if (i>1) {
                //BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
                [imageManager startCachingImagesForAssets:@[asset] targetSize:imageSize contentMode:PHImageContentModeAspectFill options:requestOptions];
            }
        }];
    }
}

#pragma mark - 获取相册album的模型
- (AlbumModel *)getAlbumModeFromAlbum:(PHAssetCollection *)album{
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    //只允许选择图片
    option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:true]];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:album options:option];
    AlbumModel *model = [AlbumModel modelWithResult:fetchResult name:album.localizedTitle];
    return model;
}

#pragma mark - 从fetchResult中获取Assets数组
- (NSArray<AssetModel *> *)getAssetsFromFetchResult:(id)result{
    NSMutableArray *photoArr = [NSMutableArray array];
    if ([result isKindOfClass:[PHFetchResult class]]) {
        PHFetchResult *fetchResult = (PHFetchResult *)result;
        [fetchResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PHAsset *asset = (PHAsset *)obj;
            if (asset.mediaType != PHAssetMediaTypeImage)return;
            [photoArr addObject:[AssetModel modelWithAsset:asset type:AssetModelMediaTypePhoto]];
        }];
        return photoArr;
    }
    return nil;
}

#pragma mark - 获取资源id
- (NSString *)getAssetIdentifier:(id)asset{
    PHAsset *phAsset = (PHAsset *)asset;
    return phAsset.localIdentifier;
}

#pragma mark - 通过Asset获取图片
- (PHImageRequestID)getImageWithAsset:(id)asset imageSize:(CGSize)needImageSize completion:(void (^)(UIImage *, NSDictionary *, BOOL))completion{
    if ([asset isKindOfClass:[PHAsset class]]) {
        //计算图片需要的pixel
        CGSize imageSize = [self transformPointsToPixel:needImageSize];
        if (imageSize.width == 0 && imageSize.height == 0) {
            imageSize = PHImageManagerMaximumSize;
        }
        //图片参数
        PHImageRequestID imageRequestID = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:imageSize contentMode:PHImageContentModeAspectFill options:requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
            if (downloadFinined && result) {
//                result = [self fixOrientation:result];
                if (completion) completion(result,info,[[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
            }
            // Download image from iCloud / 从iCloud下载图片
            if ([info objectForKey:PHImageResultIsInCloudKey] && !result) {
                PHImageRequestOptions *option = [[PHImageRequestOptions alloc]init];
                option.networkAccessAllowed = YES;
                option.resizeMode = PHImageRequestOptionsResizeModeFast;
                [[PHImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                    UIImage *resultImage = [UIImage imageWithData:imageData scale:0.1];
//                    resultImage = [self scaleImage:resultImage toSize:imageSize];
                    if (resultImage) {
//                        resultImage = [self fixOrientation:resultImage];
                        if (completion) completion(resultImage,info,[[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
                    }
                }];
            }
        }];
        return imageRequestID;
    }
    return 0;
}

#pragma mark - 获取一组图片，选择完成时
- (void)fetchGroupPhotoWithAssets:(NSArray *)assets isOriginal:(BOOL)isOriginal complete:(void (^)(NSArray<PHAsset *> *,NSArray<UIImage *> *))complete{
    NSMutableArray *imageArray = [NSMutableArray array];
    NSMutableArray *assetArray = [NSMutableArray array];
    for (int i=0; i<assets.count; i++) {
        [imageArray addObject:@0];
        AssetModel *model = (AssetModel *)assets[i];
        [assetArray addObject:model.asset];
    }
    for (int i=0; i<assets.count; i++) {
        CGSize imageSize = isOriginal ? CGSizeZero : CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        [self getImageWithAsset:assetArray[i] imageSize:imageSize completion:^(UIImage *image, NSDictionary *dic, BOOL isDegraded) {
            //如果是低质量图片，则直接返回
            if (isDegraded) {
                return;
            }else{
                [imageArray replaceObjectAtIndex:i withObject:image];
                for (id obj in imageArray) {
                    if ([obj isKindOfClass:[NSNumber class]]) {
                        return;
                    }
                }
                if (complete) {
                    complete(assetArray,imageArray);
                }
            }
        }];
    }
    
}

#pragma mark - 获取照片内存大小
- (void)getPhotosBytesWithAsset:(AssetModel *)model complete:(void(^)(NSString *))complete{
    __block NSInteger dataLength = 0;
    [[PHImageManager defaultManager] requestImageDataForAsset:model.asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        if (model.type == AssetModelMediaTypePhoto){
            dataLength += imageData.length;
        }
        NSString *bytes = [self getBytesFromDataLength:dataLength];
        if (complete) {
            complete(bytes);
        }
    }];
}

#pragma mark - 通过data数据的length计算内存大小
- (NSString *)getBytesFromDataLength:(NSInteger)dataLength {
    NSString *bytes;
    if (dataLength >= 0.1 * (1024 * 1024)) {
        bytes = [NSString stringWithFormat:@"%0.1fM",dataLength/1024/1024.0];
    } else if (dataLength >= 1024) {
        bytes = [NSString stringWithFormat:@"%0.0fK",dataLength/1024.0];
    } else {
        bytes = [NSString stringWithFormat:@"%zdB",dataLength];
    }
    return bytes;
}

#pragma mark - 转换单位
- (CGSize)transformPointsToPixel:(CGSize)originSize{
    return CGSizeMake(originSize.width*[UIScreen mainScreen].scale, originSize.height*[UIScreen mainScreen].scale);
}

#pragma mark - 获取智能相册
- (PHFetchResult *)getSmartAlbum{
    return [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
}

#pragma mark - 获取用户自定义相册
- (PHFetchResult *)getUserCreatedAlbum{
    return [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
}

#pragma mark - 获取相册名称
- (NSString *)getAlbumName:(PHAssetCollection *)album{
    return [self translateLocalizedTitle:album.localizedTitle];
}

#pragma mark - 开始缓存照片
- (void)startCaching:(NSArray<PHAsset *> *)assets withImageSize:(CGSize)imageSize{
    CGSize targetSize = [self transformPointsToPixel:imageSize];
    [imageManager startCachingImagesForAssets:assets targetSize:targetSize contentMode:PHImageContentModeAspectFill options:NULL];
}

#pragma mark - 停止缓存照片
- (void)stopCaching:(NSArray<PHAsset *> *)assets withImageSize:(CGSize)imageSize{
    CGSize targetSize = [self transformPointsToPixel:imageSize];
    [imageManager stopCachingImagesForAssets:assets targetSize:targetSize contentMode:PHImageContentModeAspectFill options:NULL];
}


#pragma mark - 将固定英文名称的相册转为中文名
- (NSString *)translateLocalizedTitle:(NSString *)title{
    if ([title isEqualToString:@"Slo-mo"]) {
        return @"慢动作";
    } else if ([title isEqualToString:@"Recently Added"]) {
        return @"最近添加";
    } else if ([title isEqualToString:@"Favorites"]) {
        return @"个人收藏";
    } else if ([title isEqualToString:@"Recently Deleted"]) {
        return @"最近删除";
    } else if ([title isEqualToString:@"Videos"]) {
        return @"视频";
    } else if ([title isEqualToString:@"All Photos"]) {
        return @"所有照片";
    } else if ([title isEqualToString:@"Selfies"]) {
        return @"自拍";
    } else if ([title isEqualToString:@"Screenshots"]) {
        return @"屏幕快照";
    } else if ([title isEqualToString:@"Camera Roll"]) {
        return @"相机胶卷";
    }else if ([title isEqualToString:@"Bursts"]){
        return @"连拍快照";
    }else if ([title isEqualToString:@"Panoramas"]){
        return @"全景照片";
    }else if ([title isEqualToString:@"Hidden"]){
        return @"隐藏照片";
    }else if ([title isEqualToString:@"Time-lapse"]){
        return @"延时摄影";
    }
    return title;
}

#pragma mark - 调整图片方向
- (UIImage *)fixOrientation:(UIImage *)aImage {
    if (!self.shouldFixOrientation) return aImage;
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

#pragma mark - 按给定尺寸修改图片大小
- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size {
    if (image.size.width > size.width) {
        UIGraphicsBeginImageContext(size);
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    } else {
        return image;
    }
}

+ (void)showOscillatoryAnimationWithLayer:(CALayer *)layer{
    NSNumber *animationScale1 = @(1.15);
    NSNumber *animationScale2 = @(0.92);
    
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        [layer setValue:animationScale1 forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
            [layer setValue:animationScale2 forKeyPath:@"transform.scale"];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                [layer setValue:@(1.0) forKeyPath:@"transform.scale"];
            } completion:nil];
        }];
    }];
}

/*参数解析
 - (PHImageRequestID)requestImageForAsset:(PHAsset *)asset targetSize:(CGSize)targetSize contentMode:(PHImageContentMode)contentMode options:(nullable PHImageRequestOptions *)options resultHandler:(void (^)(UIImage *__nullable result, NSDictionary *__nullable info))resultHandler;
 options参数
 通过设置version属性
 Current：修改和调整过的图像
 Unadjusted：递送未被修改的图像，递送JPEG
 Original：递送原始质量最高格式的图像
 
 info字典提供请求状态信息
 PHImageResultIsInCloudKey：图像是否必须从iCloud请求
 PHImageResultIsDegradedKey：当前UIImage是否是低质量的，这个可以实现给用户先显示一个预览图
 PHImageResultRequestIDKey和PHImageCancelledKey：请求ID以及请求是否已经被取消
 PHImageErrorKey：如果没有图像，字典内的错误信息
 
 */

@end
