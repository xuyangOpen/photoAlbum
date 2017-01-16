//
//  TakePhotoCollectionViewCell.m
//  PhotoKitDemo
//
//  Created by 徐杨 on 2017/1/16.
//  Copyright © 2017年 H&X. All rights reserved.
//

#import "TakePhotoCollectionViewCell.h"
#import "ExtensionHeader.h"

@interface TakePhotoCollectionViewCell()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation TakePhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.imageView = [UIImageView makeImageView:^(UIImageView *make) {
            make.ivFrame(CGRectMake(0, 0, ITEMSIZE, ITEMSIZE)).ivAddToView(self.contentView);
        }];
    }
    return self;
}

- (void)setImageName:(NSString *)imageName{
    self.imageView.image = [UIImage imageNamed:imageName];
}

@end
