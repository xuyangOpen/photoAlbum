//
//  PhotoAlbumController.m
//  PhotoKit读取相册内容
//
//  Created by 徐杨 on 2016/12/21.
//  Copyright © 2016年 H&X. All rights reserved.
//

#import "PhotoAlbumController.h"
#import "NSArray+Extension.h"
#import <Photos/Photos.h>
#import "AlbumTableViewCell.h"
#import "AlbumDetailController.h"
#import "PhotoKitTool.h"

@interface PhotoAlbumController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *albumTableView;
//相册数组
@property (nonatomic, strong) NSMutableArray<PHAssetCollection *> *albumsArray;

@end

@implementation PhotoAlbumController

static NSString *albumIdentifier = @"albumCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self generalSettings];
    //获取相册集
    [self viewAllAlbums];
    //默认加载到相机胶卷相册中
    [self previewAlbumDetailAtIndex:0 animated:false];
}

#pragma mark - 通用设置
- (void)generalSettings{
    self.title = @"相册";
    self.albumsArray = [NSMutableArray array];
    [self setNavigationRightButton:@"取消"];
}

#pragma mark - 查看所有相册
- (void)viewAllAlbums{
    self.albumTableView = [UITableView makeTableView:^(UITableView *make) {
        make.tvDataSource(self).tvDelegate(self).tvBackgroundColor([UIColor whiteColor]).tvAddToView(self.view);
    }];
    [self.albumTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    //注册cell
    [self.albumTableView registerClass:[AlbumTableViewCell class] forCellReuseIdentifier:albumIdentifier];
    //拉取相册信息
    [self fetchAlbum];
}

#pragma mark - 拉取相册信息
- (void)fetchAlbum{
    //相册顺序，-> CameraRoll -> userCreated -> smartAlbum
//    NSArray *array = [NSArray getProperties:[PHCollection class]];
//    NSLog(@"%@",array);
    
    //获取智能相册集合
    PHFetchResult *smartAlbums = [[PhotoKitTool shareInstance] getSmartAlbum];
    //把智能相册添加到数组中
    [smartAlbums enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.albumsArray addObject:obj];
    }];
    //把"相机胶卷"排在第一个
    for (int i=0;i<self.albumsArray.count;i++) {
        PHAssetCollection *album = self.albumsArray[i];
        if ([album.localizedTitle isEqualToString:@"Camera Roll"]) {
            [self.albumsArray exchangeObjectAtIndex:0 withObjectAtIndex:i];
            break;
        }
    }

    //列出所有用户创建的相册  creationDate 排序 最新的排在最前面
    PHFetchResult *userCreatedAlbums = [[PhotoKitTool shareInstance] getUserCreatedAlbum];
    [userCreatedAlbums enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.albumsArray insertObject:obj atIndex:1];
    }];
}

#pragma mark - UITableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.albumsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:albumIdentifier];
    if (!cell) {
        cell = [[AlbumTableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:albumIdentifier];
    }
    //获取相册
    PHAssetCollection *album = self.albumsArray[indexPath.row];
    [cell setAlbumPhoto:nil albumName:[[PhotoKitTool shareInstance] getAlbumName:album] albumCount:[[PhotoKitTool shareInstance] getAssetCountFromAlbum:album]];
    //设置第一张图片
    [[PhotoKitTool shareInstance] getFirstImageFromAlbum:album imageView:cell.firstImageView imageSize:CGSizeMake(50, 50)];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击相册，预览相册所有图片
    [self previewAlbumDetailAtIndex:indexPath.row animated:true];
}

#pragma mark - 预览相册中所有图片
- (void)previewAlbumDetailAtIndex:(NSUInteger)index animated:(BOOL)animated{
    //获取相册
    PHAssetCollection *album = self.albumsArray[index];
    AlbumDetailController *detailVC = [[AlbumDetailController alloc] initWithAlbum:album];
    //已选资源数组清空
    PhotoKitTool *tool = [PhotoKitTool shareInstance];
    tool.selectedAssets = nil;
    
    [self.navigationController pushViewController:detailVC animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
