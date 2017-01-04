//
//  AlbumTableViewCell.h
//  PhotoKit读取相册内容
//
//  Created by 徐杨 on 2016/12/21.
//  Copyright © 2016年 H&X. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *firstImageView;
///初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
///设置相册第一张图片
- (void)setAlbumPhoto:(UIImage *)image albumName:(NSString *)name albumCount:(int)count;



@end
