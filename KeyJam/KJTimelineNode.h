//
//  KJTimelineNode.h
//  KeyJam
//
//  Created by Peter Marks on 10/28/13.
//  Copyright (c) 2013 Peter Marks. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class KJScheduledNote;

@interface KJTimelineNode : SKSpriteNode
@property (nonatomic, assign, readwrite) CGFloat beatHeight;
- (id)initWithSize:(CGSize)size;
- (void)setUp;
- (void)updateToBeat:(CGFloat)currentBeatFloat;
- (void)addNodeForScheduledNote:(KJScheduledNote*)scheduledNote;
- (void)removeNodeForScheduledNote:(KJScheduledNote*)scheduledNote;
@end
