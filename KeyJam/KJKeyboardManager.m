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

- (id)init
{
    if (self = [super init])
    {
    }
    return self;
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

- (KJKeyModel*)keyModelForNoteNumber:(NSUInteger)noteNumber
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

#pragma mark - UI helpers

// the x value (points) that ui elements should be for a given key model
- (CGFloat)xOffsetForKeyModel:(KJKeyModel*)keyModel
{
    CGFloat indexOfKey;
    NSUInteger numberInOctave = keyModel.noteNumber % 12;
    if (keyModel.isMajor)
    {
        indexOfKey = [[KJKeyModel majorKeyNumbers] indexOfObject:[NSNumber numberWithInteger:numberInOctave]];
    }
    else
    {
        indexOfKey = [[KJKeyModel minorKeyNumbers] indexOfObject:[NSNumber numberWithInteger:numberInOctave]];
        if (indexOfKey > 1) indexOfKey ++; // +1 for the gap after the first two minor keys
        indexOfKey += 0.5; // indent minor key half a width
    }
    NSUInteger octavesFromOrigin = keyModel.octave - (_noteRange.location / 12);
    indexOfKey += (octavesFromOrigin * 7);
    CGFloat xOffset = indexOfKey * _keyWidth;
    return xOffset;
}

@end
