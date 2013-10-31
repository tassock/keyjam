//
//  KJHudNode.h
//  KeyJam
//
//  Created by Peter Marks on 10/31/13.
//  Copyright (c) 2013 Peter Marks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KJHudNode : SKSpriteNode

- (id)initWithSize:(CGSize)size;
- (void)updateToBeat:(CGFloat)currentBeatFloat;

@end
