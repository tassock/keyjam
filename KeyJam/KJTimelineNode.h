//
//  KJTimelineNode.h
//  KeyJam
//
//  Created by Peter Marks on 10/28/13.
//  Copyright (c) 2013 Peter Marks. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class KJScheduledNote;

@interface KJTimelineNode : SKNode
@property (nonatomic, assign, readwrite) CGFloat beatHeight;
- (void)setUp;
- (void)updateToBeat:(CGFloat)currentBeatFloat;
- (void)addScheduledNote:(KJScheduledNote*)scheduledNote;
@end
