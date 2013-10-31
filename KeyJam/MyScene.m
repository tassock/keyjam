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
#import "KJHudNode.h"
#import "BMMusicPlayer.h"
#import "KJScoreManager.h"

static inline CGPoint CGPointAdd(const CGPoint a,
                                 const CGPoint b)
{
    return CGPointMake(a.x + b.x, a.y + b.y);
}

@interface MyScene ()
{
    KJKeyboardNode *keyboardNode;
    KJHudNode *hudNode;
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
        
//        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        self.backgroundColor = [SKColor blackColor];
        
        hudHeight = 45;
        keyboardHeight = 240;
        timelineHeight = self.size.height - hudHeight - keyboardHeight;
        
        // Set up keyboard manager with 25 note keyboard
        [[KJKeyboardManager sharedManager] setNoteRange:NSMakeRange(48, 25)]; // move to sequence load for automatic range detection
        
        [self setupSceneLayers];
        [self setUpHUD];
        [_timelineLayerNode setUp];
        [self setUpKeyboard];
        
        [KJMusicPlayerManager sharedManager].timelineNode = _timelineLayerNode;
        [KJMusicPlayerManager sharedManager].beatsToPreLoad = 6;
        self.currentBeatInteger = 0;
    }
    return self;
}

- (void)setUpKeyboard
{
    keyboardNode = [[KJKeyboardNode alloc] initWithSize:CGSizeMake(self.size.width, keyboardHeight)];
    keyboardNode.position = CGPointZero;
    keyboardNode.anchorPoint = CGPointZero;
    [[BMMidiManager sharedInstance] addListener:[KJMusicPlayerManager sharedManager]];
    [_keyboardLayerNode addChild:keyboardNode];
}

- (void)setUpHUD
{
    hudNode = [[KJHudNode alloc] initWithSize:CGSizeMake(self.size.width, hudHeight)];
    hudNode.position = CGPointMake(0, self.size.height - hudHeight);
    hudNode.anchorPoint = CGPointZero;
    [_hudLayerNode addChild:hudNode];
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
            [[KJMusicPlayerManager sharedManager] reset];
            [[KJScoreManager sharedManager] resetScore];
            self.currentBeatInteger = 0;
            
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
    [hudNode updateToBeat:currentBeatFloat];
}

- (void)setCurrentBeatInteger:(NSUInteger)integer
{
    _currentBeatInteger = integer;
    NSLog(@"currentWholeBeat %lu", (unsigned long)_currentBeatInteger);
    [[KJMusicPlayerManager sharedManager] updateForBeat:_currentBeatInteger];
}

@end
