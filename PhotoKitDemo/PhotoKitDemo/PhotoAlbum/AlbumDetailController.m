//
//  AlbumDetailController.m
//  PhotoKit读取相册内容
//
//  Created by 徐杨 on 2016/12/21.
//  Copyright © 2016年 H&X. All rights reserved.
//

#import "AlbumDetailController.h"
#import "PhotoKitTool.h"
#import "PhotoPreviewController.h"
#import "MagicMoveTransiton.h"
#import "AlbumDetailCollectionViewCell.h"


@interface AlbumDetailController ()<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate>
{
    //每个item的大小
    CGFloat itemUnit;
    //是否已经调用滑动到底部的方法
    BOOL isScrollToBottom;
    //预加载的rect
    CGRect previousPreheatRect;
}

@property (nonatomic, strong) PHAssetCollection *album;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) AlbumModel *albumModel;
#pragma mark - 底部操作栏
@property (nonatomic, strong) UIView *bottomToolView;
@property (nonatomic, strong) UIButton *finishButton;
@property (nonatomic, strong) UIButton *numberButton;
///预览按钮
@property (nonatomic, strong) UIButton *previewButton;
//是否需要转场动画
@property (nonatomic, assign) BOOL isNeedMagic;

@end

@implementation AlbumDetailController

static NSString *albumDetailIdentifier = @"albumDetailIdentifier";

- (instancetype)initWithAlbum:(PHAssetCollection *)album{
    if (self = [super init]) {
        self.album = album;
        //计算item的大小 每行4个 间隔3
        itemUnit = (SCREEN_WIDTH-3*5) / 4.0;
        //是否滑动到底部
        isScrollToBottom = false;
        //初始化
        self.albumModel = [[PhotoKitTool shareInstance] getAlbumModeFromAlbum:self.album];
        //预加载空间
        previousPreheatRect = CGRectZero;
    }
    return self;
}

#pragma mark - 检查传入的默认选中数组是否存在
- (void)checkOutDefaultAssets{
    //从模型中获取所有的PHAsset资源
    NSArray<PHAsset *> *allAssets = [self.albumModel getAssetsList];
    PhotoKitTool *tool = [PhotoKitTool shareInstance];
    //判断传入的资源数组是否为空
    if (tool.defaultAssets.count > 0) {
        for (int i=0; i<allAssets.count; i++) {
            NSString *originalId = [[PhotoKitTool shareInstance] getAssetIdentifier:allAssets[i]];
            for (int j=0; j<tool.defaultAssets.count; j++) {
                PHAsset *asset = tool.defaultAssets[j];
                NSString *aId = [[PhotoKitTool shareInstance] getAssetIdentifier:asset];
                //将传入的资源id与当前相册的资源id比较，如果相同，则添加到已选数组中
                if ([originalId isEqualToString:aId]) {
                    NSMutableArray *selectedAssets = tool.selectedAssets;
                    if (![selectedAssets containsObject:self.albumModel.assetsArray[i]]) {
                        AssetModel *model = self.albumModel.assetsArray[i];
                        model.isSelected = true;
                        [selectedAssets addObject:model];
                    }
                }
            }
        }
        //配置完成之后，将默认选中资源数组置空
        tool.defaultAssets = nil;
    }
}

#pragma mark - 视图即将出现
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 这是的转场动画属于自定义push 由导航栏来控制
    // 属于导航控制器来负责转场
    // 我们让当前控制器来作为 UINavigationControllerDelegate代理对象， 并实现协议方法。
    self.navigationController.delegate = self;
}

#pragma mark - 转场动画
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if ([toVC isKindOfClass:[PhotoPreviewController class]] && self.isNeedMagic) {
        MagicMoveTransiton *transition = [[MagicMoveTransiton alloc] initWithType:@"push" index:0 refresh:false];
        return transition;
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //检查默认值
    [self checkOutDefaultAssets];
    //通用设置
    [self generalSettings];
    
    [self collectionViewSettings];
    
    [self bottomSettings];
}

#pragma mark - 通用设置
- (void)generalSettings{
    self.title = [[PhotoKitTool shareInstance] getAlbumName:self.album];
    [self setNavigationRightButton:@"取消"];
}


