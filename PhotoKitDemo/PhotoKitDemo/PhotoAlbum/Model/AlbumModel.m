//
//  AlbumModel.m
//  PhotoKitDemo
//
//  Created by 徐杨 on 2016/12/22.
//  Copyright © 2016年 H&X. All rights reserved.
//

#import "AlbumModel.h"

@implementation AlbumModel

+ (instancetype)modelWithResult:(id)result name:(NSString *)name{
    AlbumModel *model = [[AlbumModel alloc] init];
    model.result = result;
    model.name = [[PhotoKitTool shareInstance] translateLocalizedTitle:name];
    if ([result isKindOfClass:[PHFetchResult class]]) {
        PHFetchResult *fetchResult = (PHFetchResult *)result;
        model.count = fetchResult.count;
    }
    return model;
}

#pragma mark - 通过result，获取AssetModel资源数组
- (void)setResult:(id)result{
    _result = result;
    self.assetsArray = [[PhotoKitTool shareInstance] getAssetsFromFetchResult:result];
}

#pragma mark - 获取AlbumModel中的PHAsset资源数组
- (NSArray<PHAsset *> *)getAssetsList{
    NSMutableArray<PHAsset *> *assetsList = [NSMutableArray array];
    for (int i=0; i<self.assetsArray.count; i++) {
        AssetModel *model = self.assetsArray[i];
        [assetsList addObject:model.asset];
    }
    return assetsList;
}

@end
