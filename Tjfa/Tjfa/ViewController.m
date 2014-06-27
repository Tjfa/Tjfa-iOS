//
//  ViewController.m
//  Tjfa
//
//  Created by 邱峰 on 14-3-24.
//  Copyright (c) 2014年 邱峰. All rights reserved.
//

#import "ViewController.h"
#import "CompetitionManager.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel* testLable;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //    [[CompetitionManager sharedCompetitionManager] getLatestCompetitionsFromNetworkWithLimit:10 complete:^(NSArray* results, NSErv bn     //            NSLog(@"%@",error);
    //        }
    //        else{
    //            for (Competition* competition in results){
    //                NSLog(@"%@",competition);
    //                self.testLable.text=competition.name;
    //            }
    //        }
    //    }];

    NSArray* results = [[CompetitionManager sharedCompetitionManager] getCompetitionsFromCoreData];
    for (Competition* competition in results) {
        NSLog(@"%@", competition);
        self.testLable.text = competition.name;
    }
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
