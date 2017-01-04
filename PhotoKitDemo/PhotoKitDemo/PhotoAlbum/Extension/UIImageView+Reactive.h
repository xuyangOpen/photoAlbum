//
//  UIImageView+Reactive.h
//  Category
//
//  Created by 徐杨 on 2016/12/6.
//  Copyright © 2016年 H&X. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseHeader.h"

UIImageView *imageViewInit();

@interface UIImageView (Reactive)

+ (UIImageView *)makeImageView:(void (^)(UIImageView *))make;
+ (UIImageView *)makeImageView:(void (^)(UIImageView *))make image:(UIImage *)image;

- (ivFrame)ivFrame;
- (ivBackgroundColor)ivBackgroundColor;
- (ivAddToView)ivAddToView;
- (ivTag)ivTag;
- (ivCenter)ivCenter;
- (ivAlpha)ivAlpha;
- (ivUserInteractionEnabled)ivUserInteractionEnabled;

- (ivImage)ivImage;
- (ivContentMode)ivContentMode;
- (ivLayerCornerRadius)ivLayerCornerRadius;
- (ivLayerMasksToBounds)ivLayerMasksToBounds;
- (ivLayerBorderColor)ivLayerBorderColor;
- (ivLayerBorderWidth)ivLayerBorderWidth;


@property (nonatomic, copy)imageViewTapClosure imageViewTap;
@end
