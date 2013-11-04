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
    KJTimelineNode *timelineNode;
    NSTimeInterval _lastUpdateTime;
    NSTimeInterval _dt;
    CGFloat hudHeight;
    CGFloat timelineHeight;
    CGFloat keyboardHeight;
}
@property (nonatomic, strong, readwrite) SKNode *hudLayerNode;
@property (nonatomic, strong, readwrite) SKNode *timelineLayerNode;
@property (nonatomic, strong, readwrite) SKNode *keyboardLayerNode;
@property (nonatomic, assign, readwrite) NSUInteger currentBeatInteger;
@end

@implementation MyScene

- (void)setupSceneLayers
{
    _hudLayerNode = [SKNode node];
    _hudLayerNode.zPosition = 100;
    [self addChild:_hudLayerNode];
    
    _timelineLayerNode = [SKNode node];
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
        [self setUpTimeline];
        [self setUpKeyboard];
        
        [KJMusicPlayerManager sharedManager].timelineNode = timelineNode;
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

- (void)setUpTimeline
{
    timelineNode = [[KJTimelineNode alloc] initWithSize:CGSizeMake(self.size.width, self.size.height - hudHeight - keyboardHeight)];
    timelineNode.position = CGPointMake(0, self.size.height - keyboardHeight); // not really positioned right :/
    timelineNode.anchorPoint = CGPointZero;
    timelineNode.beatHeight = 100;
    [_timelineLayerNode addChild:timelineNode];
    
    [self addChild:[self starfieldEmitterNodeWithSpeed:-24
                                              lifetime:(self.frame.size.height / 23)
                                                 scale:0.2
                                             birthRate:1
                                                 color:[SKColor whiteColor]]];
    [self addChild:
     [self starfieldEmitterNodeWithSpeed:-16
                                lifetime:(self.frame.size.height/10)
                                   scale:0.14
                               birthRate:2
                                   color:[SKColor colorForControlTint:0.85]]];
    [self addChild:
     [self starfieldEmitterNodeWithSpeed:-10
                                lifetime:(self.frame.size.height/5)
                                   scale:0.10
                               birthRate:5
                                   color:[SKColor colorForControlTint:0.7]]];
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
            break;
        default:
            break;
    }
    
    UInt32 midiNote = (UInt32)[self midiNoteForKeyCode:theEvent.keyCode];
    if (midiNote != 500) [[BMMidiManager sharedInstance] reportNoteOnWithNote:midiNote velocity:127];
}

- (void)keyUp:(NSEvent *)theEvent
{
    UInt32 midiNote = (UInt32)[self midiNoteForKeyCode:theEvent.keyCode];
    if (midiNote != 500) [[BMMidiManager sharedInstance] reportNoteOffWithNote:midiNote];
}

- (NSUInteger)midiNoteForKeyCode:(NSUInteger)keyCode
{
    switch (keyCode) {
        case 0: // a
            return 60; // C3
            break;
        case 1: // s
            return 62;
            break;
        case 2: // d
            return 64;
            break;
        case 3: // f
            return 65;
            break;
        case 4: // h
            return 69;
            break;
        case 5: // g
            return 67;
            break;
        case 38: // j
            return 71;
            break;
        case 40: // k
            return 72;
            break;
        case 37: // l
            return 73;
            break;
        case 41: // ;
            return 75;
            break;
        case 39: // '
            return 77;
            break;
        default:
            return 500; // junk value
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
    
    [timelineNode updateToBeat:currentBeatFloat];
    [hudNode updateToBeat:currentBeatFloat];
}

- (void)setCurrentBeatInteger:(NSUInteger)integer
{
    _currentBeatInteger = integer;
    NSLog(@"currentWholeBeat %lu", (unsigned long)_currentBeatInteger);
    [[KJMusicPlayerManager sharedManager] updateForBeat:_currentBeatInteger];
}

- (SKEmitterNode *)starfieldEmitterNodeWithSpeed:(float)speed
                                        lifetime:(float)lifetime scale:(float)scale
                                       birthRate:(float)birthRate color:(SKColor*)color
{
    
//    SKLabelNode *star =
//    [SKLabelNode labelNodeWithFontNamed:@"Monaco"];
//    star.fontSize = 80.0f;
//    star.text = @".";
//    
//    SKTexture *texture;// = [SKTexture textureWithImageNamed:@"blackDot.png"];
//    SKView *textureView = [SKView new];
//    texture = [textureView textureFromNode:star];
//    texture.filteringMode = SKTextureFilteringNearest;
    
    SKTexture *texture = [SKTexture textureWithImageNamed:@"whiteDot"];
    
    SKEmitterNode *emitterNode = [SKEmitterNode new];
    emitterNode.particleTexture = texture;
    emitterNode.particleBirthRate = birthRate;
    emitterNode.particleColor = color;
    emitterNode.particleLifetime = lifetime;
    emitterNode.particleSpeed = speed;
    emitterNode.particleScale = scale;
    emitterNode.particleColorBlendFactor = 1;
    emitterNode.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMaxY(self.frame));
    emitterNode.particlePositionRange =
    CGVectorMake(CGRectGetMaxX(self.frame), 0);
    
//    emitterNode.particleAction = [SKAction repeatActionForever:
//                                  [SKAction sequence:@[
//                                                       [SKAction rotateToAngle:-M_PI_4 duration:1],
//                                                       [SKAction rotateToAngle:M_PI_4 duration:1],
//                                                       ]]];
//    emitterNode.particleSpeedRange = 16.0;
//    
//    // 1
//    float twinkles = 20;
//    SKKeyframeSequence *colorSequence =
//    [[SKKeyframeSequence alloc] initWithCapacity:twinkles*2];
//    // 2
//    float twinkleTime = 1.0/twinkles;
//    for (int i = 0; i < twinkles; i++) {
//        
//        // 3
//        [colorSequence addKeyframeValue:[SKColor whiteColor] time:((i*2)*twinkleTime/2)];
//        [colorSequence addKeyframeValue:[SKColor yellowColor] time:((i*2+1)*(twinkleTime/2))];
//    }
//    
//    // 4
//    emitterNode.particleColorSequence = colorSequence;
    
    [emitterNode advanceSimulationTime:lifetime];
    
    return emitterNode;
}

@end
