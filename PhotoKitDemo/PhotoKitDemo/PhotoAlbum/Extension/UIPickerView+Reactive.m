//
//  UIPickerView+Reactive.m
//  The Other
//
//  Created by 徐杨 on 2016/12/19.
//  Copyright © 2016年 胡凡. All rights reserved.
//

#import "UIPickerView+Reactive.h"

@implementation UIPickerView (Reactive)

+ (UIPickerView *)makePickerView:(void (^)(UIPickerView *))make{
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    make(pickerView);
    return pickerView;
}

#pragma mark - frame
- (pvFrame)pvFrame{
    return ^UIPickerView *(CGRect frame){
        self.frame = frame;
        return self;
    };
}

#pragma mark - backgroundColor
- (pvBackgroundColor)pvBackgroundColor{
    return ^UIPickerView *(UIColor *bgColor){
        [self setBackgroundColor:bgColor];
        return self;
    };
}

#pragma mark - addToView
- (pvAddToView)pvAddToView{
    return ^UIPickerView *(UIView *parentView){
        [parentView addSubview:self];
        return self;
    };
}

#pragma mark - tag
- (pvTag)pvTag{
    return ^UIPickerView *(NSInteger tag){
        self.tag = tag;
        return self;
    };
}

#pragma mark - center
- (pvCenter)pvCenter{
    return ^UIPickerView *(CGPoint center){
        self.center = center;
        return self;
    };
}

#pragma mark - alpha
- (pvAlpha)pvAlpha{
    return ^UIPickerView *(CGFloat alpha){
        self.alpha = alpha;
        return self;
    };
}

#pragma mark - delegate
- (pvDelegate)pvDelegate{
    return ^UIPickerView *(id<UIPickerViewDelegate> delegate){
        self.delegate = delegate;
        return self;
    };
}

#pragma mark - dataSource
- (pvDataSource)pvDataSource{
    return ^UIPickerView *(id<UIPickerViewDataSource> dataSource){
        self.dataSource = dataSource;
        return self;
    };
}

@end
