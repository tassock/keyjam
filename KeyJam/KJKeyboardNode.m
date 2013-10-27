//
//  KJKeyboardNode.m
//  KeyJam
//
//  Created by Peter Marks on 10/27/13.
//  Copyright (c) 2013 Peter Marks. All rights reserved.
//

#import "KJKeyboardNode.h"
#import "KJKeyboardManager.h"
#import "KJKeyModel.h"

@implementation KJKeyboardNode

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithColor:[SKColor grayColor] size:size])
    {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    NSRange noteRange = [KJKeyboardManager sharedManager].noteRange;
    long keyCount = [KJKeyboardManager sharedManager].majorKeyCount;
    int keyWidth = self.frame.size.width / (CGFloat)keyCount;
    int keyHeight = keyWidth * 2;
    CGFloat spaceBetweenKeys = 8.0;
    CGFloat keyRadius = 4.0;
    CGFloat majorX = 0;
    CGFloat minorX = keyWidth / 2.0;
    for (UInt32 i = 0; i < noteRange.length; i ++)
    {
        UInt32 noteNumber = i + (UInt32)noteRange.location;
        KJKeyModel *keyModel = [[KJKeyboardManager sharedManager] keyModelForNoteNumber:noteNumber];
        SKShapeNode *shape = [[SKShapeNode alloc] init];
        keyModel.shapeNode = shape;
        if (keyModel.isMajor)
        {
            shape.path = CGPathCreateWithRoundedRect(CGRectMake(majorX, 0, keyWidth - spaceBetweenKeys, keyHeight), keyRadius, 0, NULL);
            majorX += keyWidth;
            shape.fillColor = [keyModel defaultColor];
        }
        else
        {
            shape.path = CGPathCreateWithRoundedRect(CGRectMake(minorX, keyHeight, keyWidth - spaceBetweenKeys, keyHeight), keyRadius, 0, NULL);
            minorX += keyWidth;
            if (keyModel.keyEnum == KJKeyModelKeyDSharp || keyModel.keyEnum == KJKeyModelKeyASharp) minorX += keyWidth;
            shape.fillColor = [keyModel defaultColor];
        }
        [self addChild:shape];
    }
}

@end
