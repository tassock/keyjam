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

@interface MyScene ()
{
    SKLabelNode *beatLabel;
    KJKeyboardNode *keyboardNode;
}
@property (nonatomic, strong, readwrite) SKNode *hudLayerNode;
@property (nonatomic, strong, readwrite) SKNode *scrollLayerNode;
@property (nonatomic, strong, readwrite) SKNode *keyboardLayerNode;
@end

@implementation MyScene

- (void)setupSceneLayers
{
    _hudLayerNode = [SKNode node];
    [self addChild:_hudLayerNode];
    
    _scrollLayerNode = [SKNode node];
    [self addChild:_scrollLayerNode];
    
    _keyboardLayerNode = [SKNode node];
    [self addChild:_keyboardLayerNode];
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Myriad Pro"];
        
        myLabel.text = @"Key Jam";
        myLabel.fontSize = 65;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        [self addChild:myLabel];
        
        [self setupSceneLayers];
        [self setupHUD];
        
        keyboardNode = [[KJKeyboardNode alloc] initWithSize:CGSizeMake(self.size.width, 300)];
        keyboardNode.position = CGPointZero;
        keyboardNode.anchorPoint = CGPointZero;
        [[BMMidiManager sharedInstance] addListener:[KJKeyboardManager sharedManager]];
        [_keyboardLayerNode addChild:keyboardNode];
    }
    return self;
}

- (void)setupHUD
{
    // background
    int barHeight = 45;
    CGSize backgroundSize = CGSizeMake(self.size.width, barHeight);
    SKColor *backgroundColor = [SKColor colorWithRed:0 green:0 blue:0.05 alpha:1.0];
    SKSpriteNode *hudBarBackground = [SKSpriteNode spriteNodeWithColor:backgroundColor size:backgroundSize];
    hudBarBackground.position = CGPointMake(0, self.size.height - barHeight);
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
    
//    KJKeyModel *keyModel = [[KJKeyboardManager sharedManager] keyModelForNoteNumber:theEvent.keyCode];
//    [keyModel noteOn];
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
}

@end
