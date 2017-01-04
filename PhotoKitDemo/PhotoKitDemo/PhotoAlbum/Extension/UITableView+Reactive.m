//
//  UITableView+Reactive.m
//  Category
//
//  Created by 徐杨 on 2016/12/7.
//  Copyright © 2016年 H&X. All rights reserved.
//

#import "UITableView+Reactive.h"

@implementation UITableView (Reactive)

#pragma mark - init
+ (UITableView *)makeTableView:(void (^)(UITableView *))make{
    UITableView *tableView = [[UITableView alloc] init];
    make(tableView);
    return tableView;
}

+ (UITableView *)makeTableView:(void (^)(UITableView *))make frame:(CGRect)frame style:(UITableViewStyle)style{
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:style];
    make(tableView);
    return tableView;
}

#pragma mark - frame
- (tvFrame)tvFrame{
    return ^UITableView *(CGRect frame){
        self.frame = frame;
        return self;
    };
}

#pragma mark - backgroundColor
- (tvBackgroundColor)tvBackgroundColor{
    return ^UITableView *(UIColor *color){
        [self setBackgroundColor:color];
        return self;
    };
}

#pragma mark - addToView
- (tvAddToView)tvAddToView{
    return ^UITableView *(UIView *parentView){
        [parentView addSubview:self];
        return self;
    };
}

#pragma mark - tag
- (tvTag)tvTag{
    return ^UITableView *(NSInteger tag){
        self.tag = tag;
        return self;
    };
}

#pragma mark - center
- (tvCenter)tvCenter{
    return ^UITableView *(CGPoint center){
        self.center = center;
        return self;
    };
}

#pragma mark - alpha
- (tvAlpha)tvAlpha{
    return ^UITableView *(CGFloat alpha){
        self.alpha = alpha;
        return self;
    };
}

#pragma mark - delegate
- (tvDelegate)tvDelegate{
    return ^UITableView *(id<UITableViewDelegate> delegate){
        self.delegate = delegate;
        return self;
    };
}

#pragma mark - dataSource
- (tvDataSource)tvDataSource{
    return ^UITableView *(id<UITableViewDataSource> dataSource){
        self.dataSource = dataSource;
        return self;
    };
}

#pragma mark - backgroundView
- (tvBackgroundView)tvBackgroundView{
    return ^UITableView *(UIView *view){
        self.backgroundView = view;
        return self;
    };
}

#pragma mark - separatorColor
- (tvSeparatorColor)tvSeparatorColor{
    return ^UITableView *(UIColor *color){
        [self setSeparatorColor:color];
        return self;
    };
}

#pragma mark - separatorInset
- (tvSeparatorInset)tvSeparatorInset{
    return ^UITableView *(UIEdgeInsets edge){
        [self setSeparatorInset:edge];
        return self;
    };
}

#pragma mark - separatorStyle
- (tvSeparatorStyle)tvSeparatorStyle{
    return ^UITableView *(UITableViewCellSeparatorStyle style){
        [self setSeparatorStyle:style];
        return self;
    };
}

#pragma mark - rowHeight
- (tvRowHeight)tvRowHeight{
    return ^UITableView *(CGFloat rowHeight){
        self.rowHeight = rowHeight;
        return self;
    };
}

#pragma mark - bounces
- (tvBounces)tvBounces{
    return ^UITableView *(BOOL bounces){
        self.bounces = bounces;
        return self;
    };
}

@end
