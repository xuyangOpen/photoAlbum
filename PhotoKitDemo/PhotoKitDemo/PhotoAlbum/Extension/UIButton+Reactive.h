//
//  UIButton+Reactive.h
//  Category
//
//  Created by 徐杨 on 2016/12/5.
//  Copyright © 2016年 H&X. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseHeader.h"
//C声明
UIButton *buttonInit();
extern CGFloat HXFloat(CGFloat);

@interface UIButton (Reactive)

+ (UIButton *)makeButton:(void (^)(UIButton *))make;

- (UIButton *)addAttribute:(void (^)(UIButton *))make;

- (btnFrame)btnFrame;
- (btnBackgroundColor)btnBackgroundColor;
- (btnAddToView)btnAddToView;
- (btnTag)btnTag;
- (btnCenter)btnCenter;
- (btnAlpha)btnAlpha;

- (btnTitleLableFont)btnTitleLableFont;
- (btnTitle)btnTitle;
- (btnTitleForState)btnTitleForState;
- (btnTitleColor)btnTitleColor;
- (btnTitleColorForState)btnTitleColorForState;
- (btnImage)btnImage;
- (btnImageForState)btnImageForState;
- (btnAddTarget)btnAddTarget;
- (btnTitleEdgeInsets)btnTitleEdgeInsets;
- (btnImageEdgeInsets)btnImageEdgeInsets;
- (btnContentEdgeInsets)btnContentEdgeInsets;

- (btnLayerCornerRadius)btnLayerCornerRadius;
- (btnLayerMasksToBounds)btnLayerMasksToBounds;
- (btnLayerBorderColor)btnLayerBorderColor;
- (btnLayerBorderWidth)btnLayerBorderWidth;

@property (nonatomic, copy)btnClickClosure click;

@end
