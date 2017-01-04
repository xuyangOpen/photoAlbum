//
//  UITextView+Reactive.h
//  Category
//
//  Created by 徐杨 on 2016/12/7.
//  Copyright © 2016年 H&X. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseHeader.h"

@interface UITextView (Reactive)

+ (UITextView *)makeTextView:(void (^)(UITextView *))make;

- (xvFrame)xvFrame;
- (xvBackgroundColor)xvBackgroundColor;
- (xvAddToView)xvAddToView;
- (xvTag)xvTag;
- (xvCenter)xvCenter;
- (xvAlpha)xvAlpha;

- (xvDelegate)xvDelegate;
- (xvText)xvText;
- (xvFont)xvFont;
- (xvTextColor)xvTextColor;
- (xvTextAlignment)xvTextAlignment;

@end
