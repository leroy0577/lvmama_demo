//
//  HomeCell.m
//  驴妈妈旅游
//
//  Created by qianfeng on 14-9-22.
//  Copyright (c) 2014年 luoyang. All rights reserved.
//

#import "HomeCell.h"

@implementation HomeCell

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
    _iconImageView = [UIImageView imageViewWithFrame:CGRectMake(10 , 10, 300, 100) imageFile:nil];
    [self.contentView addSubview:_iconImageView];
    
    _titleLabel = [UILabel labelWithFrame:CGRectMake(10, 113, 300, 15) text:@"title"];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_titleLabel];
    
    _contentLabel = [UILabel labelWithFrame:CGRectMake(10, 130, 280, 30) text:@"content"];
    _contentLabel.numberOfLines = 2;
    _contentLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_contentLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
