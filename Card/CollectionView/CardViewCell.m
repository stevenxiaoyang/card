//
//  CardViewCell.m
//  Card
//
//  Created by LuYang on 16/2/19.
//  Copyright © 2016年 LuYang. All rights reserved.
//

#import "CardViewCell.h"
@interface CardViewCell()
@property (weak, nonatomic) UIImageView *cellImageView;
@end
@implementation CardViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 1.f;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        UIImageView *cellImageView = [[UIImageView alloc]initWithFrame:CGRectMake((frame.size.width - 200)/2, (frame.size.height - 200)/2, 200, 200)];
        [self addSubview:cellImageView];
        _cellImageView = cellImageView;
    }
    return self;
}

-(void)setImage:(NSString *)imageName
{
    [_cellImageView setImage:[UIImage imageNamed:imageName]];
}
@end
