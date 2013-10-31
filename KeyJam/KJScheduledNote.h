//
//  KJScheduledNote.h
//  KeyJam
//
//  Created by Peter Marks on 10/28/13.
//  Copyright (c) 2013 Peter Marks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMNoteEvent.h"

@interface KJScheduledNote : NSObject
@property (nonatomic, readwrite, assign) NSUInteger noteNumber;
@property (nonatomic, readwrite, assign) Float64  scheduledBeatStart;
@property (nonatomic, readwrite, assign) Float64  scheduledDuration;
@property (nonatomic, readonly,  assign) Float64  scheduledBeatEnd;
@property (nonatomic, readwrite, assign) Float64  noteOnBeat;
@property (nonatomic, readwrite, assign) Float64  noteOffBeat;
@property (nonatomic, readwrite, assign) BOOL  metNoteOnTarget;
@property (nonatomic, readwrite, strong) SKShapeNode *node;
+ (instancetype)scheduledNoteWithEvent:(BMNoteEvent*)noteEvent;
@end
