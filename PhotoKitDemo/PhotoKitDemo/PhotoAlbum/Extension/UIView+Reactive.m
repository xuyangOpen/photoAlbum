//
//  UIView+Reactive.m
//  Category
//
//  Created by 徐杨 on 2016/12/5.
//  Copyright © 2016年 H&X. All rights reserved.
//

#import "UIView+Reactive.h"
#import <objc/runtime.h>

UIView *view;
static const void *viewTapKey = "uiviewTapKey";

UIView *viewInit(){
    return [[UIView alloc] init];
}

@implementation UIView (Reactive)

+ (UIView *)makeView:(void (^)(UIView *))make{
    UIView *view = viewInit();
    make(view);
    return view;
}

#pragma mark - frame
- (viewFrame)viewFrame{
    return ^UIView *(CGRect frame){
        self.frame = frame;
        return self;
    };
}

#pragma mark - backgroundColor
- (viewBackgroundColor)viewBackgroundColor{
    return ^UIView *(UIColor *color){
        [self setBackgroundColor:color];
        return self;
    };
}

#pragma mark - addToView
- (viewAddToView)viewAddToView{
    return ^UIView *(UIView *parentView){
        [parentView addSubview:self];
        return self;
    };
}

#pragma mark - tag
- (viewTag)viewTag{
    return ^UIView *(NSInteger tag){
        self.tag = tag;
        return self;
    };
}

#pragma mark - center
- (viewCenter)viewCenter{
    return ^UIView *(CGPoint center){
        self.center = center;
        return self;
    };
}

#pragma mark - alpha
- (viewAlpha)viewAlpha{
    return ^UIView *(CGFloat alpha){
        self.alpha = alpha;
        return self;
    };
}

#pragma mark - tap
- (void)setViewTap:(viewTapClosure)viewTap{
    objc_setAssociatedObject(self, viewTapKey, viewTap, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (self.viewTap != nil) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFunction)];
        [self addGestureRecognizer:tap];
    }
}

- (viewTapClosure)viewTap{
    return objc_getAssociatedObject(self, viewTapKey);
}

- (void)tapFunction{
    !self.viewTap ? : self.viewTap(self);
}

@end
