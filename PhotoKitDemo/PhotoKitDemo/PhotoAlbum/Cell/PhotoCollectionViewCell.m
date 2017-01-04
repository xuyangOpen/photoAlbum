//
//  PhotoCollectionViewCell.m
//  PhotoKitDemo
//
//  Created by 徐杨 on 2016/12/26.
//  Copyright © 2016年 H&X. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@interface PhotoCollectionViewCell()<UIScrollViewDelegate>
{
    ///是否是长图
    BOOL isLongImage;
    ///当前图片放大或者缩小倍数
    CGFloat currentScale;
    ///是否进行了缩放
    BOOL isOffset;
    ///最大放大比例
    CGFloat maxScale;
}
@property (nonatomic, assign) UIScrollView *containerView;

#pragma mark - 手势
@property (nonatomic) UITapGestureRecognizer *tapGesture;
@property (nonatomic) UITapGestureRecognizer *doubleTap;




@end

@implementation PhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //UIScrollView
        self.containerView = [UIScrollView makeScrollView:^(UIScrollView *make) {
            make.svZoomScale(1.0).svMaximumZoomScale(3.0).svDelegate(self).svShowsHorizontalScrollIndicator(false).svShowsVerticalScrollIndicator(false).svAddToView(self.contentView);
        }];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT));
        }];
        //照片
        self.photoImageView = [UIImageView makeImageView:^(UIImageView *make) {
            make.ivFrame(CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)).ivLayerMasksToBounds(true).ivAddToView(self.containerView);
        }];
        //添加手势
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        self.doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureAction:)];
        self.doubleTap.numberOfTapsRequired = 2;
        //防止手势冲突
        [self.tapGesture requireGestureRecognizerToFail:self.doubleTap];
        [self addGestureRecognizer:self.tapGesture];
        [self addGestureRecognizer:self.doubleTap];
        
        
        currentScale = 1.0;                 //当前默认放大倍数为1倍
        isLongImage = false;                //默认不是长图
        maxScale = 3.0;                     //最大方法比例
    }
    return self;
}

