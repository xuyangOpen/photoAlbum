//
//  MagicMoveTransiton.m
//  PhotoKitDemo
//
//  Created by 徐杨 on 2017/1/3.
//  Copyright © 2017年 H&X. All rights reserved.
//

#import "MagicMoveTransiton.h"
#import "AlbumDetailController.h"
#import "PhotoPreviewController.h"
#import "AlbumDetailCollectionViewCell.h"
#import "PhotoCollectionViewCell.h"

@interface MagicMoveTransiton()
{
    //导航栏跳转方式
    NSString *magicType;
    //当前选中下标
    NSUInteger currentIndex;
    //pop时，是否需要刷新
    BOOL ifNeededRefresh;
}

@end

@implementation MagicMoveTransiton

#pragma mark - 初始化
///type "push"  "pop" 两种模式
- (instancetype)initWithType:(NSString *)type index:(NSUInteger)index refresh:(BOOL)refresh{
    if (self = [super init]) {
        magicType = type;
        currentIndex = index;
        ifNeededRefresh = refresh;
    }
    return self;
}

#pragma mark - 导航动画执行时间
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.4f;
}

#pragma mark - 视图过渡动画
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    //转场视图容器
    UIView *containerView = [transitionContext containerView];
    
    if ([magicType isEqualToString:@"push"]) {//push模式
        //起始控制器
        AlbumDetailController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        //目标控制器
        PhotoPreviewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        //获取到相册中，选中的CollectionViewCell的indexPath
        NSIndexPath *indexPath = [[fromVC.photoCollectionView indexPathsForSelectedItems] firstObject];
        AlbumDetailCollectionViewCell *cell = (AlbumDetailCollectionViewCell *)[fromVC.photoCollectionView cellForItemAtIndexPath:indexPath];
        
        //获取图片
        [[PhotoKitTool shareInstance] getImageWithAsset:cell.model.asset imageSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT) completion:^(UIImage *image, NSDictionary *dic, BOOL isDegraded) {
            if (isDegraded) {
                return;
            }
            // 对Cell上面的图片 做截图 来实现过渡动画视图
            UIImageView *screenShot = [[UIImageView alloc] initWithImage:image];
            screenShot.backgroundColor = [UIColor clearColor];
            screenShot.contentMode = UIViewContentModeScaleAspectFill;
            screenShot.layer.masksToBounds = true;
#pragma mark - 修改
            screenShot.frame = [containerView convertRect:cell.photoImageView.view.frame fromView:cell.photoImageView.view.superview];
            
            cell.photoImageView.hidden = true;
            
            // 设置第二个控制器的位置和透明度
            toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
            toVC.view.alpha = 0;
            toVC.photoCollectionView.hidden = true;
            
            // 把动画前后的两个ViewController加到容器控制器中
            [containerView addSubview:toVC.view];
            [containerView addSubview:screenShot];
            
            //开始做动画
            [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseIn animations:^{
                toVC.view.alpha = 1;
                toVC.bottomToolView.alpha = 1;
                // 布局坐标
                CGSize size = [self getBestSize:screenShot];
                
                screenShot.frame = CGRectMake((SCREEN_WIDTH-size.width)/2.0, (SCREEN_HEIGHT-size.height)/2.0, size.width, size.height);
            } completion:^(BOOL finished) {
                toVC.photoCollectionView.hidden = false;
                cell.photoImageView.hidden = false;
                // 动画截图移除View
                [screenShot removeFromSuperview];
                // 一定不要忘记告诉系统动画结束
                // 执行
                [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            }];
            
        }];
    }else if ([magicType isEqualToString:@"pop"]){//pop模式
        //起始控制器
        PhotoPreviewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        //目标控制器
        AlbumDetailController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        //获取预览图片的截图
        PhotoCollectionViewCell *cell = (PhotoCollectionViewCell *)[fromVC.photoCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:fromVC.currentIndex-1 inSection:0]];
        UIImageView *screenShot = [[UIImageView alloc] initWithImage:cell.photoImageView.image];
        screenShot.contentMode = UIViewContentModeScaleAspectFill;
        screenShot.layer.masksToBounds = true;
        screenShot.backgroundColor = [UIColor clearColor];
        screenShot.frame = [containerView convertRect:cell.photoImageView.frame fromView:cell.photoImageView.superview];
        
        //初始化第二个VC
        toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
        //获取目标视图的cell
        __block AlbumDetailCollectionViewCell *toCell = (AlbumDetailCollectionViewCell *)[toVC.photoCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:currentIndex-1 inSection:0]];
        //等cell滚动完成之后，在执行导航动画
        [toVC.photoCollectionView performBatchUpdates:^{
#pragma mark - 修改
            CGRect toFrame = [containerView convertRect:toCell.photoImageView.view.frame fromView:toCell.photoImageView.view.superview];
            CGRect originFrame = toVC.photoCollectionView.frame;
            //默认是64，包含导航栏的高度
            CGRect realFrame = originFrame;
            realFrame.origin.y = 64;realFrame.size.height = SCREEN_HEIGHT-64-44;
            if (toCell == nil || !CGRectIntersectsRect(toFrame, originFrame)) {//如果是不在屏幕范围内的cell，则滚动到屏幕中间
                [toVC.photoCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:(currentIndex - 1) inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:false];
            }else if (toCell != nil && CGRectIntersectsRect(toFrame, originFrame) && !CGRectContainsRect(realFrame, toFrame)){
                //如果cell不为空，并且frame是相交而不是包含关系时
                //判断toFrame是接近顶部还是接近底部
                if (toFrame.origin.y < SCREEN_HEIGHT/2.0) {//接近顶部
                    [toVC.photoCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:(currentIndex - 1) inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:false];
                }else{//接近底部
                    [toVC.photoCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:(currentIndex - 1) inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:false];
                }
            }
            if (ifNeededRefresh){//如果需要刷新
                [toVC.photoCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
                [toVC reloadBottomInfo];
            }
        } completion:^(BOOL finished) {
            if (toCell == nil) {
                toCell = (AlbumDetailCollectionViewCell *)[toVC.photoCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:currentIndex-1 inSection:0]];
            }
            //将当前预览的图片原图隐藏
            cell.photoImageView.hidden = true;
            //将目标缩略图隐藏
            toCell.photoImageView.hidden = true;
            
            [containerView insertSubview:toVC.view belowSubview:fromVC.view];
            [containerView addSubview:screenShot];
            
            //执行动画
            [UIView animateWithDuration:0.3 animations:^{
                fromVC.view.alpha = 0;
                fromVC.bottomToolView.alpha = 0;
                //获取目标cell的位置
#pragma mark - 修改
                screenShot.frame = [containerView convertRect:toCell.photoImageView.view.frame fromView:toCell.photoImageView.view.superview];
            } completion:^(BOOL finished) {
                [fromVC.bottomToolView removeFromSuperview];
                [screenShot removeFromSuperview];
                cell.photoImageView.hidden = false;
                toCell.photoImageView.hidden = false;
                fromVC.view.alpha = 1;
                // 结束
                [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            }];
        }];
        
        
    }
    
}

#pragma mark - 根据图片获取最佳尺寸
- (CGSize)getBestSize:(UIImageView *)imageView{
    CGSize bestSize = [imageView sizeThatFits:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (bestSize.width > SCREEN_WIDTH || bestSize.width < SCREEN_WIDTH) {
        bestSize.height = SCREEN_WIDTH/bestSize.width * bestSize.height;
        bestSize.width = SCREEN_WIDTH;
    }
    //如果是长图
    if (bestSize.height > SCREEN_HEIGHT) {
        bestSize.width = SCREEN_HEIGHT/bestSize.height * SCREEN_WIDTH;
        bestSize.height = SCREEN_HEIGHT;
    }
    return bestSize;
}

@end
