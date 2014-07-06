//
//  AboutDeveloperViewController.m
//  Tjfa
//
//  Created by 邱峰 on 6/29/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "AboutDeveloperViewController.h"
#import "Developer.h"
#import <iCarousel.h>

@interface AboutDeveloperViewController () <iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong) NSMutableArray* data;
@property (weak, nonatomic) IBOutlet iCarousel* carouselView;
@property (weak, nonatomic) IBOutlet UILabel* nameLabel;

@end

@implementation AboutDeveloperViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray*)data
{
    if (_data == nil) {
        _data = [[NSMutableArray alloc] init];
        NSArray* name = @[ @"aaa", @"bb", @"ccc", @"ddd", @"xxx" ];
        NSArray* imageName = @[ @"dashboardNews", @"qiufeng", @"qiufeng", @"qiufeng", @"qiufeng" ];
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
    }
}

- (void)setNameLabel:(UILabel*)nameLabel
{
    if (_nameLabel != nameLabel) {
        _nameLabel = nameLabel;
        if (!iPhone5) {
            _nameLabel.frame = CGRectMake(_nameLabel.frame.origin.x, _nameLabel.frame.origin.y - 70, _nameLabel.frame.size.width, _nameLabel.frame.size.height);
        }
    }
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

        CGFloat size = 200;
        CGFloat imageSize = 130;

        if (!iPhone5) {
            size = 130;
            imageSize = 100;
        }

        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size, size)];

        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake((size - imageSize) / 2, 20, imageSize, imageSize)];
        imageView.image = developer.image;
        imageView.layer.cornerRadius = imageSize / 2;
        imageView.clipsToBounds = YES;
        [view addSubview:imageView];
    }
    return view;
}

- (CGFloat)carouselItemWidth:(iCarousel*)carousel
{
    //usually this should be slightly wider than the item views
    return 220.0f;
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
    NSLog(@"%f %f", _carouselView.frame.size.height, self.nameLabel.frame.origin.y);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