#pragma mark - Bottom操作栏设置
- (void)bottomSettings{
    self.bottomToolView = [UIView makeView:^(UIView *make) {
        make.viewFrame(CGRectMake(0, SCREEN_HEIGHT-44, SCREEN_WIDTH, 44)).viewBackgroundColor([UIColor whiteColor]).viewAddToView(self.view);
    }];
    UIImageView *bottomLine = [UIImageView makeImageView:^(UIImageView *make) {
        make.ivBackgroundColor(RGB(200, 199, 204, 1.0)).ivAddToView(self.bottomToolView);
    }];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomToolView);
        make.left.equalTo(self.bottomToolView);
        make.right.equalTo(self.bottomToolView);
        make.height.mas_equalTo(0.5);
    }];
    //完成按钮
    self.finishButton = [UIButton makeButton:^(UIButton *make) {
        make.btnAddTarget([self getManager],@selector(finishTheSelection),UIControlEventTouchUpInside).btnTitleColor(ThemeColor).btnTitleLableFont([UIFont systemFontOfSize:17]).btnTitle(@"完成").btnAddToView(self.bottomToolView);
    }];
    [self.finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomToolView).with.offset(-2);
        make.bottom.equalTo(self.bottomToolView).with.offset(-2);
        make.size.mas_equalTo(CGSizeMake(50, 40));
    }];
    //选中数量
    self.numberButton = [UIButton makeButton:^(UIButton *make) {
        make.btnLayerMasksToBounds(true).btnLayerCornerRadius(10).btnBackgroundColor(ThemeColor).btnTitleColor([UIColor whiteColor]).btnTitleLableFont([UIFont boldSystemFontOfSize:13]).btnAddToView(self.view);
    }];
    [self.numberButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.finishButton.mas_left);
        make.centerY.equalTo(self.finishButton);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    //预览按钮
    self.previewButton = [UIButton makeButton:^(UIButton *make) {
        make.btnTitleLableFont([UIFont systemFontOfSize:17]).btnTitleColor(ThemeColor).btnTitle(@"预览").btnAddToView(self.view);
    }];
    HXWeakSelf(self)
    self.previewButton.click = ^(UIButton *btn){HXStrongSelf(weakSelf)
        PhotoKitTool *tool = [PhotoKitTool shareInstance];
        if (tool.selectedAssets.count > 0) {
            PhotoPreviewController *preview = [[PhotoPreviewController alloc] initWithAssets:tool.selectedAssets atIndex:1 magic:false];
            preview.refreshComplete = ^(BOOL refresh){
                if (refresh) {
                    [strongSelf.photoCollectionView reloadData];
                    [strongSelf reloadBottomInfo];
                }
            };
            //不需要转场动画
            strongSelf.isNeedMagic = false;
            [strongSelf.navigationController pushViewController:preview animated:true];
        }
    };
    [self.previewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomToolView).with.offset(2);
        make.centerY.equalTo(self.finishButton);
        make.size.mas_equalTo(CGSizeMake(50, 40));
    }];
    //布局按钮完成之后，更新底部视图按钮状态
    [self reloadBottomInfo];
}

#pragma mark - UICollectionView设置
- (void)collectionViewSettings{
    //布局
    self.flowLayout = [UICollectionViewFlowLayout makeCollectionViewFlowLayout:^(UICollectionViewFlowLayout *make) {
        make.cvfItemSize(CGSizeMake(itemUnit, itemUnit)).cvfMinimumInteritemSpacing(3).cvfMinimumLineSpacing(3).cvfScrollDirection(UICollectionViewScrollDirectionVertical);
    }];
    //视图
    self.photoCollectionView = [UICollectionView makeCollectionView:^(UICollectionView *make) {
        make.cvFrame(CGRectMake(3, 0, SCREEN_WIDTH-6, SCREEN_HEIGHT-64-44)).cvShowsHorizontalScrollIndicator(false).cvBackgroundColor([UIColor whiteColor]).cvDataSource(self).cvDelegate(self).cvAddToView(self.view);
    } frame:CGRectZero collectionViewLayout:self.flowLayout];
    [self.photoCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view).with.offset(3);
        make.right.equalTo(self.view).with.offset(-3);
        make.bottom.equalTo(self.view).with.offset(-44);
    }];
    //注册cell
    [self.photoCollectionView registerClass:[AlbumDetailCollectionViewCell class] forCellWithReuseIdentifier:albumDetailIdentifier];

}

