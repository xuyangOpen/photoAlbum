//
//  BaseViewController.h
//  The Other
//
//  Created by 徐杨 on 2016/12/16.
//  Copyright © 2016年 胡凡. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExtensionHeader.h"
#import "AlbumNavigationController.h"

@interface BaseViewController : UIViewController

///导航栏是否隐藏
- (void)setNavigationBarHidden:(BOOL)hidden;
///导航栏主题颜色
- (void)setNavigationBarTintColor:(UIColor *)color;
///导航栏返回按钮文字(在push之后的下个页面显示)
- (void)setNavigationBackBarButtonTitleBeforePush:(NSString *)title;
///导航栏返回按钮文字(当前页面显示)
- (void)setNavigationBackBarButtonTitle:(NSString *)title;
///给导航栏返回按钮添加响应事件
- (void)setNavigationBackBarButtonAddTarget:(id)target action:(SEL)action;
///右侧取消按钮
- (void)setNavigationRightButton:(NSString *)text;
///导航栏右侧的自定义视图
- (void)setnavigationRightView:(UIView *)view;

///状态栏样式
- (void)setStatusBarStyle:(UIStatusBarStyle)style;
///状态栏是否隐藏
- (void)setStatusBarHidden:(BOOL)hide;

///获取导航栏
- (AlbumNavigationController *)getManager;

///弹窗提示
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message;

@end
