//
//  DashboardButtonView.m
//  Tjfa
//
//  Created by 邱峰 on 6/28/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "DashboardCell.h"

@implementation DashboardCell {
    CGFloat dashboardButtonSize;
}

- (CGFloat)widthSpace
{
    return 60;
}

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage*)image labelName:(NSString*)label direction:(DashboardLabelDirection)direction target:(id)target action:(SEL)action dashboardSize:(CGFloat)size
{
    if (self = [super initWithFrame:frame]) {

        dashboardButtonSize = size;

#pragma mark - dashboard button
        CGRect dashBoardFrame;
        if (direction == kLeft) {
            dashBoardFrame = CGRectMake(frame.size.width - size - [self widthSpace], 0, size, size);
        } else {
            dashBoardFrame = CGRectMake([self widthSpace], 0, size, size);
        }
        self.dashboardButton = [[DashboardButton alloc] initWithFrame:dashBoardFrame andImage:image andTarget:target action:action];
        self.dashboardButton.layer.anchorPoint = CGPointMake(0.5, 0.5);
        [self addSubview:self.dashboardButton];

#pragma mark -  label
        self.nameLable = [[UILabel alloc] init];
        self.nameLable.text = label;

        CGRect nameLableFrame;
        if (direction == kLeft) {
            nameLableFrame = CGRectMake([self widthSpace], 0, size, size);
            self.nameLable.textAlignment = NSTextAlignmentLeft;
        } else {
            nameLableFrame = CGRectMake(frame.size.width - 100 - [self widthSpace], 0, size, size);
            self.nameLable.textAlignment = NSTextAlignmentRight;
        }
        self.nameLable.frame = nameLableFrame;
        [self addSubview:self.nameLable];
    }
    return self;
}

/**
 *  init the dashboardButton befor animate
 */
- (void)showAnimateInit
{
    self.dashboardButton.frame = CGRectMake(self.dashboardButton.frame.origin.x, self.dashboardButton.frame.origin.y, 0, 0);
    self.dashboardButton.layer.cornerRadius = dashboardButtonSize / 4;
    self.userInteractionEnabled = NO;
}

- (void)showWithAnimateComplete:(void (^)(BOOL))complete
{
    [self showAnimateInit];
    [UIView animateWithDuration:0.3 animations:^() {
         self.dashboardButton.frame = CGRectMake(self.dashboardButton.frame.origin.x, self.dashboardButton.frame.origin.y, dashboardButtonSize+10, dashboardButtonSize+10);
         self.dashboardButton.layer.cornerRadius=dashboardButtonSize / 2;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.1 animations:^(){
            self.dashboardButton.frame = CGRectMake(self.dashboardButton.frame.origin.x, self.dashboardButton.frame.origin.y, dashboardButtonSize, dashboardButtonSize);
        }completion:^(BOOL finished){
            self.userInteractionEnabled=YES;
            if (complete){
                complete(finished);
            }
        }];
    }];
}

- (void)showWithAnimateAfterDelay:(NSTimeInterval)delay complete:(void (^)(BOOL))complete
{
    [self showAnimateInit];
    [UIView animateWithDuration:0.3 delay:delay options:0 animations:^(void) {
        self.dashboardButton.frame = CGRectMake(self.dashboardButton.frame.origin.x, self.dashboardButton.frame.origin.y, dashboardButtonSize+10, dashboardButtonSize+10);
        self.dashboardButton.layer.cornerRadius=dashboardButtonSize / 2;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^(){
            self.dashboardButton.frame = CGRectMake(self.dashboardButton.frame.origin.x, self.dashboardButton.frame.origin.y, dashboardButtonSize, dashboardButtonSize);
        }completion:^(BOOL finished){
            self.userInteractionEnabled=YES;
            if (complete){
                complete(finished);
            }
        }];
    }];
}

- (void)hideWithAnimateComplete:(void (^)(BOOL))complete
{
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.1 animations:^() {
        self.dashboardButton.frame = CGRectMake(self.dashboardButton.frame.origin.x, self.dashboardButton.frame.origin.y, dashboardButtonSize+10, dashboardButtonSize+10);
        self.dashboardButton.layer.cornerRadius=dashboardButtonSize / 2;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 animations:^(){
            self.dashboardButton.frame = CGRectMake(self.dashboardButton.frame.origin.x, self.dashboardButton.frame.origin.y, 0, 0);
        }completion:^(BOOL finished){
            self.userInteractionEnabled=YES;
            if (complete){
                complete(finished);
            }
        }];
    }];
}

- (void)hideWithAnimateAfterDelay:(NSTimeInterval)delay complete:(void (^)(BOOL))complete
{
    [UIView animateWithDuration:0.1 delay:delay options:0 animations:^(void) {
        self.dashboardButton.frame = CGRectMake(self.dashboardButton.frame.origin.x, self.dashboardButton.frame.origin.y, dashboardButtonSize+10, dashboardButtonSize+10);
        self.dashboardButton.layer.cornerRadius=dashboardButtonSize / 2;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^(){
            self.dashboardButton.frame = CGRectMake(self.dashboardButton.frame.origin.x, self.dashboardButton.frame.origin.y, 0, 0);
        }completion:^(BOOL finished){
            self.userInteractionEnabled=YES;
            if (complete){
                complete(finished);
            }
        }];
    }];
}

@end
