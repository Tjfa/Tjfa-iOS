//
//  Developer.h
//  Tjfa
//
//  Created by 邱峰 on 6/28/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJDeveloper : NSObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) UIImage* image;

- (instancetype)initWithName:(NSString*)name imageName:(NSString*)imageName;

@end
