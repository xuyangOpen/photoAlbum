//
//  PhotoPreviewController.m
//  PhotoKitDemo
//
//  Created by 徐杨 on 2016/12/26.
//  Copyright © 2016年 H&X. All rights reserved.
//

#import "PhotoPreviewController.h"
#import "ExtensionHeader.h"
#import "CustomizeButton.h"
#import "AlbumNavigationController.h"
#import "PhotoFlowLayout.h"
#import "PhotoCollectionViewCell.h"
#import "AlbumDetailController.h"
#import "MagicMoveTransiton.h"

#define ITEMSPACE 20

@interface PhotoPreviewController ()<UICollectionViewDelegate,UICollectionViewDataSource,PhotoCollectionViewCellDelegate,UIScrollViewDelegate,UINavigationControllerDelegate>
{
    ///导航栏和底部操作栏是否显示
    BOOL isShow;
    //是否是第一次布局界面（第一次进入界面时，自动滚动到当前下标）
    BOOL isFirst;
    ///pop回去时，是否需要刷新上层界面(内容发生改变时，pop回去则需要刷新)
    BOOL isFresh;
    ///pop回去时，是否需要转场动画
    BOOL isNeedMagic;
}

//底部操作栏
@property (nonatomic, strong) UIButton *finishButton;
@property (nonatomic, strong) UIButton *numberButton;
@property (nonatomic, strong) CustomizeButton *originButton;
///右侧选中或者非选中按钮
@property (nonatomic, strong) UIButton *rightBarButton;
///资源数组
@property (nonatomic, strong) NSArray *assets;

@end

@implementation PhotoPreviewController

static NSString *photoPreviewIdentifier = @"photoPreviewCell";

- initWithAssets:(NSArray *)assets atIndex:(int)index magic:(BOOL)magic{
    if (self = [super init]) {
        //资源数组
        self.assets = [[NSArray alloc] initWithArray:assets];
        isShow = true;                      //导航栏和底部操作栏显示
        self.currentIndex = index;               //当前照片下标
        isFirst = true;                     //第一次布局界面
        isFresh = false;                    //pop回去时，是否需要刷新
        isNeedMagic = magic;                //pop回去时，是否需要转场动画
        //添加下标发生改变时的回调
        [self addObserver:self forKeyPath:@"currentIndex" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

#pragma mark - 视图出现时，禁止左滑返回，视图消失时，允许左滑返回
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = false;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = true;
}

#pragma mark - 视图已经出现时，设置当前控制器为代理
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
}

#pragma mark - 转场动画
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if ([toVC isKindOfClass:[AlbumDetailController class]] && isNeedMagic) {
        MagicMoveTransiton *transition = [[MagicMoveTransiton alloc] initWithType:@"pop" index:self.currentIndex refresh:isFresh];
        return transition;
    }else{
        if (self.refreshComplete) {
            self.refreshComplete(isFresh);
            [self.bottomToolView removeFromSuperview];
        }
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self collectionViewSettings];
    
    [self navigationSettings];
    [self bottomToolBarSettings];
}

#pragma mark - 导航栏设置
- (void)navigationSettings{
    self.title = [NSString stringWithFormat:@"%lu/%lu",(unsigned long)self.currentIndex,(unsigned long)self.assets.count];
    //右侧选中或者非选中按钮
    self.rightBarButton = [UIButton makeButton:^(UIButton *make) {
        make.btnAddTarget(self,@selector(clickRightSelectButton),UIControlEventTouchUpInside).btnFrame(CGRectMake(0, 0, 27, 27));
    }];
    AssetModel *model = self.assets[self.currentIndex-1];
    [self.rightBarButton setImage:[UIImage imageNamed:model.isSelected ? @"photo_sel_photoPickerVc@2x" : @"photo_def_photoPickerVc@2x"] forState:(UIControlStateNormal)];
    [self setnavigationRightView:self.rightBarButton];
}


