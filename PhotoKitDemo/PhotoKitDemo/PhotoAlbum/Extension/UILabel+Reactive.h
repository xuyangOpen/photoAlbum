//
//  UILabel+Reactive.h
//  Category
//
//  Created by 徐杨 on 2016/12/6.
//  Copyright © 2016年 H&X. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseHeader.h"

UILabel *labelInit();

@interface UILabel (Reactive)

+ (UILabel *)makeLabel:(void (^)(UILabel *))make;

- (labelFrame)labelFrame;
- (labelBackgroundColor)labelBackgroundColor;
- (labelAddToView)labelAddToView;
- (labelTag)labelTag;
- (labelCenter)labelCenter;
- (labelAlpha)labelAlpha;

- (labelFont)labelFont;
- (labelTextColor)labelTextColor;
- (labelText)labelText;
- (labelTextAlignment)labelTextAlignment;
- (labelNumberOfLines)labelNumberOfLines;
- (labelAttributedText)labelAttributedText;
- (labelUserInteractionEnabled)labelUserInteractionEnabled;



@property (nonatomic, copy)labelTapClosure labelTap;

@end
