//
//  KJKeyboardManager.h
//  KeyJam
//
//  Created by Peter Marks on 9/10/13.
//  Copyright (c) 2013 Peter Marks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMMidiManager.h"
#import "BMNoteEvent.h"

@class KJKeyModel;

@interface KJKeyboardManager : NSObject <BMMidiListener>
@property (nonatomic, strong, readonly)NSArray *keyModels;
@property (nonatomic, assign, readonly) NSInteger majorKeyCount;
@property (nonatomic, assign, readwrite) NSRange noteRange;

+ (instancetype)sharedManager;
- (KJKeyModel*)keyModelForNoteNumber:(UInt32)noteNumber;

// creates a KJScheduledNote with a given BMNoteEvent. KJScheduledNote records actual note on note off
- (void)addScheduledNoteEvent:(BMNoteEvent*)noteEvent;

// Identifies KJScheduledNotes ended past a given beat, evaluates and removes them
- (void)evaluateNotesEndedAtBeat:(Float64)beat;

// finds the next scheduled KJScheduledNote and sets noteOnBeat to the current beat
// Calls noteOn for corresponding KJKeyModel to update UI
- (void)noteOnWithNote:(UInt32)note velocity:(UInt32)velocity;

// finds the next scheduled KJScheduledNote and sets noteOffBeat to the current beat
// Calls noteOff for corresponding KJKeyModel to update UI
- (void)noteOffWithNote:(UInt32)note;
@end

@interface KJMusicPlayerManager
// calls addScheduledNoteEvent for each sprite added to timeline
// calls evaluateNotesEndedAtBeat: when sprites exit the timeline
@end

@interface KJScheduledNote : NSObject
@property (nonatomic, readwrite, strong) BMNoteEvent *scheduledNote;
@property (nonatomic, readwrite, assign) Float64  noteOnBeat;
@property (nonatomic, readwrite, assign) Float64  noteOffBeat;
@end