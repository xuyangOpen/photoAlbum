//
//  AssetModel.m
//  PhotoKitDemo
//
//  Created by 徐杨 on 2016/12/22.
//  Copyright © 2016年 H&X. All rights reserved.
//

#import "AssetModel.h"

@implementation AssetModel

+ (instancetype)modelWithAsset:(id)asset type:(AssetModelMediaType)type{
    AssetModel *model = [[AssetModel alloc] init];
    model.asset = asset;
    model.isSelected = NO;
    model.type = type;
    return model;
}



@end
