//
//  KJMusicPlayerManager.m
//  KeyJam
//
//  Created by Peter Marks on 10/28/13.
//  Copyright (c) 2013 Peter Marks. All rights reserved.
//

#import "KJMusicPlayerManager.h"
#import "BMMusicPlayer.h"
#import "BMNoteEvent.h"
#import "KJKeyboardManager.h"
#import "KJKeyModel.h"
#import "KJScoreManager.h"

@interface KJMusicPlayerManager ()
@property (nonatomic, assign, readwrite) NSInteger beatsLoaded;
@property (nonatomic, strong, readwrite) NSMutableArray *scheduledNotes;
@end

@implementation KJMusicPlayerManager

+ (instancetype)sharedManager
{
    static dispatch_once_t pred;
    static KJMusicPlayerManager *manager = nil;
    
    dispatch_once(&pred, ^{ manager = [[self alloc] init]; });
    return manager;
}

- (void)setUp
{
    BMMusicPlayer *musicPlayer = [BMMusicPlayer sharedInstance];
    [musicPlayer loadSequenceFromMidiFile:@"c-scale"];
    musicPlayer.currentTempo = 70.0;
    [musicPlayer noteEventsOnOrAfterBeat:0 beforeBeat:32]; // uncessary here I think
    self.scheduledNotes = [[NSMutableArray alloc] initWithCapacity:5];
}

- (void)updateForBeat:(NSInteger)currentBeat
{
    // call KJKeyboardManager addScheduledNoteEvent: for each sprite added to timeline
    while (currentBeat > _beatsLoaded - _beatsToPreLoad) {
        Float64 afterBeat = _beatsLoaded;
        Float64 beforeBeat = afterBeat + 1;
        // NSLog(@"FETCHING afterBeat %f, beforeBeat %f", afterBeat, beforeBeat);
        NSArray *noteEvents = [[BMMusicPlayer sharedInstance] noteEventsOnOrAfterBeat:afterBeat beforeBeat:beforeBeat];
        for (BMNoteEvent *noteEvent in noteEvents)
        {
            NSLog(@"noteEvent.note %u", noteEvent.note);
            [self addScheduledNoteEvent:noteEvent];
        }
        _beatsLoaded ++;
    }
    
    [self evaluateNotesEndedAtBeat:currentBeat];
    
    // call KJKeyboardManager evaluateNotesEndedAtBeat: when sprites exit the timeline
    
}

- (void)reset
{
    [[BMMusicPlayer sharedInstance] reset];
    self.beatsLoaded = 0;
    [self updateForBeat:0];
    
    // empty out KJKeyboardManager's scheduled notes? Should that logic be here?
}

#pragma mark - BMMidiListener

- (void)noteOnWithNote:(UInt32)note velocity:(UInt32)velocity
{
    KJKeyModel *keyModel = [[KJKeyboardManager sharedManager] keyModelForNoteNumber:note];
    [keyModel noteOn];
    
    Float64 currentBeatFloat = [BMMusicPlayer sharedInstance].currentBeatFloat;
    Float64 noteOnWiggleRoom = 0.3;
    for (KJScheduledNote *scheduledNote in _scheduledNotes)
    {
        if (scheduledNote.noteNumber == note &&
            scheduledNote.scheduledBeatStart <= currentBeatFloat + noteOnWiggleRoom &&
            scheduledNote.scheduledBeatEnd >= currentBeatFloat &&
            scheduledNote.metNoteOnTarget == NO)
        {
            scheduledNote.node.fillColor = [SKColor greenColor];
            scheduledNote.noteOnBeat = currentBeatFloat;
            scheduledNote.metNoteOnTarget = YES;
            [[KJScoreManager sharedManager] incrementScore];
            break;
        }
    }
}

// finds the next scheduled KJScheduledNote and sets noteOffBeat to the current beat
- (void)noteOffWithNote:(UInt32)note
{
    KJKeyModel *keyModel = [[KJKeyboardManager sharedManager] keyModelForNoteNumber:note];
    [keyModel noteOff];
    
    for (KJScheduledNote *scheduledNote in _scheduledNotes)
    {
        if (scheduledNote.noteNumber == note && !scheduledNote.noteOnBeat) // && scheduledNote.scheduledBeatEnd < currentBeat
        {
            scheduledNote.node.fillColor = [SKColor blueColor];
            break;
        }
    }
}

#pragma mark - MusicSequence handling

// creates a KJScheduledNote with a given BMNoteEvent. KJScheduledNote records actual note on note off
- (void)addScheduledNoteEvent:(BMNoteEvent*)noteEvent
{
    KJScheduledNote *scheduledNote = [KJScheduledNote scheduledNoteWithEvent:noteEvent];
    [_scheduledNotes addObject:scheduledNote];
    if (_timelineNode) [_timelineNode addNodeForScheduledNote:scheduledNote];
}

// Identifies KJScheduledNotes ended past a given beat, evaluates score and removes node
- (void)evaluateNotesEndedAtBeat:(Float64)beat
{
    NSMutableArray *notesToRemove = [[NSMutableArray alloc] initWithCapacity:5];
    for (KJScheduledNote *scheduledNote in _scheduledNotes)
    {
        if (scheduledNote.scheduledBeatEnd < beat)
        {
            if (_timelineNode) [_timelineNode removeNodeForScheduledNote:scheduledNote];
            [notesToRemove addObject:scheduledNote];
        }
    }
    [_scheduledNotes removeObjectsInArray:notesToRemove];
    
    
    // requires me to keep an internal array of scheduledNotes?
    // could iterate through the first part of the array, but how do I know when to stop? A note could start later, but end sooner. I guess if I'm iterating through only the notes on screen, that's not a huge amount
    // how do I clear out notes when I reset the sequence?
    // I need a reference to the sprite node to remove it. I could add a node property to scheduled note, I guess. Should I really be doing this at the timeline node level?
}
@end
