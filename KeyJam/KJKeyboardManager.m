//
//  KJKeyboardManager.m
//  KeyJam
//
//  Created by Peter Marks on 9/10/13.
//  Copyright (c) 2013 Peter Marks. All rights reserved.
//

#import "KJKeyboardManager.h"
#import "KJKeyModel.h"

@interface KJKeyboardManager ()
@property (nonatomic, strong, readwrite) NSArray *keyModels;
@end

@implementation KJKeyboardManager

+ (instancetype)sharedManager
{
    static dispatch_once_t pred;
    static KJKeyboardManager *manager = nil;
    
    dispatch_once(&pred, ^{ manager = [[self alloc] init]; });
    return manager;
}

// assumes first key is C
- (void)setNoteRange:(NSRange)noteRange
{
    _noteRange = noteRange;
    
    NSMutableArray *mutableKeys = [[NSMutableArray alloc] initWithCapacity:25];
    for (NSUInteger i = noteRange.location; i < (noteRange.location + noteRange.length); i ++) {
        KJKeyModel *keyModel = [KJKeyModel keyModelWithNoteNumber:i];
        [mutableKeys addObject:keyModel];
    }
    self.keyModels = [NSArray arrayWithArray:mutableKeys];
}

- (KJKeyModel*)keyModelForNoteNumber:(UInt32)noteNumber
{
    UInt32 noteIndex = (int)noteNumber - (int)_noteRange.location;
    // NSLog(@"noteNumber %u", noteNumber);
    if (noteIndex < _noteRange.length)
    {
        return [_keyModels objectAtIndex:noteIndex];
    }
    else
    {
        NSLog(@"not found");
        return nil;
    }
}

- (NSInteger)majorKeyCount
{
    NSInteger count = 0;
    for (KJKeyModel *keyModel in _keyModels)
    {
        if (keyModel.isMajor) count ++;
    }
    return count;
}

#pragma mark - BMMidiListener

// finds the next scheduled KJScheduledNote and sets noteOnBeat to the current beat
// Calls noteOn for corresponding KJKeyModel to update UI
- (void)noteOnWithNote:(UInt32)note velocity:(UInt32)velocity
{
    [[self keyModelForNoteNumber:note] noteOn];
}

// finds the next scheduled KJScheduledNote and sets noteOffBeat to the current beat
// Calls noteOff for corresponding KJKeyModel to update UI
- (void)noteOffWithNote:(UInt32)note
{
    [[self keyModelForNoteNumber:note] noteOff];
}

#pragma mark - MusicSequence handling

// creates a KJScheduledNote with a given BMNoteEvent. KJScheduledNote records actual note on note off
- (void)addScheduledNoteEvent:(BMNoteEvent*)noteEvent
{
    KJScheduledNote *scheduledNote = [[KJScheduledNote alloc] init];
    scheduledNote.noteEvent = noteEvent;
    if (_timelineNode) [_timelineNode addScheduledNote:scheduledNote];
}

// Identifies KJScheduledNotes ended past a given beat, evaluates and removes them
- (void)evaluateNotesEndedAtBeat:(Float64)beat
{
    
}

@end
