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

@property (nonatomic, weak) IBOutlet UIView* markReadView;
@property (nonatomic, weak) IBOutlet UIWebView* webContentView;

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
    self.webContentView.scrollView.scrollEnabled = NO;
    self.webContentView.backgroundColor = [UIColor clearColor];
    self.webContentView.opaque = NO;
    [self.webContentView loadHTMLString:news.content baseURL:nil];
    if (![news.isRead boolValue]) {
        self.markReadView.hidden = NO;
        self.markReadView.layer.cornerRadius = self.markReadView.frame.size.width / 2;
    } else {
        self.markReadView.hidden = YES;
    }
}

@end
