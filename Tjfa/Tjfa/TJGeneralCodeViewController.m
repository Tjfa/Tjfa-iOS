//
//  TJGeneralCodeViewController.m
//  Tjfa
//
//  Created by 邱峰 on 5/1/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "TJGeneralCodeViewController.h"
#import "MBProgressHUD+AppProgressView.h"
#import <AVCloud.h>

@interface TJGeneralCodeViewController()

@property (weak, nonatomic) IBOutlet UILabel *code0;
@property (weak, nonatomic) IBOutlet UILabel *code1;
@property (weak, nonatomic) IBOutlet UILabel *code2;
@property (weak, nonatomic) IBOutlet UILabel *code3;
@property (weak, nonatomic) IBOutlet UILabel *code4;
@property (weak, nonatomic) IBOutlet UILabel *code5;

@property (weak, nonatomic) IBOutlet UIButton *generalCodeButton;

@property (nonatomic, assign) BOOL isNeedStop;

@property (nonatomic, strong) NSArray *codeLabels;
@property (nonatomic, strong) NSArray *randomText;

@end


@implementation TJGeneralCodeViewController

#pragma mark - Life Circle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self stopGeneralCode];
}

#pragma mark - Getter & Setter

- (NSArray *)codeLabels
{
    if (_codeLabels == nil) {
        _codeLabels = @[self.code0, self.code1, self.code2, self.code3, self.code4, self.code5];
    }
    return _codeLabels;
}

- (NSArray *)randomText
{
    if (_randomText == nil) {
        
        NSMutableArray *result = [NSMutableArray array];
        
        for (int i = 0; i <= 9; i++) {          // 0 ~ 9
            [result addObject:[NSString stringWithFormat:@"%d", i]];
        }
        
        for (int i = 0; i < 26; i++) {          // A ~ Z
            [result addObject:[NSString stringWithFormat:@"%c", 'A'+i]];
        }
        
        _randomText = [NSArray arrayWithArray:result];
    }
    return _randomText;
}

- (void)startRandomCodeLabel
{
    if (self.isNeedStop) {
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (UILabel *label in self.codeLabels) {
            if (self.isNeedStop) {
                return;
            }
            NSInteger random = arc4random() % 35;
            label.text = self.randomText[random];
        }
        [self startRandomCodeLabel];
    });
}

- (void)stopGeneralCode
{
    self.generalCodeButton.enabled = YES;
    [self.generalCodeButton setTitle:@"生成邀请码" forState:UIControlStateNormal];
    self.isNeedStop = YES;
}

- (void)setLabelToZero
{
    for (UILabel *label in self.codeLabels) {
        [label setText:@"0"];
    }
}

- (IBAction)generalCodePress:(UIButton *)sender
{
    self.generalCodeButton.enabled = NO;
    [self.generalCodeButton setTitle:@"卖命生成邀请码中" forState:UIControlStateNormal];
    self.isNeedStop = NO;
    [self startRandomCodeLabel];
    
    [AVCloud callFunctionInBackground:@"getPromoCode" withParameters:nil block:^(id object, NSError *error) {
        [self stopGeneralCode];
        if (error == nil) {
            dispatch_async(dispatch_get_main_queue(), ^() {
                NSLog(@"%@",object);    //object is kind of string
                NSString *code = object;
                for (UILabel *label in self.codeLabels) {
                    [label setText:[code substringToIndex:1]];
                    code = [code substringFromIndex:1];
                }
            });
        }
        else {
            [MBProgressHUD showErrorProgressInView:nil withText:@"邀请码生成错误"];
            [self setLabelToZero];
        }
    }];
}


@end
