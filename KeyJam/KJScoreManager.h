//
//  KJScoreManager.h
//  KeyJam
//
//  Created by Peter Marks on 10/31/13.
//  Copyright (c) 2013 Peter Marks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KJScoreManager : NSObject
@property (nonatomic, assign, readonly) NSUInteger score;
+ (instancetype)sharedManager;
- (void)incrementScore;
- (void)resetScore;
@end