#pragma mark - 底部操作栏
- (void)bottomToolBarSettings{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    self.bottomToolView = [UIView makeView:^(UIView *make) {
        make.viewAlpha(isNeedMagic?0:1).viewFrame(CGRectMake(0, SCREEN_HEIGHT-44, SCREEN_WIDTH, 44)).viewBackgroundColor([UIColor whiteColor]);
    }];
    [keyWindow addSubview:self.bottomToolView];
    
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wunused-variable"
    UIImageView *bottomLine = [UIImageView makeImageView:^(UIImageView *make) {
        make.ivFrame(CGRectMake(0, 0, SCREEN_WIDTH, 0.5)).ivBackgroundColor(RGB(200, 199, 204, 1.0)).ivAddToView(self.bottomToolView);
    }];
    #pragma clang diagnostic pop
    PhotoKitTool *tool = [PhotoKitTool shareInstance];
    //完成按钮
    self.finishButton = [UIButton makeButton:^(UIButton *make) {
        make.btnFrame(CGRectMake(SCREEN_WIDTH-52, 2, 50, 40)).btnAddTarget([self getManager],@selector(finishTheSelection),UIControlEventTouchUpInside).btnTitleColor(ThemeColor).btnTitleLableFont([UIFont systemFontOfSize:17]).btnTitle(@"完成").btnAddToView(self.bottomToolView);
    }];
    //选中数量
    self.numberButton = [UIButton makeButton:^(UIButton *make) {
        make.btnFrame(CGRectMake(SCREEN_WIDTH-72, 11, 20, 20)).btnTitle([NSString stringWithFormat:@"%li",(unsigned long)tool.selectedAssets.count]).btnLayerMasksToBounds(true).btnLayerCornerRadius(10).btnBackgroundColor(ThemeColor).btnTitleColor([UIColor whiteColor]).btnTitleLableFont([UIFont boldSystemFontOfSize:13]).btnAddToView(self.bottomToolView);
    }];
    
    //如果允许选择原图，则显示原图按钮
    if (tool.isAllowSelectOriginal) {
        //原图按钮
        self.originButton = [[CustomizeButton alloc] initWithFrame:CGRectMake(10, 2, 130, 40) isOrigin:tool.isOriginal];
        HXWeakSelf(self)
        self.originButton.click = ^(UIButton *btn){HXStrongSelf(weakSelf)
            btn.selected = !btn.selected;
            tool.isOriginal = btn.selected;
            //如果选中原图按钮，则计算当前图片的内存大小
            if (btn.selected) {
                [[PhotoKitTool shareInstance] getPhotosBytesWithAsset:strongSelf.assets[strongSelf.currentIndex-1] complete:^(NSString *size) {
                    [strongSelf.originButton setTitle:[NSString stringWithFormat:@"原图(%@)",size] forState:(UIControlStateNormal)];
                }];
            }else{
                [strongSelf.originButton setTitle:@"原图" forState:(UIControlStateNormal)];
            }
        };
        [self.originButton setTitle:@"原图" forState:(UIControlStateNormal)];
        [self.bottomToolView addSubview:self.originButton];
    }
    //更新底部操作按钮状态
    [self reloadBottomInfo];
}

#pragma mark - 更新底部视图
- (void)reloadBottomInfo{
    PhotoKitTool *tool = [PhotoKitTool shareInstance];
    self.numberButton.hidden = (tool.selectedAssets.count == 0) ? true:false;
    [self.numberButton setTitle:[NSString stringWithFormat:@"%li",(unsigned long)tool.selectedAssets.count] forState:(UIControlStateNormal)];
    if (tool.selectedAssets.count == 0) {
        [self.finishButton setTitleColor:[UIColor colorWithRed:0/255.0 green:180/255.0 blue:255/255.0 alpha:0.5] forState:(UIControlStateNormal)];
    }else{
        [self.finishButton setTitleColor:ThemeColor forState:(UIControlStateNormal)];
        [PhotoKitTool showOscillatoryAnimationWithLayer:self.numberButton.layer];
    }
}

#pragma mark - UICollectionView初始化
- (void)collectionViewSettings{
    UICollectionViewFlowLayout *flowLayout = [[PhotoFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH + ITEMSPACE, SCREEN_HEIGHT-64);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    self.photoCollectionView = [UICollectionView makeCollectionView:^(UICollectionView *make) {
        make.cvPagingEnabled(true).cvDataSource(self).cvDelegate(self).cvBackgroundColor([UIColor whiteColor]).cvAddToView(self.view);
    } frame:CGRectZero collectionViewLayout:flowLayout];
    self.photoCollectionView.showsHorizontalScrollIndicator = false;
    
    [self.photoCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view).with.offset(20);
        make.bottom.equalTo(self.view);
    }];
    //注册cell
    [self.photoCollectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:photoPreviewIdentifier];
}

#pragma mark - 页面布局完成，跳转到当前选中下标
- (void)viewDidLayoutSubviews{
    if (isFirst) {
        isFirst = false;
        //滑动到当前照片
        [self.photoCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:false];
    }
}

