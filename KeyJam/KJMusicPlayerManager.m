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

@interface KJMusicPlayerManager ()
@property (nonatomic, assign, readwrite) NSInteger beatsLoaded;
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
    [musicPlayer loadSequenceFromMidiFile:@"CarntSleepBassline"];
    musicPlayer.currentTempo = 70.0;
    [musicPlayer noteEventsOnOrAfterBeat:0 beforeBeat:32]; // uncessary here I think
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
            [[KJKeyboardManager sharedManager] addScheduledNoteEvent:noteEvent];
        }
        _beatsLoaded ++;
    }
    
    // call KJKeyboardManager evaluateNotesEndedAtBeat: when sprites exit the timeline
}

@end
