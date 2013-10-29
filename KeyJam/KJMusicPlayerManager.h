//
//  KJMusicPlayerManager.h
//  KeyJam
//
//  Created by Peter Marks on 10/28/13.
//  Copyright (c) 2013 Peter Marks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KJMusicPlayerManager : NSObject
@property (nonatomic, assign, readonly) NSUInteger beatsLoaded;
@property (nonatomic, assign, readwrite) NSUInteger beatsToPreLoad;

+ (instancetype)sharedManager;
- (void)setUp;
- (void)updateForBeat:(NSUInteger)currentBeat;

@end
