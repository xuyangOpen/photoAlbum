//
//  CustomizeButton.m
//  PhotoKitDemo
//
//  Created by 徐杨 on 2016/12/26.
//  Copyright © 2016年 H&X. All rights reserved.
//

#import "CustomizeButton.h"

@interface CustomizeButton()
{
    BOOL isOrigin;
}
@property (nonatomic) UILabel *textLabel;
@end

@implementation CustomizeButton

- (instancetype)initWithFrame:(CGRect)frame isOrigin:(BOOL)origin{
    if (self = [super initWithFrame:frame]) {
        isOrigin = origin;
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, frame.size.width-25, frame.size.height)];
        _textLabel.textColor = [UIColor colorWithRed:0/255.0 green:180/255.0 blue:255/255.0 alpha:1.0];
        _textLabel.font = [UIFont systemFontOfSize:17];
        [self addSubview:_textLabel];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextAddArc(context, 12, rect.size.height/2.0, 10, 0, 2*M_PI, 0);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0/255.0 green:180/255.0 blue:255/255.0 alpha:1.0].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0/255.0 green:180/255.0 blue:255/255.0 alpha:1.0].CGColor);
    if (isOrigin) {//原图，画实心圆
        CGContextDrawPath(context, kCGPathFill);
    }else{//非原图，画空心圆
        CGContextDrawPath(context, kCGPathStroke);
    }
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    isOrigin = selected;
    [self setNeedsDisplay];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    self.textLabel.text = title;
}


@end
