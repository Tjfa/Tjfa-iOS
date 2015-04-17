//
//  MemberListCell.m
//  Tjfa
//
//  Created by 邱峰 on 4/1/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "TJMemberListCell.h"
#import "TJUser.h"
#import <POP.h>

@interface TJMemberListCell()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;


@end

@implementation TJMemberListCell

- (void)prepareForReuse
{
    [self.avatarImageView setImage:[UIImage imageNamed:@"defaultProvide"]];
    self.nameLabel.text = @"";
    self.phoneLabel.text = @"";
   // self.avatorImageView.
}

- (void)showAvatoarImageViewAnimation
{
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerSize];
    springAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(60, 60)];
    springAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0, 0)];
    springAnimation.springBounciness = 20;
    springAnimation.springSpeed = 10;
    
    POPSpringAnimation *cornerRadius = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerCornerRadius];
    cornerRadius.fromValue = @(0);
    cornerRadius.toValue = @(30);
    cornerRadius.springBounciness = 20;
    cornerRadius.springSpeed = 10;
    [self.avatarImageView.layer pop_addAnimation:cornerRadius forKey:@"avator_corner"];
    [self.avatarImageView pop_addAnimation:springAnimation forKey:@"avator_show"];

}

- (void)setCellWithUser:(TJUser *)user
{
    if (user.avatar) {
        [user.avatar getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (error == nil) {
                [self.avatarImageView setImage:[UIImage imageWithData:data]];
            }
        }];
    }
    self.nameLabel.text = user.name;
    self.phoneLabel.text = user.mobilePhoneNumber;
}

- (void)showAnimate
{
    [self showAvatoarImageViewAnimation];
//    [self showPhoneLabelAnimation];
//    [self showNameLabelAnimation];
}

- (void)showPhoneLabelAnimation
{
    POPSpringAnimation *moveAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerSize];
    CGSize size = self.phoneLabel.frame.size;
    moveAnimation.fromValue = [NSValue valueWithCGSize:CGSizeZero];
    moveAnimation.toValue = [NSValue valueWithCGSize:size];
    moveAnimation.springBounciness = 20;
    moveAnimation.springSpeed = 5;
    [self.phoneLabel.layer pop_addAnimation:moveAnimation forKey:@"phone_move"];
}

- (void)showNameLabelAnimation
{
    POPSpringAnimation *moveAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerSize];
    CGSize size = self.nameLabel.frame.size;
    moveAnimation.fromValue = [NSValue valueWithCGSize:CGSizeZero];
    moveAnimation.toValue = [NSValue valueWithCGSize:size];
    moveAnimation.springBounciness = 20;
    moveAnimation.springSpeed = 5;
    [self.nameLabel pop_addAnimation:moveAnimation forKey:@"name_move"];
}

@end
