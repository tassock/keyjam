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
@property (nonatomic, strong, readwrite) SKNode *scrollLayerNode;
@property (nonatomic, strong, readwrite) SKNode *keyboardLayerNode;
@end

@implementation MyScene

- (void)setupSceneLayers
{
    _hudLayerNode = [SKNode node];
    _hudLayerNode.zPosition = 100;
    [self addChild:_hudLayerNode];
    
    _scrollLayerNode = [SKNode node];
    [self addChild:_scrollLayerNode];
    
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
        [self setUpScrollLayer];
        [self setUpKeyboard];
    }
    return self;
}

- (void)setUpScrollLayer
{
    for (int i = 0; i < 2; i++) {
        SKSpriteNode * bg = [SKSpriteNode spriteNodeWithImageNamed:@"beatChart"];
        bg.anchorPoint = CGPointZero;
        bg.position = CGPointMake(0, keyboardHeight + (i * bg.size.height));
        bg.name = @"bg";
        [_scrollLayerNode addChild:bg];
    }
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

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    beatLabel.text = [BMMusicPlayer sharedInstance].currentBeatString;
//    beatLabel.text = [NSString stringWithFormat:@"%f", [BMMusicPlayer sharedInstance].currentBeatFloat];
    
    if (_lastUpdateTime) {
        _dt = currentTime - _lastUpdateTime;
    } else {
        _dt = 0;
    }
    _lastUpdateTime = currentTime;
    
    [self moveTimelineView];
}

//- (CGFloat)backgroundPointPerSecond
//
//- (void)moveTimelineView
//{
//    CGPoint bgVelocity = CGPointMake(-BG_POINTS_PER_SEC, 0);
//    CGPoint amtToMove = CGPointMultiplyScalar(bgVelocity, _dt);
//    _bgLayer.position = CGPointAdd(_bgLayer.position, amtToMove);
//    
//    [_bgLayer enumerateChildNodesWithName:@"bg"
//                               usingBlock:^(SKNode *node, BOOL *stop){
//                                   SKSpriteNode * bg = (SKSpriteNode *) node;
//                                   CGPoint bgScreenPos = [_bgLayer convertPoint:bg.position
//                                                                         toNode:self];
//                                   if (bgScreenPos.x <= -bg.size.width) {
//                                       bg.position = CGPointMake(bg.position.x+bg.size.width*2,
//                                                                 bg.position.y);
//                                   }
//                               }];
//}

- (void)moveTimelineView
{
//    CGPoint bgVelocity = CGPointMake(-BG_POINTS_PER_SEC, 0);
//    CGPoint amtToMove = CGPointMultiplyScalar(bgVelocity, _dt);
//    _scrollLayerNode.position = CGPointAdd(_scrollLayerNode.position, amtToMove);
    CGFloat beatHeight = 25;
    CGFloat yValue = ([BMMusicPlayer sharedInstance].currentBeatFloat * beatHeight) * -1.0;
    _scrollLayerNode.position = CGPointMake(0, yValue);
    
    [_scrollLayerNode enumerateChildNodesWithName:@"bg"
                               usingBlock:^(SKNode *node, BOOL *stop)
    {
        SKSpriteNode * bg = (SKSpriteNode *) node;
        CGPoint bgScreenPos = [_scrollLayerNode convertPoint:bg.position toNode:self];
        if (bgScreenPos.y <= -bg.size.height)
        {
           bg.position = CGPointMake(bg.position.x, bg.position.y+bg.size.height*2);
        }
    }];
}

@end
