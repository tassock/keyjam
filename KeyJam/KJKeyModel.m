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
    _shapeNode.fillColor = [SKColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
}

- (void)noteOff
{
    
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

@end
