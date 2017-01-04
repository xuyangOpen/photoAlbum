//
//  UITableView+Reactive.h
//  Category
//
//  Created by 徐杨 on 2016/12/7.
//  Copyright © 2016年 H&X. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseHeader.h"

@interface UITableView (Reactive)

+ (UITableView *)makeTableView:(void (^)(UITableView *))make;
+ (UITableView *)makeTableView:(void (^)(UITableView *))make frame:(CGRect)frame style:(UITableViewStyle)style;

- (tvFrame)tvFrame;
- (tvBackgroundColor)tvBackgroundColor;
- (tvAddToView)tvAddToView;
- (tvTag)tvTag;
- (tvCenter)tvCenter;
- (tvAlpha)tvAlpha;

- (tvDelegate)tvDelegate;
- (tvDataSource)tvDataSource;
- (tvBackgroundView)tvBackgroundView;
- (tvSeparatorColor)tvSeparatorColor;
- (tvSeparatorInset)tvSeparatorInset;
- (tvSeparatorStyle)tvSeparatorStyle;
- (tvRowHeight)tvRowHeight;
- (tvBounces)tvBounces;

@end
