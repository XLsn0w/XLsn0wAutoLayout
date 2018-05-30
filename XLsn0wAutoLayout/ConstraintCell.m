//
//  ConstraintCell.m
//  XLsn0wAutoLayout
//
//  Created by ginlong on 2018/5/30.
//  Copyright © 2018年 XLsn0w. All rights reserved.
//

#import "ConstraintCell.h"
#import "UIView+MakeConstraints.h"
#import "XLsn0wConstraintsMaker.h"

@implementation ConstraintCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self drawUI];
    }
    return self;
}

- (void)drawUI {
    UIImageView *img = [UIImageView new];
    [self addSubview:img];
    img.backgroundColor = UIColor.redColor;
    img.image = [UIImage imageNamed:@"img"];
    img.make.leftValue(self, 30).centerY_equalTo(self).widthValue(40).heightValue(40);
    
    UILabel *title = [UILabel new];
    [self addSubview:title];
    title.text = @"title";
    title.make.rightValue(self, -10).centerY_equalTo(self).widthValue(80).heightValue(20);
    
    UIView *view = [UIView new];
    [self addSubview:view];
    view.backgroundColor = UIColor.blueColor;
    view.make.centerX_equalTo(self).centerY_equalTo(self).widthValue(40).heightValue(40);
}

@end