#pragma mark - 视图布局完成之后，将视图滑动到底部
- (void)viewDidLayoutSubviews{
    if (!isScrollToBottom && self.albumModel.assetsArray.count > 0) {
        [self.photoCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.albumModel.assetsArray.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:false];
        isScrollToBottom = true;
    }
    
}

#pragma mark - UICollectionView代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.albumModel.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AlbumDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:albumDetailIdentifier forIndexPath:indexPath];
    //判断是否选中
    AssetModel *model = self.albumModel.assetsArray[indexPath.row];
    
    PhotoKitTool *tool = [PhotoKitTool shareInstance];
    if ([tool.selectedAssets containsObject:model]) {
        model.isSelected = true;
    }else{
        model.isSelected = false;
    }
    //设置模型
    cell.model = model;
    cell.tag = indexPath.row;
    HXWeakSelf(self)
    //选中时的回调
    cell.selectClosure = ^(AssetModel *assetModel, BOOL isSelected, AlbumDetailCollectionViewCell *blockCell){
        HXStrongSelf(weakSelf)
        if (isSelected) {//如果是选中，则判断是否超过选中数量
            if (tool.maxCount == 0 || (tool.maxCount > 0 && tool.maxCount>tool.selectedAssets.count)){//不限制选中数量 或者 在选中数量范围内
                assetModel.isSelected = true;
                blockCell.isSelected = true;
                [tool.selectedAssets addObject:assetModel];
            }else if(tool.maxCount <= tool.selectedAssets.count){//超过数量
                NSString *message = [NSString stringWithFormat:@"最多只能选中%ld张",(long)tool.maxCount];
                [strongSelf showAlertWithTitle:@"提示" message:message];
            }
        }else{//取消选中
            if ([tool.selectedAssets containsObject:assetModel]) {
                assetModel.isSelected = false;
                blockCell.isSelected = false;
                [tool.selectedAssets removeObject:assetModel];
            }
        }
        [strongSelf reloadBottomInfo];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoPreviewController *preview = [[PhotoPreviewController alloc] initWithAssets:self.albumModel.assetsArray atIndex:(int)indexPath.item + 1 magic:true];
    //需要转场动画
    self.isNeedMagic = true;
    [self.navigationController pushViewController:preview animated:true];
}

#pragma mark - 判断方向
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [self updateCachedAssets];
}

