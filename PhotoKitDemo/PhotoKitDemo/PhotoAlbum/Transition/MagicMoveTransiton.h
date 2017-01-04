//
//  MagicMoveTransiton.h
//  PhotoKitDemo
//
//  Created by 徐杨 on 2017/1/3.
//  Copyright © 2017年 H&X. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MagicMoveTransiton : NSObject<UIViewControllerAnimatedTransitioning>

///type "push"  "pop" 两种模式
- (instancetype)initWithType:(NSString *)type index:(NSUInteger)index refresh:(BOOL)refresh;

@end
