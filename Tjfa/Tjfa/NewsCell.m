//
//  NewsCell.m
//  Tjfa
//
//  Created by 邱峰 on 7/6/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "NewsCell.h"
#import "NSDate+Date2Str.h"

@interface NewsCell ()

@property (nonatomic, weak) IBOutlet UILabel* titleLabel;

@property (nonatomic, weak) IBOutlet UILabel* dateLabel;

@end

@implementation NewsCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellWithNews:(News*)news
{
    self.titleLabel.text = news.title;
    self.dateLabel.text = [news.date date2str];
}

@end
