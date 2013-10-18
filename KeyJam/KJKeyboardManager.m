//
//  KJKeyboardManager.m
//  KeyJam
//
//  Created by Peter Marks on 9/10/13.
//  Copyright (c) 2013 Peter Marks. All rights reserved.
//

#import "KJKeyboardManager.h"
#import "KJKeyModel.h"

@implementation KJKeyboardManager

+ (instancetype)sharedManager
{
    static dispatch_once_t pred;
    static KJKeyboardManager *manager = nil;
    
    dispatch_once(&pred, ^{ manager = [[self alloc] init]; });
    return manager;
}

- (void)setNoteRange:(NSRange)noteRange
{
    _noteRange = noteRange;
    
    NSMutableArray *mutableKeys = [[NSMutableArray alloc] initWithCapacity:25];
    for (NSUInteger i = noteRange.location; i < noteRange.length; i ++) {
        KJKeyModel *keyModel = [KJKeyModel keyModelWithNoteNumber:i];
        [mutableKeys addObject:keyModel];
    }
    _keyModels = [NSArray arrayWithArray:mutableKeys];
}

- (KJKeyModel*)keyModelForNoteNumber:(NSInteger)noteNumber
{
    NSInteger noteIndex = noteNumber - self.noteRange.location;
    NSAssert(noteIndex < _keyModels.count, @"noteIndex out of range");
    return [_keyModels objectAtIndex:noteIndex];
}

- (void)noteOn:(NSInteger)noteNumber
{
    [[self keyModelForNoteNumber:noteNumber] noteOn];
}

- (void)noteOff:(NSInteger)noteNumber
{
    [[self keyModelForNoteNumber:noteNumber] noteOff];
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

@end
