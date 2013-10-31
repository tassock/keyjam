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
@property (nonatomic, readwrite, strong) BMNoteEvent *noteEvent;
@property (nonatomic, readwrite, assign) Float64  noteOnBeat;
@property (nonatomic, readwrite, assign) Float64  noteOffBeat;
@property (nonatomic, readwrite, strong) SKNode *node;
@end
