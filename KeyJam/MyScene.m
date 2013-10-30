//
//  MyScene.m
//  KeyJam
//
//  Created by Peter Marks on 9/9/13.
//  Copyright (c) 2013 Peter Marks. All rights reserved.
//

#import "MyScene.h"
#import "KJKeyboardManager.h"
#import "KJKeyModel.h"
#import "KJKeyboardNode.h"
#import "KJMusicPlayerManager.h"
#import "KJTimelineNode.h"
#import "BMMusicPlayer.h"

static inline CGPoint CGPointAdd(const CGPoint a,
                                 const CGPoint b)
{
    return CGPointMake(a.x + b.x, a.y + b.y);
}

@interface MyScene ()
{
    SKLabelNode *beatLabel;
    KJKeyboardNode *keyboardNode;
    NSTimeInterval _lastUpdateTime;
    NSTimeInterval _dt;
    CGFloat hudHeight;
    CGFloat timelineHeight;
    CGFloat keyboardHeight;
}
@property (nonatomic, strong, readwrite) SKNode *hudLayerNode;
@property (nonatomic, strong, readwrite) KJTimelineNode *timelineLayerNode;
@property (nonatomic, strong, readwrite) SKNode *keyboardLayerNode;
@property (nonatomic, assign, readwrite) NSUInteger currentBeatInteger;
@end

@implementation MyScene

- (void)setupSceneLayers
{
    _hudLayerNode = [SKNode node];
    _hudLayerNode.zPosition = 100;
    [self addChild:_hudLayerNode];
    
    _timelineLayerNode = [KJTimelineNode node];
    _timelineLayerNode.beatHeight = 100;
    [self addChild:_timelineLayerNode];
    
    _keyboardLayerNode = [SKNode node];
    _keyboardLayerNode.zPosition = 100;
    [self addChild:_keyboardLayerNode];
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        hudHeight = 45;
        keyboardHeight = 240;
        timelineHeight = self.size.height - hudHeight - keyboardHeight;
        
        [self setupSceneLayers];
        [self setUpHUD];
        [_timelineLayerNode setUp];
        [self setUpKeyboard];
        
        [KJKeyboardManager sharedManager].timelineNode = _timelineLayerNode;
        [KJMusicPlayerManager sharedManager].beatsToPreLoad = 6;
        self.currentBeatInteger = 0;
    }
    return self;
}

- (void)setUpHUD
{
    // background
    CGSize backgroundSize = CGSizeMake(self.size.width, hudHeight);
    SKColor *backgroundColor = [SKColor colorWithRed:0 green:0 blue:0.05 alpha:1.0];
    SKSpriteNode *hudBarBackground = [SKSpriteNode spriteNodeWithColor:backgroundColor size:backgroundSize];
    hudBarBackground.position = CGPointMake(0, self.size.height - hudHeight);
    hudBarBackground.anchorPoint = CGPointZero;
    [_hudLayerNode addChild:hudBarBackground];
    
    // Add buttons when I figure out how I want to do these. KoboldKit?
    
    // beat label
    beatLabel = [SKLabelNode labelNodeWithFontNamed:@"Monaco"];
    beatLabel.fontSize = 30.0;
    beatLabel.text = @"1.1.1";
    beatLabel.name = @"beatLabel";
    beatLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    beatLabel.position = CGPointMake(self.size.width / 2, self.size.height - beatLabel.frame.size.height + 3);
    [_hudLayerNode addChild:beatLabel];
}

- (void)setUpKeyboard
{
    keyboardNode = [[KJKeyboardNode alloc] initWithSize:CGSizeMake(self.size.width, keyboardHeight)];
    keyboardNode.position = CGPointZero;
    keyboardNode.anchorPoint = CGPointZero;
    [[BMMidiManager sharedInstance] addListener:[KJKeyboardManager sharedManager]];
    [_keyboardLayerNode addChild:keyboardNode];
}

-(void)keyDown:(NSEvent *)theEvent
{
    NSLog(@"key code: %u", theEvent.keyCode);
    switch (theEvent.keyCode) {
        case 49: // space
            if ([BMMusicPlayer sharedInstance].isPlaying)
            {
                [[BMMusicPlayer sharedInstance] pause];
            }
            else
            {
                [[BMMusicPlayer sharedInstance] play];
            }
            break;
        case 36: // return
            [[BMMusicPlayer sharedInstance] reset];
            
        default:
            break;
    }
}

//-(void)mouseDown:(NSEvent *)theEvent {
//     /* Called when a mouse click occurs */
//    
//    CGPoint location = [theEvent locationInNode:self];
//    
//    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
//    
//    sprite.position = location;
//    sprite.scale = 0.5;
//    
//    SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
//    
//    [sprite runAction:[SKAction repeatActionForever:action]];
//    
//    [self addChild:sprite];
//}

#pragma mark - Update logic

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
//    beatLabel.text = [BMMusicPlayer sharedInstance].currentBeatString;
    beatLabel.text = [NSString stringWithFormat:@"%f", [BMMusicPlayer sharedInstance].currentBeatFloat];
    
    if (_lastUpdateTime) {
        _dt = currentTime - _lastUpdateTime;
    } else {
        _dt = 0;
    }
    _lastUpdateTime = currentTime;
    
    // check currentWholeBeat
    Float64 currentBeatFloat = [BMMusicPlayer sharedInstance].currentBeatFloat;
    if (_currentBeatInteger < (NSUInteger)currentBeatFloat)
    {
        self.currentBeatInteger = (NSUInteger)currentBeatFloat;
    }
    
    [_timelineLayerNode updateToBeat:currentBeatFloat];
}

- (void)setCurrentBeatInteger:(NSUInteger)integer
{
    _currentBeatInteger = integer;
    NSLog(@"currentWholeBeat %lu", (unsigned long)_currentBeatInteger);
    [[KJMusicPlayerManager sharedManager] updateForBeat:_currentBeatInteger];
}

@end
