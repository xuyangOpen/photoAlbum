//
//  UITextField+Reactive.m
//  Category
//
//  Created by 徐杨 on 2016/12/7.
//  Copyright © 2016年 H&X. All rights reserved.
//

#import "UITextField+Reactive.h"

@implementation UITextField (Reactive)

#pragma mark - init
+ (UITextField *)makeTextField:(void (^)(UITextField *))make{
    UITextField *field = [[UITextField alloc] init];
    make(field);
    return field;
}

#pragma mark - frame
- (tfFrame)tfFrame{
    return ^UITextField *(CGRect frame){
        self.frame = frame;
        return self;
    };
}

#pragma mark - backgroundColor
- (tfBackgroundColor)tfBackgroundColor{
    return ^UITextField *(UIColor *color){
        [self setBackgroundColor:color];
        return self;
    };
}

#pragma mark - addToView
- (tfAddToView)tfAddToView{
    return ^UITextField *(UIView *parentView){
        [parentView addSubview:self];
        return self;
    };
}

#pragma mark - tag
- (tfTag)tfTag{
    return ^UITextField *(NSInteger tag){
        self.tag = tag;
        return self;
    };
}

#pragma mark - center
- (tfCenter)tfCenter{
    return ^UITextField *(CGPoint center){
        self.center = center;
        return self;
    };
}

#pragma mark - alpha
- (tfAlpha)tfAlpha{
    return ^UITextField *(CGFloat alpha){
        self.alpha = alpha;
        return self;
    };
}

#pragma mark - text
- (tfText)tfText{
    return ^UITextField *(NSString *text){
        self.text = text;
        return self;
    };
}

#pragma mark - attributedText
- (tfAttributedText)tfAttributedText{
    return ^UITextField *(NSAttributedString *attr){
        self.attributedText = attr;
        return self;
    };
}

#pragma mark - textColor
- (tfTextColor)tfTextColor{
    return ^UITextField *(UIColor *color){
        self.textColor = color;
        return self;
    };
}

#pragma mark - font
- (tfFont)tfFont{
    return ^UITextField *(UIFont *font){
        self.font = font;
        return self;
    };
}

#pragma mark - textAlignment
- (tfTextAlignment)tfTextAlignment{
    return ^UITextField *(NSTextAlignment alignment){
        self.textAlignment = alignment;
        return self;
    };
}

#pragma mark - borderStyle
- (tfBorderStyle)tfBorderStyle{
    return ^UITextField *(UITextBorderStyle style){
        self.borderStyle = style;
        return self;
    };
}

#pragma mark - placeholder
- (tfPlaceholder)tfPlaceholder{
    return ^UITextField *(NSString *placeholder){
        self.placeholder = placeholder;
        return self;
    };
}

#pragma mark - delegate
- (tfDelegate)tfDelegate{
    return ^UITextField *(id<UITextFieldDelegate> delegate){
        self.delegate = delegate;
        return self;
    };
}

#pragma mark - leftView
- (tfLeftView)tfLeftView{
    return ^UITextField *(UIView *leftView){
        self.leftView = leftView;
        return self;
    };
}

#pragma mark - rightView
- (tfRightView)tfRightView{
    return ^UITextField *(UIView *rightView){
        self.rightView = rightView;
        return self;
    };
}

#pragma mark - rightViewMode
- (tfRightViewMode)tfRightViewMode{
    return ^UITextField *(UITextFieldViewMode mode){
        self.rightViewMode = mode;
        return self;
    };
}

#pragma mark - keyboardType
- (tfKeyboardType)tfKeyboardType{
    return ^UITextField *(UIKeyboardType type){
        self.keyboardType = type;
        return self;
    };
}

#pragma mark - tintColor
- (tfTintColor)tfTintColor{
    return ^UITextField *(UIColor *tintColor){
        self.tintColor = tintColor;
        return self;
    };
}

#pragma mark - secureTextEntry
- (tfSecureTextEntry)tfSecureTextEntry{
    return ^UITextField *(BOOL flag){
        self.secureTextEntry = flag;
        return self;
    };
}

@end
