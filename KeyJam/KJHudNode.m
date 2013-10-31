//
//  KJHudNode.m
//  KeyJam
//
//  Created by Peter Marks on 10/31/13.
//  Copyright (c) 2013 Peter Marks. All rights reserved.
//

#import "KJHudNode.h"
#import "BMMusicPlayer.h"
#import "KJScoreManager.h"

@interface KJHudNode ()
{
    SKLabelNode *beatLabel;
    SKLabelNode *scoreLabel;
}
@end

@implementation KJHudNode

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
    // beat label
    beatLabel = [SKLabelNode labelNodeWithFontNamed:@"Monaco"];
    beatLabel.fontSize = 30.0;
    beatLabel.text = @"1.1.1";
    beatLabel.name = @"beatLabel";
    beatLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    beatLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    beatLabel.position = CGPointMake(10, self.size.height - beatLabel.frame.size.height + 3);
    [self addChild:beatLabel];
    
    // score label
    scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Monaco"];
    scoreLabel.fontSize = 30.0;
    scoreLabel.text = @"1.1.1";
    scoreLabel.name = @"beatLabel";
    scoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    scoreLabel.position = CGPointMake(300, self.size.height - beatLabel.frame.size.height + 3);
    [self addChild:scoreLabel];
}

- (void)updateToBeat:(CGFloat)currentBeatFloat
{
    beatLabel.text = [NSString stringWithFormat:@"%f", [BMMusicPlayer sharedInstance].currentBeatFloat];
    scoreLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[KJScoreManager sharedManager].score];
}

@end
