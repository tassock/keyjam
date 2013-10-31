//
//  KJScoreManager.m
//  KeyJam
//
//  Created by Peter Marks on 10/31/13.
//  Copyright (c) 2013 Peter Marks. All rights reserved.
//

#import "KJScoreManager.h"

@interface KJScoreManager ()
@property (nonatomic, assign, readwrite) NSUInteger score;
@end

@implementation KJScoreManager

+ (instancetype)sharedManager
{
    static dispatch_once_t pred;
    static KJScoreManager *manager = nil;
    
    dispatch_once(&pred, ^{ manager = [[self alloc] init]; });
    return manager;
}

- (void)incrementScore
{
    self.score ++;
}

- (void)resetScore
{
    self.score = 0;
}

@end