#pragma mark - 设置模型
- (void)setModel:(AssetModel *)model{
    _model = model;
    //获取资源id
    self.representedAssetIdentifier = [[PhotoKitTool shareInstance] getAssetIdentifier:model.asset];
    //发送获取图片的请求，并获取请求id  CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)
    PHImageRequestID imageRequestID = [[PhotoKitTool shareInstance] getImageWithAsset:model.asset imageSize:CGSizeMake(SCREEN_WIDTH*2, SCREEN_HEIGHT*2) completion:^(UIImage *image, NSDictionary *dic, BOOL isDegraded) {
        //图片详情中，先显示低清的图片，然后显示高清图片
//        if (isDegraded) {
//            return;
//        }
        //如果当前请求id==当前资源id，则图片设置为当前请求的图片
        if ([self.representedAssetIdentifier isEqualToString:[[PhotoKitTool shareInstance] getAssetIdentifier:model.asset]]) {
            self.photoImageView.image = image;
            //设置图片属性
            [self imageAttributeSettings];
        } else {
            //否则取消当前请求id
            [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
        }
        if (!isDegraded) {
            self.imageRequestID = 0;
        }
    }];
    if (imageRequestID && self.imageRequestID && imageRequestID != self.imageRequestID) {
        [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
    }
    self.imageRequestID = imageRequestID;
    //当前缩放比例置为默认1
    self.containerView.zoomScale = 1.0;
}

#pragma mark - 设置图片属性
- (void)imageAttributeSettings{
    //获取图片最优尺寸
    CGSize bestSize = [self.photoImageView sizeThatFits:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    CGFloat height = (SCREEN_WIDTH / bestSize.width) * bestSize.height;
    //如果图片高度 >= 屏幕高度，则y = 0
    //如果图片高度 < 屏幕高度，则y = (屏幕高度-图片高度) / 2.0  ，即居中显示
    CGFloat imageViewHeight = 0.0;
    if (height > SCREEN_HEIGHT) {//是长图
        isLongImage = true;
        imageViewHeight = 0.0;
        self.containerView.minimumZoomScale = 1.0;//长图的最小缩小比例为1.0
//        self.containerView.contentSize = CGSizeMake(SCREEN_WIDTH, height);
        self.containerView.contentSize = CGSizeZero;
        
        //显示位置
        CGFloat showWidth = SCREEN_HEIGHT/height * SCREEN_WIDTH;
        if (SCREEN_WIDTH / showWidth > 3.0) {
            maxScale = SCREEN_WIDTH / showWidth;
            self.containerView.maximumZoomScale = maxScale;
        }
        //保存最佳尺寸
        self.photoImageView.frame = CGRectMake((SCREEN_WIDTH - showWidth)/2.0, imageViewHeight, showWidth, SCREEN_HEIGHT);
    }else{
        isLongImage = false;
        imageViewHeight = (SCREEN_HEIGHT - height) / 2.0;
        self.containerView.minimumZoomScale = 0.5;//小图的最小缩小比例为0.5
        self.containerView.contentSize = CGSizeZero;
        
        //修改部分
        maxScale = self.containerView.maximumZoomScale = 3.0;
        
        //保存最佳尺寸
        self.photoImageView.frame = CGRectMake(0, imageViewHeight, SCREEN_WIDTH, height);
    }
    
    
    currentScale = 1.0;
}

#pragma mark - 单击手势
- (void)tapGestureAction:(UITapGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(showOrHideOperationToolBar)]) {
        [self.delegate showOrHideOperationToolBar];
    }
}

#pragma mark - 双击手势
- (void)doubleTapGestureAction:(UITapGestureRecognizer *)doubleTap{
    
    if (isLongImage) {//如果是长图，双击还原成1.0
        if (currentScale == 1.0) {
            currentScale = maxScale;
            isOffset = true;
        }else{
            currentScale = 1.0;
            isOffset = false;
        }
    }else{
        //如果当前缩放比例小于1.0时，双击还原成1.0
        if (currentScale < 1.0) {
            currentScale = 1.0;
        }else if (currentScale < maxScale){//缩放比例在1.0 - maxScale 之间时，双击放大到maxScale
            currentScale = maxScale;
            isOffset = true;
        }else{//如果当前缩放比例等于maxScale，则缩放比例还原到1.0
            currentScale = 1.0;
            isOffset = false;
        }
    }
    CGRect zoomRect = [self zoomRectForScale:currentScale center:[doubleTap locationInView:doubleTap.view]];
    //放大某个区域
    [self.containerView zoomToRect:zoomRect animated:true];
}

#pragma mark - 通过点击位置和缩放比例，获取应该缩放的区域范围
- (CGRect)zoomRectForScale:(CGFloat)scale center:(CGPoint)center{
    CGRect zoomRect = CGRectZero;
    zoomRect.size.height = self.containerView.frame.size.height/scale;
    zoomRect.size.width = self.containerView.frame.size.width/scale;
    zoomRect.origin.x = center.x - zoomRect.size.width/maxScale;
    zoomRect.origin.y = center.y - zoomRect.size.height/maxScale;
    if (isOffset) {//如果当前图片超出了屏幕，则进行了偏移，所以同时需要加上偏移量
        zoomRect.origin.y += self.containerView.contentOffset.y;
    }else{//当图片缩小还原时
        zoomRect.origin.y = self.containerView.contentOffset.y/maxScale - center.y/maxScale;
    }
    return zoomRect;
}

#pragma mark - UIScrollView代理方法
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.photoImageView;
}
//缩放过程中，确定图片的中心点
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGFloat centerX = scrollView.center.x;
    CGFloat centerY = scrollView.center.y;
    //目前contentsize的width是否大于原scrollview的contentsize，如果大于，设置imageview中心x点为contentsize的一半，以固定imageview在该contentsize中心。如果不大于说明图像的宽还没有超出屏幕范围，可继续让中心x点为屏幕中点，此种情况确保图像在屏幕中心。
    centerX = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2.0 : centerX;
    centerY = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2.0 : centerY;
    self.photoImageView.center = CGPointMake(centerX, centerY);
}
//获取当前缩放比例
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    currentScale = scale;
}

@end
