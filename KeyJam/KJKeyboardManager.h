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
#import "KJScheduledNote.h"
#import "KJTimelineNode.h"

@class KJKeyModel;

@interface KJKeyboardManager : NSObject <BMMidiListener>
@property (nonatomic, strong, readonly)NSArray *keyModels;
@property (nonatomic, assign, readonly) NSInteger majorKeyCount;
@property (nonatomic, assign, readwrite) NSRange noteRange;
@property (nonatomic, strong, readwrite) KJTimelineNode *timelineNode;

// width of keys in UI, in points
@property (nonatomic, assign, readwrite) NSUInteger keyWidth;

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

// the x value (points) that ui elements should be for a given key model
- (CGFloat)xOffsetForKeyModel:(KJKeyModel*)keyModel;
@end