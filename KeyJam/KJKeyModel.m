//
//  KJKeyModel.m
//  KeyJam
//
//  Created by Peter Marks on 9/10/13.
//  Copyright (c) 2013 Peter Marks. All rights reserved.
//

#import "KJKeyModel.h"

@interface KJKeyModel ()
@property (nonatomic, readwrite, assign) NSInteger noteNumber;
@end

@implementation KJKeyModel

+ (instancetype)keyModelWithNoteNumber:(NSUInteger)noteNumber
{
    KJKeyModel *model = [[KJKeyModel alloc] init];
    if (model)
    {
        model.noteNumber = noteNumber;
    }
    return model;
}

// could make this static for performance
+ (NSArray*)minorKeyNumbers
{
    return @[@1, @3, @6, @8, @10];
}

// could make this static for performance
+ (NSArray*)majorKeyNumbers
{
    return @[@0, @2, @4, @5, @7, @9, @11];
}

- (NSUInteger)octave
{
    return _noteNumber / 12;
}

- (void)noteOn
{
    _shapeNode.fillColor = [SKColor orangeColor];
}

- (void)noteOff
{
    _shapeNode.fillColor = [self defaultColor];
}

- (BOOL)isMajor
{
    int keyInt = _noteNumber % 12;
    return [[KJKeyModel majorKeyNumbers] containsObject:[NSNumber numberWithInt:keyInt]];
}

- (KJKeyModelKey)keyEnum
{
    int keyInt = _noteNumber % 12;
    return keyInt;
}

- (SKColor*)defaultColor
{
    if ([self isMajor])
    {
        return [SKColor whiteColor];
    }
    else
    {
        return [SKColor blackColor];
    }
}

- (NSString*)keyString
{
    switch ([self keyEnum]) {
        case KJKeyModelKeyC:
            return @"C"; break;
        case KJKeyModelKeyCSharp:
            return @"C#"; break;
        case KJKeyModelKeyD:
            return @"D"; break;
        case KJKeyModelKeyDSharp:
            return @"D#"; break;
        case KJKeyModelKeyE:
            return @"E"; break;
        case KJKeyModelKeyF:
            return @"F"; break;
        case KJKeyModelKeyFSharp:
            return @"F#"; break;
        case KJKeyModelKeyG:
            return @"G"; break;
        case KJKeyModelKeyGSharp:
            return @"G#"; break;
        case KJKeyModelKeyA:
            return @"A"; break;
        case KJKeyModelKeyASharp:
            return @"A#"; break;
        case KJKeyModelKeyB:
            return @"B"; break;
    }
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"%@ %u", [self keyString], (int)_noteNumber / 12];
}

@end
