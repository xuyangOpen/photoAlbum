//
//  AssetModel.h
//  PhotoKitDemo
//
//  Created by 徐杨 on 2016/12/22.
//  Copyright © 2016年 H&X. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExtensionHeader.h"

///资源类型
typedef enum : NSUInteger {
    AssetModelMediaTypePhoto = 0,
    AssetModelMediaTypeLivePhoto,
    AssetModelMediaTypeVideo,
    AssetModelMediaTypeAudio
} AssetModelMediaType;

@interface AssetModel : NSObject

@property (nonatomic, strong) id asset;
@property (nonatomic) BOOL isSelected;
@property (nonatomic, assign) AssetModelMediaType type;

/// 用一个PHAsset实例，初始化一个照片模型
+ (instancetype)modelWithAsset:(id)asset type:(AssetModelMediaType)type;

@end