#pragma mark - 更新底部视图
- (void)reloadBottomInfo{
    PhotoKitTool *tool = [PhotoKitTool shareInstance];
    self.numberButton.hidden = (tool.selectedAssets.count == 0) ? true:false;
    [self.numberButton setTitle:[NSString stringWithFormat:@"%li",(unsigned long)tool.selectedAssets.count] forState:(UIControlStateNormal)];
    if (tool.selectedAssets.count == 0) {
        [self.previewButton setTitleColor:[UIColor colorWithRed:0/255.0 green:180/255.0 blue:255/255.0 alpha:0.5] forState:(UIControlStateNormal)];
        [self.finishButton setTitleColor:[UIColor colorWithRed:0/255.0 green:180/255.0 blue:255/255.0 alpha:0.5] forState:(UIControlStateNormal)];
    }else{
        [self.previewButton setTitleColor:ThemeColor forState:(UIControlStateNormal)];
        [self.finishButton setTitleColor:ThemeColor forState:(UIControlStateNormal)];
        [PhotoKitTool showOscillatoryAnimationWithLayer:self.numberButton.layer];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 更新缓存
- (void)updateCachedAssets
{
    BOOL isViewVisible = [self isViewLoaded] && [[self view] window] != nil;
    if (!isViewVisible) { return; }
    
    // 预加载窗口是可见矩形高度的两倍
    CGRect preheatRect = self.view.bounds;
    preheatRect = CGRectInset(preheatRect, 0.0f, -0.5f * self.view.bounds.size.height);
    
    // If scrolled by a "reasonable" amount...
    CGFloat delta = ABS(CGRectGetMidY(preheatRect) - CGRectGetMidY(previousPreheatRect));
    //仅在可见区域与最近预加载区域明显不同时更新。
    if (delta > CGRectGetHeight(self.photoCollectionView.bounds) / 3.0f) {
        // 计算需要开始缓存和停止缓存的资源
        NSMutableArray *addedIndexPaths = [NSMutableArray array];
        NSMutableArray *removedIndexPaths = [NSMutableArray array];
        
        [self computeDifferenceBetweenRect:previousPreheatRect andRect:preheatRect removedHandler:^(NSArray<NSValue *> *removedRect) {
            for (int i=0; i<removedRect.count; i++) {
                NSArray<NSIndexPath *> *indexPaths = [self indexPathsForElements:[removedRect[i] CGRectValue]];
                [removedIndexPaths addObjectsFromArray:indexPaths];
            }
            NSLog(@"removedIndexPaths 长度= %lu",(unsigned long)removedIndexPaths.count);
        } addedHandler:^(NSArray<NSValue *> *addedRect) {
            for (int i=0; i<addedRect.count; i++) {
                NSArray<NSIndexPath *> *indexPaths = [self indexPathsForElements:[addedRect[i] CGRectValue]];
                [addedIndexPaths addObjectsFromArray:indexPaths];
            }
            NSLog(@"addedIndexPaths 长度= %lu",(unsigned long)addedIndexPaths.count);
        }];
        
        NSArray *assetsToStartCaching = [self assetsAtIndexPaths:addedIndexPaths];
        NSArray *assetsToStopCaching = [self assetsAtIndexPaths:removedIndexPaths];
        
        PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
        
        CGSize imageSize = [[PhotoKitTool shareInstance] transformPointsToPixel:CGSizeMake(itemUnit, itemUnit)];
        [imageManager startCachingImagesForAssets:assetsToStartCaching
                                            targetSize:imageSize
                                           contentMode:PHImageContentModeAspectFill
                                               options:nil];
        [imageManager stopCachingImagesForAssets:assetsToStopCaching
                                           targetSize:imageSize
                                          contentMode:PHImageContentModeAspectFill
                                              options:nil];
        previousPreheatRect = preheatRect;
    }
}

#pragma mark - 通过rect获取区域内的indexPath
- (NSArray<NSIndexPath *> *) indexPathsForElements:(CGRect)rect{
    NSArray<UICollectionViewLayoutAttributes *> *allLayoutAttributes = [self.flowLayout layoutAttributesForElementsInRect:rect];
    NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray array];
    for (int i=0; i<allLayoutAttributes.count; i++) {
        [indexPaths addObject:allLayoutAttributes[i].indexPath];
    }
    return indexPaths;
}

//In your case this computeDifference method changes to handle horizontal scrolling
- (void)computeDifferenceBetweenRect:(CGRect)oldRect andRect:(CGRect)newRect removedHandler:(void (^)(NSArray<NSValue *> * removedRect))removedHandler addedHandler:(void (^)(NSArray<NSValue *> * addedRect))addedHandler
{
    if (CGRectIntersectsRect(newRect, oldRect)) {
        CGFloat oldMaxY = CGRectGetMaxY(oldRect);
        CGFloat oldMinY = CGRectGetMinY(oldRect);
        CGFloat newMaxY = CGRectGetMaxY(newRect);
        CGFloat newMinY = CGRectGetMinY(newRect);
        NSMutableArray<NSValue *> *added = [NSMutableArray array];
        NSMutableArray<NSValue *> *removed = [NSMutableArray array];
        if (newMaxY > oldMaxY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY));
            [added addObject:[NSValue valueWithCGRect:rectToAdd]];
        }
        if (oldMinY > newMinY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY));
            [added addObject:[NSValue valueWithCGRect:rectToAdd]];
        }
        if (newMaxY < oldMaxY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY));
            [removed addObject:[NSValue valueWithCGRect:rectToRemove]];
        }
        if (oldMinY < newMinY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY));
            [removed addObject:[NSValue valueWithCGRect:rectToRemove]];
        }
        addedHandler(added);
        removedHandler(removed);
    } else {
        addedHandler(@[[NSValue valueWithCGRect:newRect]]);
        removedHandler(@[[NSValue valueWithCGRect:oldRect]]);
    }
}

- (NSArray *)assetsAtIndexPaths:(NSArray *)indexPaths
{
    if (indexPaths.count == 0) { return nil; }
    
    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:indexPaths.count];
    for (NSIndexPath *indexPath in indexPaths) {
        AssetModel *model = self.albumModel.assetsArray[indexPath.item];
        PHAsset *asset = model.asset;
        [assets addObject:asset];
    }
    return assets;
}


- (void)dealloc {
    NSLog(@"...");
}

@end
