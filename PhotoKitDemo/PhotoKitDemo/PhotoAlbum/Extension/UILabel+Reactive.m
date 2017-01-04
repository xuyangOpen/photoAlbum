//
//  UILabel+Reactive.m
//  Category
//
//  Created by 徐杨 on 2016/12/6.
//  Copyright © 2016年 H&X. All rights reserved.
//

#import "UILabel+Reactive.h"
#import <objc/runtime.h>

UILabel *label;
static const void *labelTapKey = "uilabelTapKey";

UILabel *labelInit(){
    return [[UILabel alloc] init];
}

@implementation UILabel (Reactive)

+ (UILabel *)makeLabel:(void (^)(UILabel *))make{
    UILabel *label = labelInit();
    make(label);
    return label;
}

#pragma mark - frame
- (labelFrame)labelFrame{
    return ^UILabel *(CGRect frame){
        self.frame = frame;
        return self;
    };
}

#pragma mark - backgroundColor
- (labelBackgroundColor)labelBackgroundColor{
    return ^UILabel *(UIColor *color){
        [self setBackgroundColor:color];
        return self;
    };
}

#pragma mark - addToView
- (labelAddToView)labelAddToView{
    return ^UILabel *(UIView *parentView){
        [parentView addSubview:self];
        return self;
    };
}

#pragma mark - tag
- (labelTag)labelTag{
    return ^UILabel *(NSInteger tag){
        self.tag = tag;
        return self;
    };
}

#pragma mark - font
- (labelFont)labelFont{
    return ^UILabel *(UIFont *font){
        self.font = font;
        return self;
    };
}

#pragma mark - textColor
- (labelTextColor)labelTextColor{
    return ^UILabel *(UIColor *color){
        self.textColor = color;
        return self;
    };
}

#pragma mark - text
- (labelText)labelText{
    return ^UILabel *(NSString *text){
        self.text = text;
        return self;
    };
}

#pragma mark - textAlignment
- (labelTextAlignment)labelTextAlignment{
    return ^UILabel *(NSTextAlignment alignment){
        [self setTextAlignment:alignment];
        return self;
    };
}

#pragma mark - numberOfLines
- (labelNumberOfLines)labelNumberOfLines{
    return ^UILabel *(int lines){
        [self setNumberOfLines:lines];
        return self;
    };
}

#pragma mark - attributedText
- (labelAttributedText)labelAttributedText{
    return ^UILabel *(NSAttributedString *attri){
        self.attributedText = attri;
        return self;
    };
}

#pragma mark - userInteractionEnabled
- (labelUserInteractionEnabled)labelUserInteractionEnabled{
    return ^UILabel *(BOOL flag){
        [self setUserInteractionEnabled:flag];
        return self;
    };
}

#pragma mark - center
- (labelCenter)labelCenter{
    return ^UILabel *(CGPoint center){
        self.center = center;
        return self;
    };
}

#pragma mark - alpha
- (labelAlpha)labelAlpha{
    return ^UILabel *(CGFloat alpha){
        self.alpha = alpha;
        return self;
    };
}

#pragma mark - tap
- (void)setLabelTap:(labelTapClosure)labelTap{
    objc_setAssociatedObject(self, labelTapKey, labelTap, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (labelTap) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFunction)];
        [self addGestureRecognizer:tap];
    }
}

- (labelTapClosure)labelTap{
    return objc_getAssociatedObject(self, labelTapKey);
}

- (void)tapFunction{
    !self.labelTap ? : self.labelTap(self);
}


@end
