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

@interface KJKeyboardNode ()
@end

@implementation KJKeyboardNode

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithColor:[SKColor darkGrayColor] size:size])
    {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    NSRange noteRange = [KJKeyboardManager sharedManager].noteRange;
    long keyCount = [KJKeyboardManager sharedManager].majorKeyCount;
    int keyHeight = (self.size.height / 2) - 2;
    NSUInteger keyWidth = self.frame.size.width / (CGFloat)keyCount;
    [KJKeyboardManager sharedManager].keyWidth = keyWidth;
    CGFloat spaceBetweenKeys = 8.0;
    CGFloat keyRadius = 4.0;
    for (UInt32 i = 0; i < noteRange.length; i ++)
    {
        UInt32 noteNumber = i + (UInt32)noteRange.location;
        KJKeyModel *keyModel = [[KJKeyboardManager sharedManager] keyModelForNoteNumber:noteNumber];
        CGFloat xOffset = [[KJKeyboardManager sharedManager] xOffsetForKeyModel:keyModel];
        CGFloat yOffset = (keyModel.isMajor) ? 0 : keyHeight;
        SKShapeNode *shape = [[SKShapeNode alloc] init];
        keyModel.shapeNode = shape;
        shape.path = CGPathCreateWithRoundedRect(CGRectMake(xOffset, yOffset, keyWidth - spaceBetweenKeys, keyHeight), keyRadius, 0, NULL);
        shape.fillColor = [keyModel defaultColor];
        [self addChild:shape];
    }
}

@end
