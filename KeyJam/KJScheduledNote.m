//
//  KJScheduledNote.m
//  KeyJam
//
//  Created by Peter Marks on 10/28/13.
//  Copyright (c) 2013 Peter Marks. All rights reserved.
//

#import "KJScheduledNote.h"

@implementation KJScheduledNote

+ (instancetype)scheduledNoteWithEvent:(BMNoteEvent*)noteEvent
{
    KJScheduledNote *scheduledNote = [[KJScheduledNote alloc] init];
    if (scheduledNote)
    {
        scheduledNote.noteNumber = noteEvent.note;
        scheduledNote.scheduledBeatStart = noteEvent.beat * 2.0;
        scheduledNote.scheduledDuration = noteEvent.duration * 2.0;
    }
    return scheduledNote;
}

- (Float64)scheduledBeatEnd
{
    return _scheduledBeatStart + _scheduledDuration;
}

@end
