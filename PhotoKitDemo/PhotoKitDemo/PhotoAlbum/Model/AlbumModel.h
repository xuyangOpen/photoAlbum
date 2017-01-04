//
//  AlbumModel.h
//  PhotoKitDemo
//
//  Created by 徐杨 on 2016/12/22.
//  Copyright © 2016年 H&X. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoKitTool.h"
#import "AssetModel.h"

@interface AlbumModel : NSObject

@property (nonatomic, strong) NSString *name;               ///相册名
@property (nonatomic, assign) NSInteger count;              ///相册中的照片数量
@property (nonatomic, strong) id result;                    ///相册的结果集
@property (nonatomic, strong) NSArray *assetsArray;         ///Assets集合

+ (instancetype)modelWithResult:(id)result name:(NSString *)name;

- (NSArray<PHAsset *> *)getAssetsList;

@end
