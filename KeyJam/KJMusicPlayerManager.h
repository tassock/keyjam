//
//  KJMusicPlayerManager.h
//  KeyJam
//
//  Created by Peter Marks on 10/28/13.
//  Copyright (c) 2013 Peter Marks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMMidiManager.h"
#import "BMNoteEvent.h"
#import "KJScheduledNote.h"
#import "KJTimelineNode.h"

@interface KJMusicPlayerManager : NSObject <BMMidiListener>
@property (nonatomic, assign, readonly) NSInteger beatsLoaded;
@property (nonatomic, assign, readwrite) NSInteger beatsToPreLoad;
@property (nonatomic, strong, readwrite) KJTimelineNode *timelineNode;

+ (instancetype)sharedManager;
- (void)setUp;
- (void)updateForBeat:(NSInteger)currentBeat;
- (void)reset;

#pragma mark - BMMidiListener

/**
 *  Checks for a KJScheduledNote to be played at this time. If found set metNoteOnTarget to the current beat, call noteOn corresponding KJKeyModel
 *
 *  @param note     note Number of the note on
 *  @param velocity velocity of the note on
 */
- (void)noteOnWithNote:(UInt32)note velocity:(UInt32)velocity;

// finds the next scheduled KJScheduledNote and sets noteOffBeat to the current beat
// Calls noteOff for corresponding KJKeyModel to update UI
- (void)noteOffWithNote:(UInt32)note;
@end
