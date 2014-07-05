//
//  ViewController.m
//  Tjfa
//
//  Created by 邱峰 on 14-3-24.
//  Copyright (c) 2014年 邱峰. All rights reserved.
//

#import "ViewController.h"
#import "CompetitionManager.h"
#import "MatchManager.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel* testLable;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //here is code for server data
    //    [[CompetitionManager sharedCompetitionManager] getLatestCompetitionsFromNetworkWithType:@(1) limit:10 complete:^(NSArray* results, NSError* error) {
    //            if (error)  {
    //                     NSLog(@"%@",error);
    //            }
    //            else{
    //                for (Competition* competition in results){
    //                    NSLog(@"%@",competition);
    //                    self.testLable.text=competition.name;
    //                }
    //            }
    //    }];

    //here is code for local data
    NSArray* results = [[CompetitionManager sharedCompetitionManager] getCompetitionsFromCoreDataWithType:@(1)];
    for (Competition* competition in results) {
        NSLog(@"%@", competition);
        self.testLable.text = competition.name;
    }

    Competition* competition = [results firstObject];
        [[MatchManager sharedMatchManager] getMatchesByCompetitionFromNetwork:competition complete:^(NSArray* results, NSError* error) {
                for (Match* match in results){
                    NSLog(@"%@",match);
                }
        }];
    NSArray* matches = [[MatchManager sharedMatchManager] getMatchesByCompetitionFromCoreData:competition];
    for (Match* match in matches) {
        NSLog(@"%@", match);
    }
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
