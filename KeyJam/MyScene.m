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

@implementation MyScene

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
        
        [self addKeys];
    }
    return self;
}

- (void)addKeys
{
    NSRange noteRange = [KJKeyboardManager sharedManager].noteRange;
    long keyCount = [KJKeyboardManager sharedManager].majorKeyCount;
    int keyWidth = self.size.width / (CGFloat)keyCount;
    int keyHeight = keyWidth * 2;
    CGFloat spaceBetweenKeys = 8.0;
    CGFloat keyRadius = 4.0;
    CGFloat majorX = 0;
    CGFloat minorX = keyWidth / 2.0;
    for (NSInteger i = noteRange.location; i < noteRange.length; i ++)
    {
        KJKeyModel *keyModel = [[KJKeyboardManager sharedManager] keyModelForNoteNumber:i];
        SKShapeNode *shape = [[SKShapeNode alloc] init];
        keyModel.shapeNode = shape;
        if (keyModel.isMajor)
        {
            shape.path = CGPathCreateWithRoundedRect(CGRectMake(majorX, 0, keyWidth - spaceBetweenKeys, keyHeight), keyRadius, 0, NULL);
            majorX += keyWidth;
            shape.fillColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        }
        else
        {
            shape.path = CGPathCreateWithRoundedRect(CGRectMake(minorX, keyHeight, keyWidth - spaceBetweenKeys, keyHeight), keyRadius, 0, NULL);
            minorX += keyWidth;
            if (keyModel.keyEnum == KJKeyModelKeyDSharp || keyModel.keyEnum == KJKeyModelKeyASharp) minorX += keyWidth;
            shape.fillColor = [SKColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        }
        [self addChild:shape];
    }
}

-(void)keyDown:(NSEvent *)theEvent
{
    NSLog(@"key code: %u", theEvent.keyCode);
    KJKeyModel *keyModel = [[KJKeyboardManager sharedManager] keyModelForNoteNumber:theEvent.keyCode];
    [keyModel noteOn];
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
}

@end
