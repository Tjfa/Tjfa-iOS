//
//  NewsCell.m
//  Tjfa
//
//  Created by 邱峰 on 7/6/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "TJNewsCell.h"
#import "NSDate+Date2Str.h"

@interface TJNewsCell ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@property (nonatomic, weak) IBOutlet UILabel *dateLabel;

@property (nonatomic, weak) IBOutlet UIView *markReadView;
@property (nonatomic, weak) IBOutlet UILabel *preContent;

@end

@implementation TJNewsCell

- (void)setCellWithNews:(News *)news
{
    self.titleLabel.text = news.title;
    self.dateLabel.text = [news.date date2ShortStr];
    self.preContent.text = news.precontent;
    if (![news.isRead boolValue]) {
        self.markReadView.hidden = NO;
        self.markReadView.layer.cornerRadius = self.markReadView.frame.size.width / 2;
    }
    else {
        self.markReadView.hidden = YES;
    }
}

@end
