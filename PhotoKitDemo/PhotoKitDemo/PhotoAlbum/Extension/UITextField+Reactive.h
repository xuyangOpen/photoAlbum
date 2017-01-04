//
//  UITextField+Reactive.h
//  Category
//
//  Created by 徐杨 on 2016/12/7.
//  Copyright © 2016年 H&X. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseHeader.h"

@interface UITextField (Reactive)

+ (UITextField *)makeTextField:(void (^)(UITextField *))make;

- (tfFrame)tfFrame;
- (tfBackgroundColor)tfBackgroundColor;
- (tfAddToView)tfAddToView;
- (tfTag)tfTag;
- (tfCenter)tfCenter;
- (tfAlpha)tfAlpha;

- (tfText)tfText;
- (tfAttributedText)tfAttributedText;
- (tfTextColor)tfTextColor;
- (tfFont)tfFont;
- (tfTextAlignment)tfTextAlignment;
- (tfBorderStyle)tfBorderStyle;
- (tfPlaceholder)tfPlaceholder;
- (tfDelegate)tfDelegate;
- (tfLeftView)tfLeftView;
- (tfRightView)tfRightView;
- (tfRightViewMode)tfRightViewMode;

- (tfKeyboardType)tfKeyboardType;
- (tfTintColor)tfTintColor;
- (tfSecureTextEntry)tfSecureTextEntry;

@end
