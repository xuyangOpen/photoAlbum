//
//  UIView+Reactive.h
//  Category
//
//  Created by 徐杨 on 2016/12/5.
//  Copyright © 2016年 H&X. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseHeader.h"

//C声明
UIView *viewInit();

@interface UIView (Reactive)

+ (UIView *)makeView:(void (^)(UIView *))make;

- (viewFrame)viewFrame;
- (viewBackgroundColor)viewBackgroundColor;
- (viewAddToView)viewAddToView;
- (viewTag)viewTag;
- (viewCenter)viewCenter;
- (viewAlpha)viewAlpha;

@property (nonatomic, copy)viewTapClosure viewTap;

@end
