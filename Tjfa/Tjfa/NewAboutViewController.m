//
//  NewAboutViewController.m
//  Tjfa
//
//  Created by 邱峰 on 7/10/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "NewAboutViewController.h"
#import "Developer.h"
#import "UIColor+AppColor.h"
#import "AboutManager.h"
#import <iCarousel.h>

@interface NewAboutViewController ()

@property (nonatomic, weak) IBOutlet iCarousel* carouselView;

@property (nonatomic, weak) IBOutlet UILabel* nameLabel;

@property (nonatomic, strong) NSMutableArray* data;

@end

@implementation NewAboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor appBackgroundColor];
    // Do any additional setup after loading the view.
}

- (NSMutableArray*)data
{
    if (_data == nil) {
        _data = [[NSMutableArray alloc] init];
        NSArray* name = @[ @"aaa", @"bb", @"ccc", @"ddd", @"xxx", @"ddd" ];
        NSArray* imageName = @[ @"dashboardNews", @"qiufeng", @"qiufeng", @"qiufeng", @"qiufeng", @"qiufeng" ];
        for (int i = 0; i < name.count; i++) {
            Developer* developer = [[Developer alloc] initWithName:name[i] imageName:imageName[i]];
            [_data addObject:developer];
        }
    }
    return _data;
}

- (void)setCarouselView:(iCarousel*)carouselView
{
    if (_carouselView != carouselView) {
        _carouselView = carouselView;
        _carouselView.type = iCarouselTypeRotary;
        _carouselView.clipsToBounds = YES;
    }
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel*)carousel
{
    return [self.data count];
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel*)carousel
{
    //limit the number of items views loaded concurrently (for performance reasons)
    //this also affects the appearance of circular-type carousels
    return self.data.count;
}

- (UIView*)carousel:(iCarousel*)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView*)view
{
    if (view == nil) {
        Developer* developer = self.data[index];

        CGFloat size = 160;
        CGFloat imageSize = 130;
        CGFloat yPosition = 10;

        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size, size)];

        UIView* borderView = [[UIView alloc] initWithFrame:CGRectMake((size - imageSize) / 2 - 5, yPosition - 5, imageSize + 10, imageSize + 10)];
        borderView.layer.cornerRadius = (imageSize + 10) / 2;
        borderView.backgroundColor = [UIColor whiteColor];

        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake((size - imageSize) / 2, yPosition, imageSize, imageSize)];
        imageView.image = developer.image;
        imageView.layer.cornerRadius = imageSize / 2;
        imageView.clipsToBounds = YES;

        [view addSubview:borderView];
        [view addSubview:imageView];
    }
    return view;
}

- (CGFloat)carouselItemWidth:(iCarousel*)carousel
{
    return 180;
}

- (CATransform3D)carousel:(iCarousel*)_carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * self.carouselView.itemWidth);
}

- (CGFloat)carousel:(iCarousel*)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option) {
    case iCarouselOptionRadius: {
        return value;
    }
    case iCarouselOptionTilt: {
        return 0.8;
    }
    case iCarouselOptionSpacing: {
        return 0.8;
    }
    default: {
        return value;
    }
    }
}

- (void)carouselDidScroll:(iCarousel*)carousel
{
    int index = (int)round(carousel.scrollOffset);
    Developer* developer = self.data[index % self.data.count];
    self.nameLabel.text = developer.name;
}

- (void)carouselDidEndScrollingAnimation:(iCarousel*)carousel
{
    int index = (int)round(carousel.scrollOffset);
    Developer* developer = self.data[index % self.data.count];
    self.nameLabel.text = developer.name;
}

#pragma mark - tableView delegate & select action

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text isEqualToString:@"为我评分"]) {
        [self evaluate];
    } else if ([cell.textLabel.text isEqualToString:@"问题与反馈"]) {
        [self gotoSuggestion];
    } else if ([cell.textLabel.text isEqualToString:@"删除本地数据"]) {
        [self deleteLocalData];
    } else if ([cell.textLabel.text isEqualToString:@"告诉朋友"]) {
        [self sharedWithMessage];
    }
}

- (void)evaluate
{
    AboutManager* aboutManager = [AboutManager sharedAboutManager];
    aboutManager.instanceController = self;
    [aboutManager evaluate];
}

- (void)deleteLocalData
{
    AboutManager* aboutManager = [AboutManager sharedAboutManager];
    aboutManager.instanceController = self;
    [aboutManager deleteLocalData];
}

- (void)gotoSuggestion
{
    AboutManager* aboutManager = [AboutManager sharedAboutManager];
    aboutManager.instanceController = self;
    [aboutManager gotoSuggestion];
}

- (void)sharedWithMessage
{
    AboutManager* aboutManager = [AboutManager sharedAboutManager];
    aboutManager.instanceController = self;
    [aboutManager sharedWithMessage];
}

@end
