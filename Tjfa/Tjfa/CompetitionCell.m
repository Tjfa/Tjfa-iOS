//
//  CompetitionTableViewCell.m
//  Tjfa
//
//  Created by 邱峰 on 7/26/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "CompetitionCell.h"

@interface CompetitionCell ()

@property (nonatomic, weak) IBOutlet UIImageView* cupView;

@property (nonatomic, weak) IBOutlet UILabel* title;

@end

@implementation CompetitionCell

const int totalCupImage = 3;

- (void)setCellWithCompetition:(Competition*)competition forIndexPath:(NSIndexPath*)indexPath
{
    self.cupView.image = [UIImage imageNamed:[NSString stringWithFormat:@"competitionCup%ld", (indexPath.row + indexPath.section) % totalCupImage]];
    self.title.text = [self converCompetitionTitle:competition.name];
}

- (NSString*)converCompetitionTitle:(NSString*)title
{
    NSMutableString* result = [[NSMutableString alloc] init];
    for (int i = 0; i < title.length; i++) {
        [result appendFormat:@"%@ ", [title substringWithRange:NSMakeRange(i, 1)]];
    }
    return result;
}

@end
