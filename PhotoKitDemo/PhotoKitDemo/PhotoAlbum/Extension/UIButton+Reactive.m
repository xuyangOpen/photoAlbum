//
//  UIButton+Reactive.m
//  Category
//
//  Created by 徐杨 on 2016/12/5.
//  Copyright © 2016年 H&X. All rights reserved.
//

#import "UIButton+Reactive.h"
#import <objc/runtime.h>
//私有属性
UIButton *button;
static const void *associatedKey = "associatedKey";

//C方法实现
UIButton *buttonInit() {
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    return button;
}

CGFloat HXFloat(CGFloat width){
    return width/414.0 * [UIScreen mainScreen].bounds.size.width;
}

@implementation UIButton (Reactive)

#pragma mark - init
+ (UIButton *)makeButton:(void (^)(UIButton *))make{
    UIButton *btn = buttonInit();
    make(btn);
    return btn;
}

#pragma mark - 属性设置
- (UIButton *)addAttribute:(void (^)(UIButton *))make{
    make(self);
    return self;
}

#pragma mark - frame
- (btnFrame)btnFrame{
    return ^UIButton *(CGRect frame){
        self.frame = frame;
        return self;
    };
}

#pragma mark - backgroundColor
- (btnBackgroundColor)btnBackgroundColor{
    return ^UIButton *(UIColor *color){
        [self setBackgroundColor:color];
        return self;
    };
}

#pragma mark - addToView
- (btnAddToView)btnAddToView{
    return ^UIButton *(UIView *parentView){
        [parentView addSubview:self];
        return self;
    };
}

#pragma mark - font
- (btnTitleLableFont)btnTitleLableFont{
    return ^UIButton *(UIFont *font){
        self.titleLabel.font = font;
        return self;
    };
}

#pragma mark - title
- (btnTitle)btnTitle{
    return ^UIButton *(NSString *title){
        [self setTitle:title forState:(UIControlStateNormal)];
        return self;
    };
}

#pragma mark - titleForState
- (btnTitleForState)btnTitleForState{
    return ^UIButton *(NSString *title, UIControlState state){
        [self setTitle:title forState:state];
        return self;
    };
}

#pragma mark - titleColor
- (btnTitleColor)btnTitleColor{
    return ^UIButton *(UIColor *color){
        [self setTitleColor:color forState:(UIControlStateNormal)];
        return self;
    };
}

#pragma mark - titleColorForState
- (btnTitleColorForState)btnTitleColorForState{
    return ^UIButton *(UIColor *color,UIControlState state){
        [self setTitleColor:color forState:state];
        return self;
    };
}

#pragma mark - image
- (btnImage)btnImage{
    return ^UIButton *(UIImage *image){
        [self setImage:image forState:(UIControlStateNormal)];
        return self;
    };
}

#pragma mark - imageForState
- (btnImageForState)btnImageForState{
    return ^UIButton *(UIImage *image, UIControlState state){
        [self setImage:image forState:state];
        return self;
    };
}

#pragma mark - titleEdgeInsets
- (btnTitleEdgeInsets)btnTitleEdgeInsets{
    return ^UIButton *(UIEdgeInsets edge){
        [self setTitleEdgeInsets:edge];
        return self;
    };
}

#pragma mark - imageEdgeInsets
- (btnImageEdgeInsets)btnImageEdgeInsets{
    return ^UIButton *(UIEdgeInsets edge){
        [self setImageEdgeInsets:edge];
        return self;
    };
}

#pragma mark - contentEdgeInsets
- (btnContentEdgeInsets)btnContentEdgeInsets{
    return ^UIButton *(UIEdgeInsets edge){
        [self setContentEdgeInsets:edge];
        return self;
    };
}

#pragma mark - center
- (btnCenter)btnCenter{
    return ^UIButton *(CGPoint center){
        self.center = center;
        return self;
    };
}

#pragma mark - alpha
- (btnAlpha)btnAlpha{
    return ^UIButton *(CGFloat alpha){
        self.alpha = alpha;
        return self;
    };
}

#pragma mark - addTarget
- (btnAddTarget)btnAddTarget{
    return ^UIButton *(id target, SEL sel, UIControlEvents events){
        [self addTarget:target action:sel forControlEvents:events];
        return self;
    };
}

#pragma mark - tag
- (btnTag)btnTag{
    return ^UIButton *(NSInteger tag){
        self.tag = tag;
        return self;
    };
}

#pragma mark - layer.cornerRadius
- (btnLayerCornerRadius)btnLayerCornerRadius{
    return ^UIButton *(CGFloat radius){
        self.layer.cornerRadius = radius;
        return self;
    };
}

#pragma mark - layer.masksToBounds
- (btnLayerMasksToBounds)btnLayerMasksToBounds{
    return ^UIButton *(BOOL flag){
        self.layer.masksToBounds = flag;
        return self;
    };
}

#pragma mark - layer.borderColor
- (btnLayerBorderColor)btnLayerBorderColor{
    return ^UIButton *(UIColor *borderColor){
        self.layer.borderColor = borderColor.CGColor;
        return self;
    };
}

#pragma mark - layer.borderWidth
- (btnLayerBorderWidth)btnLayerBorderWidth{
    return ^UIButton *(CGFloat borderWidth){
        self.layer.borderWidth = borderWidth;
        return self;
    };
}

#pragma mark - clickClosure
- (void)setClick:(btnClickClosure)click{
    objc_setAssociatedObject(self, associatedKey, click, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self removeTarget:self action:@selector(buttonClick) forControlEvents:(UIControlEventTouchUpInside)];
    !click ? : [self addTarget:self action:@selector(buttonClick) forControlEvents:(UIControlEventTouchUpInside)];
}

- (btnClickClosure)click{
    return objc_getAssociatedObject(self, associatedKey);
}

-(void)buttonClick{
    !self.click ? : self.click(self);
}

@end