#pragma mark - UICollectionView代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoPreviewIdentifier forIndexPath:indexPath];
    [cell setModel:self.assets[indexPath.row]];
    
    cell.delegate = self;
    
    return cell;
}
///视图滑动时，通过滑动偏移量计算当前下标
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //获得单位宽
    CGFloat unitWidth = self.photoCollectionView.bounds.size.width;
    //如果当前偏移量小于半个单位宽，则当前下标为1
    if (scrollView.contentOffset.x < unitWidth/2.0) {
        self.currentIndex = 1;
    }else{
        CGFloat offset = scrollView.contentOffset.x / unitWidth;
        CGFloat remainder = (int)scrollView.contentOffset.x % (int)unitWidth;
        //如果余数大于半个屏幕，则index+1
        if (remainder > unitWidth/2.0){
            offset += 1;
        }
        if (offset < self.assets.count && offset > 0) {
            self.currentIndex = offset + 1; //实际照片下标 + 1
        }
    }
}
///监听下标改变的方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqual: @"currentIndex"] && change[@"new"]) {
        self.title = [NSString stringWithFormat:@"%lu/%lu",(unsigned long)self.currentIndex,(unsigned long)self.assets.count];
        //判断是否在数组范围之内
        if (self.currentIndex>0 && self.currentIndex<self.assets.count+1) {
            //设置是否选中的图片
            AssetModel *model = self.assets[self.currentIndex-1];
            [self.rightBarButton setImage:[UIImage imageNamed:model.isSelected ? @"photo_sel_photoPickerVc@2x" : @"photo_def_photoPickerVc@2x"] forState:(UIControlStateNormal)];
            //如果是原图，则计算原图大小
            if ([PhotoKitTool shareInstance].isOriginal) {
                [[PhotoKitTool shareInstance] getPhotosBytesWithAsset:model complete:^(NSString *size) {
                    [self.originButton setTitle:[NSString stringWithFormat:@"原图(%@)",size] forState:(UIControlStateNormal)];
                }];
            }
        }
    }
}

- (void)dealloc{
    [self removeObserver:self forKeyPath:@"currentIndex"];
}
///导航栏右上角的选中按钮点击事件
- (void)clickRightSelectButton{
    AssetModel *model = self.assets[self.currentIndex-1];
   
    //获取管理
    PhotoKitTool *tool = [PhotoKitTool shareInstance];
    if (model.isSelected) {//如果资源没被选中，则将资源从选中数组中移除
        if ([tool.selectedAssets containsObject:model]) {
            [tool.selectedAssets removeObject:model];
            model.isSelected = false;
        }
    }else{//如果资源被选中，则判断资源是否在数组中，如果不在，则添加
        //判断是否超过限制
        if (tool.maxCount == 0 || (tool.maxCount > 0 && tool.maxCount>tool.selectedAssets.count)){//不限制选中数量 或者 在选中数量范围内
            if (![tool.selectedAssets containsObject:model]) {
                [tool.selectedAssets addObject:model];
                model.isSelected = true;
            }
        }else if (tool.maxCount <= tool.selectedAssets.count){//超过数量
            NSString *message = [NSString stringWithFormat:@"最多只能选中%ld张",(long)tool.maxCount];
            [self showAlertWithTitle:@"提示" message:message];
        }
    }
//    model.isSelected = !model.isSelected;
    [self.rightBarButton setImage:[UIImage imageNamed:model.isSelected ? @"photo_sel_photoPickerVc@2x" : @"photo_def_photoPickerVc@2x"] forState:(UIControlStateNormal)];
    isFresh = true;//需要刷新
    //点击右上角按钮的时候，更新右下角的选中图片数量按钮
    [self reloadBottomInfo];
}

#pragma mark - cell的代理方法
- (void)showOrHideOperationToolBar{
    isShow = !isShow;
    if (isShow) {
        [self.navigationController setNavigationBarHidden:false animated:true];
        [self setBottomToolBarHidden:false];
        //将window的优先级恢复成默认
        [UIApplication sharedApplication].keyWindow.windowLevel = UIWindowLevelNormal;
    }else{
        [self.navigationController setNavigationBarHidden:true animated:true];
        [self setBottomToolBarHidden:true];
        //将window的优先级提高到statusBar，隐藏statusBar
        [UIApplication sharedApplication].keyWindow.windowLevel = UIWindowLevelStatusBar;
    }
}

#pragma mark - toolbar的隐藏或显示
- (void)setBottomToolBarHidden:(BOOL)hide{
    [UIView animateWithDuration:0.2 animations:^{
        if (hide) {
            self.bottomToolView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 44);
        }else{
            self.bottomToolView.frame = CGRectMake(0, SCREEN_HEIGHT-44, SCREEN_WIDTH, 44);
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
