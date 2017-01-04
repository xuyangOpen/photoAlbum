//
//  UITextView+Reactive.m
//  Category
//
//  Created by 徐杨 on 2016/12/7.
//  Copyright © 2016年 H&X. All rights reserved.
//

#import "UITextView+Reactive.h"

@implementation UITextView (Reactive)

#pragma mark - init
+ (UITextView *)makeTextView:(void (^)(UITextView *))make{
    UITextView *textView = [[UITextView alloc] init];
    make(textView);
    return textView;
}

#pragma mark - frame
- (xvFrame)xvFrame{
    return ^UITextView *(CGRect frame){
        self.frame = frame;
        return self;
    };
}

#pragma mark - backgroundColor
- (xvBackgroundColor)xvBackgroundColor{
    return ^UITextView *(UIColor *color){
        [self setBackgroundColor:color];
        return self;
    };
}

#pragma mark - addToView
- (xvAddToView)xvAddToView{
    return ^UITextView *(UIView *parentView){
        [parentView addSubview:self];
        return self;
    };
}

#pragma mark - tag
- (xvTag)xvTag{
    return ^UITextView *(NSInteger tag){
        self.tag = tag;
        return self;
    };
}

#pragma mark - center
- (xvCenter)xvCenter{
    return ^UITextView *(CGPoint center){
        self.center = center;
        return self;
    };
}

#pragma mark - alpha
- (xvAlpha)xvAlpha{
    return ^UITextView *(CGFloat alpha){
        self.alpha = alpha;
        return self;
    };
}

#pragma mark - delegate
- (xvDelegate)xvDelegate{
    return ^UITextView *(id<UITextViewDelegate> delegate){
        self.delegate = delegate;
        return self;
    };
}

#pragma mark - text
- (xvText)xvText{
    return ^UITextView *(NSString *text){
        self.text = text;
        return self;
    };
}

#pragma mark - font
- (xvFont)xvFont{
    return ^UITextView *(UIFont *font){
        self.font = font;
        return self;
    };
}

#pragma mark - textColor
- (xvTextColor)xvTextColor{
    return ^UITextView *(UIColor *color){
        self.textColor = color;
        return self;
    };
}

#pragma mark - textAlignment
- (xvTextAlignment)xvTextAlignment{
    return ^UITextView *(NSTextAlignment alignment){
        self.textAlignment = alignment;
        return self;
    };
}


@end
