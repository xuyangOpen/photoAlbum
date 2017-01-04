//
//  AlbumTableViewCell.m
//  PhotoKit读取相册内容
//
//  Created by 徐杨 on 2016/12/21.
//  Copyright © 2016年 H&X. All rights reserved.
//

#import "AlbumTableViewCell.h"
#import "ExtensionHeader.h"
#import "Masonry.h"

@interface AlbumTableViewCell()

@property (nonatomic, strong) UILabel *albumName;
@property (nonatomic, strong) UILabel *countNumber;

@end

@implementation AlbumTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //图片
        self.firstImageView = [UIImageView makeImageView:^(UIImageView *make) {
            make.ivLayerMasksToBounds(true).ivContentMode(UIViewContentModeScaleAspectFill).ivBackgroundColor([UIColor grayColor]).ivAddToView(self.contentView);
        }];
        [self.firstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(15);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        //相册名称
        self.albumName = [UILabel makeLabel:^(UILabel *make) {
            make.labelTextColor([UIColor blackColor]).labelFont([UIFont systemFontOfSize:16]).labelAddToView(self.contentView);
        }];
        [self.albumName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.firstImageView.mas_right).with.offset(15);
            make.centerY.equalTo(self.contentView);
        }];
        //相册照片张数
        self.countNumber = [UILabel makeLabel:^(UILabel *make) {
            make.labelFont([UIFont systemFontOfSize:16]).labelTextColor([UIColor blackColor]).labelAddToView(self.contentView);
        }];
        [self.countNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.albumName.mas_right).with.offset(10);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return self;
}

#pragma mark - 设置相册第一张图片
- (void)setAlbumPhoto:(UIImage *)image albumName:(NSString *)name albumCount:(int)count{
    self.firstImageView.image = image;
    self.albumName.text = name;
    self.countNumber.text = [NSString stringWithFormat:@"(%d)",count];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


@end
