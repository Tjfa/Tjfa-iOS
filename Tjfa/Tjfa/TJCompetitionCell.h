//
//  CompetitionTableViewCell.h
//  Tjfa
//
//  Created by 邱峰 on 7/26/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Competition.h"

@interface TJCompetitionCell : UITableViewCell

- (void)setCellWithCompetition:(Competition *)competition forIndexPath:(NSIndexPath *)indexPath;

@end
