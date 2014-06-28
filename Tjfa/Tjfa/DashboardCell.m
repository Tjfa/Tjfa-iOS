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
    CGRect nameLableFrame;
    DashboardLabelDirection dahboardLableDirection;
    CGRect animateFrameCache;
}

- (CGFloat)widthSpace
{
    return 60;
}

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage*)image labelName:(NSString*)label direction:(DashboardLabelDirection)direction target:(id)target action:(SEL)action dashboardSize:(CGFloat)size
{
    if (self = [super initWithFrame:frame]) {

        dashboardButtonSize = size;
        dahboardLableDirection = direction;

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

        if (direction == kLeft) {
            nameLableFrame = CGRectMake([self widthSpace], 0, size, size);
            self.nameLable.textAlignment = NSTextAlignmentLeft;
            animateFrameCache = CGRectMake(nameLableFrame.origin.x + 10, nameLableFrame.origin.y, nameLableFrame.size.width, nameLableFrame.size.height);

        } else {
            nameLableFrame = CGRectMake(frame.size.width - 100 - [self widthSpace], 0, size, size);
            self.nameLable.textAlignment = NSTextAlignmentRight;
            animateFrameCache = CGRectMake(nameLableFrame.origin.x - 10, nameLableFrame.origin.y, nameLableFrame.size.width, nameLableFrame.size.height);
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
    self.userInteractionEnabled = NO;
    self.dashboardButton.frame = CGRectMake(self.dashboardButton.frame.origin.x, self.dashboardButton.frame.origin.y, 0, 0);
    self.dashboardButton.layer.cornerRadius = dashboardButtonSize / 4;

    if (dahboardLableDirection == kLeft) {
        self.nameLable.frame = CGRectMake(-100, self.nameLable.frame.origin.y, self.nameLable.frame.size.width, self.nameLable.frame.size.height);
    } else {
        self.nameLable.frame = CGRectMake(self.frame.size.width + 100, self.nameLable.frame.origin.y, self.nameLable.frame.size.width, self.nameLable.frame.size.height);
    }
}

- (void)setHideCacheFrame
{
    self.dashboardButton.frame = CGRectMake(self.dashboardButton.frame.origin.x, self.dashboardButton.frame.origin.y, dashboardButtonSize + 10, dashboardButtonSize + 10);
    self.dashboardButton.layer.cornerRadius = dashboardButtonSize / 2;
    self.nameLable.frame = animateFrameCache;
}

- (void)setHideFrame
{
    self.dashboardButton.frame = CGRectMake(self.dashboardButton.frame.origin.x, self.dashboardButton.frame.origin.y, 0, 0);
    if (dahboardLableDirection == kLeft) {
        self.nameLable.frame = CGRectMake(-100, self.nameLable.frame.origin.y, self.nameLable.frame.size.width, self.nameLable.frame.size.height);
    } else {
        self.nameLable.frame = CGRectMake(self.frame.size.width + 100, self.nameLable.frame.origin.y, self.nameLable.frame.size.width, self.nameLable.frame.size.height);
    }
}

- (void)setShowFrame
{
    self.dashboardButton.frame = CGRectMake(self.dashboardButton.frame.origin.x, self.dashboardButton.frame.origin.y, dashboardButtonSize, dashboardButtonSize);
    self.nameLable.frame = nameLableFrame;
}

- (void)setShowCacheFrame
{
    self.dashboardButton.frame = CGRectMake(self.dashboardButton.frame.origin.x, self.dashboardButton.frame.origin.y, dashboardButtonSize + 10, dashboardButtonSize + 10);
    self.dashboardButton.layer.cornerRadius = dashboardButtonSize / 2;
    self.nameLable.frame = animateFrameCache;
}

- (void)showWithAnimateComplete:(void (^)(BOOL))complete
{
    [self showAnimateInit];
    [UIView animateWithDuration:0.3 animations:^() {
    } completion:^(BOOL finished) {
        [self setShowCacheFrame];
        
        [UIView animateWithDuration:0.1 animations:^(){
            [self setShowFrame];
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
        [self setShowCacheFrame];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^(){
            [self setShowFrame];
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
        [self setHideCacheFrame];
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 animations:^(){
            [self setHideFrame];
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
        [self setHideCacheFrame];
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 animations:^(){
            [self setHideFrame];
        }completion:^(BOOL finished){
            self.userInteractionEnabled=YES;
            if (complete){
                complete(finished);
            }
        }];
    }];
}

@end
