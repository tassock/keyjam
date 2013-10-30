//
//  KJMusicPlayerManager.h
//  KeyJam
//
//  Created by Peter Marks on 10/28/13.
//  Copyright (c) 2013 Peter Marks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KJMusicPlayerManager : NSObject
@property (nonatomic, assign, readonly) NSInteger beatsLoaded;
@property (nonatomic, assign, readwrite) NSInteger beatsToPreLoad;

+ (instancetype)sharedManager;
- (void)setUp;
- (void)updateForBeat:(NSInteger)currentBeat;

@end
