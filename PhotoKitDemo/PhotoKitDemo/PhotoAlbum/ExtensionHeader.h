//
//  ExtensionHeader.h
//  PhotoKit读取相册内容
//
//  Created by 徐杨 on 2016/12/21.
//  Copyright © 2016年 H&X. All rights reserved.
//

#ifndef ExtensionHeader_h
#define ExtensionHeader_h

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define ITEMSIZE (SCREEN_WIDTH-3*5) / 4.0

#define HXWeakSelf(type)  __weak typeof(type) weakSelf = type;
#define HXStrongSelf(type)  __strong typeof(type) strongSelf = type;

///RGB值
#define RGB(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
///主题色
#define ThemeColor [UIColor colorWithRed:0/255.0 green:180/255.0 blue:255/255.0 alpha:1.0]
///主题颜色和透明度
#define ThemeColorAlpha(alpha) [UIColor colorWithRed:0/255.0 green:180/255.0 blue:255/255.0 alpha:alpha]

///导入分类
#import "UIButton+Reactive.h"
#import "UICollectionView+Reactive.h"
#import "UICollectionViewFlowLayout+Reactive.h"
#import "UIImageView+Reactive.h"
#import "UILabel+Reactive.h"
#import "UIScrollView+Reactive.h"
#import "UITableView+Reactive.h"
#import "UITextField+Reactive.h"
#import "UITextView+Reactive.h"
#import "UIView+Reactive.h"
#import "UIPickerView+Reactive.h"

//masonry库
#import "Masonry.h"

//model模型
#import "AlbumModel.h"
#import "AssetModel.h"


//枚举


#endif /* ExtensionHeader_h */
