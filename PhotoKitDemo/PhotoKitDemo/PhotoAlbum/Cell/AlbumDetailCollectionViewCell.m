//
//  AlbumDetailCollectionViewCell.m
//  PhotoKit读取相册内容
//
//  Created by 徐杨 on 2016/12/21.
//  Copyright © 2016年 H&X. All rights reserved.
//

#import "AlbumDetailCollectionViewCell.h"
#import "Masonry.h"

@interface AlbumDetailCollectionViewCell()
{
    UIImage *selectedImage;
    UIImage *unSelectedImage;
}
@end

@implementation AlbumDetailCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //照片
        self.photoImageView = [UIImageView makeImageView:^(UIImageView *make) {
            make.ivLayerMasksToBounds(true).ivContentMode(UIViewContentModeScaleAspectFill).ivAddToView(self.contentView);
        }];
        
        [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView);
            make.size.equalTo(self.contentView);
        }];
        //是否选中的小圆点
        self.circle = [UIButton makeButton:^(UIButton *make) {
            make.btnAddTarget(self,@selector(clickSelectButton),UIControlEventTouchUpInside).btnImage([UIImage imageNamed:@"photo_def_photoPickerVc@2x"]).btnAddToView(self.contentView);
        }];
        CGFloat unit = [self scaleWidth:25];
        [self.circle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).with.offset(2);
            make.right.equalTo(self.contentView).with.offset(-2);
            make.size.mas_equalTo(CGSizeMake(unit, unit));
        }];
        
        selectedImage = [UIImage imageNamed:@"photo_sel_photoPickerVc@2x"];
        unSelectedImage = [UIImage imageNamed:@"photo_def_photoPickerVc@2x"];
    }
    return self;
}

#pragma mark - 按4.7的屏幕，获取尺寸
- (CGFloat)scaleWidth:(CGFloat)width{
    return width/414 * SCREEN_WIDTH;
}

#pragma mark - 设置模型
- (void)setModel:(AssetModel *)model{
    _model = model;

    //获取资源id
    self.representedAssetIdentifier = [[PhotoKitTool shareInstance] getAssetIdentifier:model.asset];
    //从系统相册中获取照片
    [self fetchImageFromSystem:model];
    
    //判断是否选中
    self.isSelected = model.isSelected;
    [self.circle setImage:self.isSelected ? selectedImage:unSelectedImage forState:(UIControlStateNormal)];
}

#pragma mark - 从系统相册中获取照片
- (void)fetchImageFromSystem:(AssetModel *)model{
    //发送获取图片的请求，并获取请求id
    PHImageRequestID imageRequestID = [[PhotoKitTool shareInstance] getImageWithAsset:model.asset imageSize:CGSizeMake(ITEMSIZE, ITEMSIZE) completion:^(UIImage *image, NSDictionary *dic, BOOL isDegraded) {
//        if (isDegraded) {
//            return;
//        }
        //如果当前请求id==当前资源id，则图片设置为当前请求的图片
        if ([self.representedAssetIdentifier isEqualToString:[[PhotoKitTool shareInstance] getAssetIdentifier:model.asset]]) {
            self.photoImageView.image = image;
        } else {
            //否则取消当前请求id
            [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
        }
    }];

    self.imageRequestID = imageRequestID;
}

- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    [self.circle setImage:isSelected ? selectedImage:unSelectedImage forState:(UIControlStateNormal)];
    if (_isSelected) {
        [PhotoKitTool showOscillatoryAnimationWithLayer:self.circle.layer];
    }
}

#pragma mark - 选中按钮点击事件
- (void)clickSelectButton{
    //当前选中取反
    self.selectClosure(self.model, !self.isSelected, self);
}



@end
