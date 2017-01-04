//
//  ViewController.m
//  PhotoKitDemo
//
//  Created by 徐杨 on 2016/12/21.
//  Copyright © 2016年 H&X. All rights reserved.
//

#import "ViewController.h"
#import "AlbumNavigationController.h"

@interface ViewController()<AlbumDelegate>

@property (nonatomic) NSArray<PHAsset *> *assets;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    AlbumNavigationController *manager = [[AlbumNavigationController alloc] initWithSelectedAssets:self.assets];
    self.assets = nil;
    manager.maxCount = 10;
    manager.albumDelegate = self;
    manager.enableCaching = true;
    manager.isOriginal = false;
    [self presentViewController:manager animated:true completion:nil];
}

- (void)finishTheSelection:(NSArray<PHAsset *> *)assets imageArray:(NSArray<UIImage *> *)imageArray isOriginal:(BOOL)isOriginal{
    self.assets = assets;
    NSLog(@"选择了%lu张图片  ，原图： %d",(unsigned long)imageArray.count,isOriginal);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
