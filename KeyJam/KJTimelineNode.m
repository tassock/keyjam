//
//  KJTimelineNode.m
//  KeyJam
//
//  Created by Peter Marks on 10/28/13.
//  Copyright (c) 2013 Peter Marks. All rights reserved.
//

#import "KJTimelineNode.h"
#import "BMMusicPlayer.h"
#import "KJScheduledNote.h"
#import "KJKeyboardManager.h"

@implementation KJTimelineNode

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithColor:[SKColor clearColor] size:size]) 
    {
        [self setUp];
    }
    return self;
}


- (void)setUp
{
//    for (int i = 0; i < 2; i++) {
//        SKSpriteNode * bg = [SKSpriteNode spriteNodeWithImageNamed:@"beatChart"];
//        bg.color = [SKColor blackColor];
//        bg.anchorPoint = CGPointZero;
//        bg.position = CGPointMake(0, 240 + (i * bg.size.height)); // get hardcoded value out of here!
//        bg.name = @"bg";
//        [self addChild:bg];
//    }
}

- (void)updateToBeat:(CGFloat)currentBeatFloat;
{
    //    CGPoint bgVelocity = CGPointMake(-BG_POINTS_PER_SEC, 0);
    //    CGPoint amtToMove = CGPointMultiplyScalar(bgVelocity, _dt);
    //    _scrollLayerNode.position = CGPointAdd(_scrollLayerNode.position, amtToMove);
    CGFloat yValue = ([BMMusicPlayer sharedInstance].currentBeatFloat * _beatHeight) * -1.0;
    self.position = CGPointMake(0, yValue);
    
//    [self enumerateChildNodesWithName:@"bg"
//                                       usingBlock:^(SKNode *node, BOOL *stop)
//     {
//         SKSpriteNode * bg = (SKSpriteNode*)node;
//         CGPoint bgScreenPos = [self convertPoint:bg.position toNode:self];
//         if (bgScreenPos.y <= - bg.size.height)
//         {
//             bg.position = CGPointMake(bg.position.x, bg.position.y + bg.size.height * 2);
//         }
//     }];
}

- (void)addNodeForScheduledNote:(KJScheduledNote*)scheduledNote
{
    KJKeyModel *keyModel = [[KJKeyboardManager sharedManager] keyModelForNoteNumber:scheduledNote.noteNumber];
    CGFloat xOffset = [[KJKeyboardManager sharedManager] xOffsetForKeyModel:keyModel];
    CGFloat yOffset = (scheduledNote.scheduledBeatStart * _beatHeight) + 240;
    CGFloat height = scheduledNote.scheduledDuration * _beatHeight;
    // NSLog(@"Add note %@ (%u) at beat %f", keyModel, scheduledNote.noteEvent.note, scheduledNote.noteEvent.beat);
    
    SKShapeNode *shape = [[SKShapeNode alloc] init];
    shape.path = CGPathCreateWithRoundedRect(CGRectMake(xOffset, yOffset, [KJKeyboardManager sharedManager].keyWidth, height), 0, 0, NULL);
    shape.fillColor = [SKColor blueColor];
    shape.strokeColor = [SKColor grayColor];
    scheduledNote.node = shape;
    shape.zPosition = 10;
    [self addChild:shape];
}

- (void)removeNodeForScheduledNote:(KJScheduledNote*)scheduledNote
{
    [scheduledNote.node removeFromParent];
    scheduledNote.node = nil; // dealloc node
}

@end
