//
//  UIPickerView+Reactive.h
//  The Other
//
//  Created by 徐杨 on 2016/12/19.
//  Copyright © 2016年 胡凡. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseHeader.h"

@interface UIPickerView (Reactive)

+ (UIPickerView *)makePickerView:(void (^)(UIPickerView *))make;

- (pvFrame)pvFrame;
- (pvBackgroundColor)pvBackgroundColor;
- (pvAddToView)pvAddToView;
- (pvTag)pvTag;
- (pvCenter)pvCenter;
- (pvAlpha)pvAlpha;

- (pvDelegate)pvDelegate;
- (pvDataSource)pvDataSource;

@end
