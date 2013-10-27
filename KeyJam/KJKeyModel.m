//
//  KJKeyModel.m
//  KeyJam
//
//  Created by Peter Marks on 9/10/13.
//  Copyright (c) 2013 Peter Marks. All rights reserved.
//

#import "KJKeyModel.h"

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
    NSArray *majorKeys = @[@0, @2, @4, @5, @7, @9, @11];
    return [majorKeys containsObject:[NSNumber numberWithInt:keyInt]];
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
