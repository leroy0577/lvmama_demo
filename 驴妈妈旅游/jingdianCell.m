//
//  jingdianCell.m
//  驴妈妈旅游
//
//  Created by qianfeng on 14-9-26.
//  Copyright (c) 2014年 luoyang. All rights reserved.
//

#import "jingdianCell.h"

@implementation jingdianCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    _absoluteMiddleImage = [UIImageView imageViewWithFrame:CGRectMake(10, 8, 95, 64) imageFile:nil];
    _absoluteMiddleImage.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_absoluteMiddleImage];
    
    _nameLabel = [UILabel labelWithFrame:CGRectMake(110, 10, 150, 20) text:@"name"];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_nameLabel];
    
    _cmtStartsLabel = [UILabel labelWithFrame:CGRectMake(110, 32, 30, 10) text:@"评分"];
    _cmtStartsLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:_cmtStartsLabel];
    
    _subjectLabel = [UILabel labelWithFrame:CGRectMake(155, 32, 50, 10) text:@"类型"];
    _subjectLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:_subjectLabel];
    
    _addressLabel = [UILabel labelWithFrame:CGRectMake(110, 62, 160, 10) text:@"地址"];
    _addressLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:_addressLabel];
    
    _sellPriceYuanLabel = [UILabel labelWithFrame:CGRectMake(260, 10, 55, 20) text:@"现价"];
    _sellPriceYuanLabel.textColor = [UIColor colorWithRed:209/255.0 green:31/255.0 blue:127/255.0 alpha:1];
    _sellPriceYuanLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_sellPriceYuanLabel];
    
    _marketPriceYuanLabel = [UILabel labelWithFrame:CGRectMake(280, 35, 30, 10) text:@"原价"];
    _marketPriceYuanLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:_marketPriceYuanLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 4, 20, 1)];
    lineView.backgroundColor = [UIColor blackColor];
    [_marketPriceYuanLabel addSubview:lineView];
    
    _juliLabel = [UILabel labelWithFrame:CGRectMake(280, 62, 35, 10) text:@"距离"];
    _juliLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:_juliLabel];
    
    /*
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(110, 45, 60, 15)];
    backView.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:backView];
     */

    _orderTodayAbleLabel = [UILabel labelWithFrame:CGRectMake(110, 45, 60, 15) text:@"今日票"];
    _orderTodayAbleLabel.font = [UIFont systemFontOfSize:10];
    _orderTodayAbleLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_orderTodayAbleLabel];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
