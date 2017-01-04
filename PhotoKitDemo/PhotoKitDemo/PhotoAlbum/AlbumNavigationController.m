//
//  AlbumNavigationController.m
//  PhotoKitDemo
//
//  Created by 徐杨 on 2016/12/23.
//  Copyright © 2016年 H&X. All rights reserved.
//

#import "AlbumNavigationController.h"
#import "PhotoAlbumController.h"

@interface AlbumNavigationController ()
{
    NSTimer *timer;
}

@property (nonatomic) UILabel *tipLabel;

@end

@implementation AlbumNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - 传入默认选中的照片资源
- (instancetype)initWithSelectedAssets:(NSArray<PHAsset *> *)assets{
    if (self = [self init]) {
//        self.defaultAssets = assets;
        //默认选中资源
        [PhotoKitTool shareInstance].defaultAssets = assets;
    }
    return self;
}

- (instancetype)init{
    if (self = [super init]) {
        if ([[PhotoKitTool shareInstance] authorizationStatusAuthorized]) {
            //如果已经授权，则直接打开
            [self defaultSettings];
        }else{//如果没有授权，则提示，并每0.2秒判断一次是否授权
            [self.view setBackgroundColor:[UIColor whiteColor]];
            NSString *appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
            if (!appName) appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleName"];
            self.tipLabel = [UILabel makeLabel:^(UILabel *make) {
                make.labelBackgroundColor([UIColor whiteColor]).labelTextColor([UIColor blackColor]).labelFont([UIFont systemFontOfSize:16]).labelNumberOfLines(0).labelText([NSString stringWithFormat:@"请在%@的\"设置-隐私-照片\"选项中，允许%@访问你的手机相册。",[UIDevice currentDevice].model,appName]).labelAddToView(self.view);
            }];
            CGRect rect = [self.tipLabel.text boundingRectWithSize:CGSizeMake(0.7*SCREEN_WIDTH, CGFLOAT_MAX) options:0 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:NULL];
            [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.view);
                make.width.mas_equalTo(rect.size.width);
                make.height.mas_equalTo(rect.size.height + 50);
            }];
            timer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(observeAuthrizationStatusChange) userInfo:nil repeats:true];
        }
    }
    return self;
}


#pragma mark - 判断是否获取了授权
- (void)observeAuthrizationStatusChange {
    if ([[PhotoKitTool shareInstance] authorizationStatusAuthorized]) {
        //如果已经授权，则直接打开
        [self defaultSettings];
        [self.tipLabel removeFromSuperview];
        [timer invalidate];
        timer = nil;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (![[PhotoKitTool shareInstance] authorizationStatusAuthorized]){
        [timer invalidate];
        timer = nil;
        [self dismissViewControllerAnimated:true completion:nil];
    }
}

- (void)dealloc{
    [timer invalidate];
    timer = nil;
}

#pragma mark - 设置默认属性
- (void)defaultSettings{
    PhotoKitTool *tool = [PhotoKitTool shareInstance];
    tool.isAllowSelectOriginal = true;
    tool.maxCount = 0;
    tool.isOriginal = false;
    tool.enableCaching = false;
    
    [self pushViewController:[[PhotoAlbumController alloc] init] animated:false];
}

#pragma mark - 完成选择
- (void)finishTheSelection{
    PhotoKitTool *tool = [PhotoKitTool shareInstance];
    //代理实现了协议方法，并且选择的图片数量大于0
    if ([self.albumDelegate respondsToSelector:@selector(finishTheSelection:imageArray:isOriginal:)] && tool.selectedAssets.count > 0) {
        HXWeakSelf(self)
        [[PhotoKitTool shareInstance] fetchGroupPhotoWithAssets:tool.selectedAssets isOriginal:tool.isOriginal complete:^(NSArray<PHAsset *> *assetArray, NSArray<UIImage *> *imageArray) {HXStrongSelf(weakSelf)
            [strongSelf.albumDelegate finishTheSelection:assetArray imageArray:imageArray isOriginal:tool.isOriginal];
            [strongSelf dismissViewControllerAnimated:true completion:^{
                
            }];
        }];
        tool.selectedAssets = nil;
        tool.defaultAssets = nil;
    }
}

- (void)setIsAllowSelectOriginal:(BOOL)isAllowSelectOriginal{
    _isAllowSelectOriginal = isAllowSelectOriginal;
    [PhotoKitTool shareInstance].isAllowSelectOriginal = isAllowSelectOriginal;
}

- (void)setIsOriginal:(BOOL)isOriginal{
    _isOriginal = isOriginal;
    [PhotoKitTool shareInstance].isOriginal = isOriginal;
}

- (void)setMaxCount:(NSInteger)maxCount{
    _maxCount = maxCount;
    [PhotoKitTool shareInstance].maxCount = maxCount;
}

- (void)setEnableCaching:(BOOL)enableCaching{
    _enableCaching = enableCaching;
    [PhotoKitTool shareInstance].enableCaching = enableCaching;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
