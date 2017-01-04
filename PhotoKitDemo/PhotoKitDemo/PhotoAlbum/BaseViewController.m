//
//  BaseViewController.m
//  The Other
//
//  Created by 徐杨 on 2016/12/16.
//  Copyright © 2016年 胡凡. All rights reserved.
//

#import "BaseViewController.h"

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //默认：导航栏显示、状态栏黑色、导航栏主题色黑色
    [self setNavigationBarHidden:false];
    [self setStatusBarStyle:(UIStatusBarStyleDefault)];
    [self setNavigationBarTintColor:[UIColor blackColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

#pragma mark - 导航栏
#pragma mark - 导航栏是否隐藏
- (void)setNavigationBarHidden:(BOOL)hidden{
    [self.navigationController setNavigationBarHidden:hidden];
}

#pragma mark - 导航栏主题颜色
- (void)setNavigationBarTintColor:(UIColor *)color{
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
}

#pragma mark - 导航栏返回按钮文字(在push后的下个界面显示)
- (void)setNavigationBackBarButtonTitleBeforePush:(NSString *)title{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = title;
    self.navigationItem.backBarButtonItem = backItem;
}

#pragma mark - 导航栏返回按钮文字(当前页面显示)
- (void)setNavigationBackBarButtonTitle:(NSString *)title{
    UIBarButtonItem *item = (UIBarButtonItem *)self.navigationController.navigationBar.topItem;
    item.title = title;
}

#pragma mark - 给导航栏返回按钮添加响应事件
- (void)setNavigationBackBarButtonAddTarget:(id)target action:(SEL)action{
    UIBarButtonItem *item = (UIBarButtonItem *)self.navigationController.navigationBar.topItem;
    
    UIButton *backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    backBtn.frame = CGRectMake(-15, 0, 100, 50);
    [backBtn setTitle:item.title forState:(UIControlStateNormal)];
    [backBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [backBtn addTarget:target action:action forControlEvents:(UIControlEventTouchUpInside)];
    [backBtn setImage:[UIImage imageNamed:@"Artboard 2"] forState:(UIControlStateNormal)];
    [backBtn setContentEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
    [backBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    
    UIBarButtonItem *newItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    newItem.style = UIBarButtonSystemItemFixedSpace;
    
    self.navigationItem.leftBarButtonItem = newItem;
}

#pragma mark - 状态栏样式
- (void)setStatusBarStyle:(UIStatusBarStyle)style{
    [[UIApplication sharedApplication] setStatusBarStyle:style animated:true];
}

#pragma mark - 状态栏是否隐藏
- (void)setStatusBarHidden:(BOOL)hide{
    [[UIApplication sharedApplication] setStatusBarHidden:hide withAnimation:(UIStatusBarAnimationSlide)];
}


#pragma mark - 右侧取消按钮
- (void)setNavigationRightButton:(NSString *)text{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:text style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarButtonAction)];
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark - 右侧取消按钮事件
- (void)rightBarButtonAction{
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - 导航栏右侧的自定义视图
- (void)setnavigationRightView:(UIView *)view{
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:view];
    rightBarButton.style = UIBarButtonSystemItemFixedSpace;
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

#pragma mark - 获取导航栏
- (AlbumNavigationController *)getManager{
    AlbumNavigationController *manager = (AlbumNavigationController *)self.navigationController;
    return manager;
}

#pragma mark - 弹窗提示
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"好" style:(UIAlertActionStyleDestructive) handler:nil];
    [alert addAction:confirmAction];
    [self presentViewController:alert animated:true completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
