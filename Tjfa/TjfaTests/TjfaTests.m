//
//  TjfaTests.m
//  TjfaTests
//
//  Created by 邱峰 on 14-3-24.
//  Copyright (c) 2014年 邱峰. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSDate+Date2Str.h"
#import "CompetitionManager.h"

@interface TjfaTests : XCTestCase

@end

@implementation TjfaTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

- (void)testDate
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:10000];
    NSLog(@"%@", [date date2CompetitionStr]);
}

- (void)testNetwork
{
}

- (void)testCompetition
{

}

@end
