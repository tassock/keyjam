//
//  KJKeyModel.h
//  KeyJam
//
//  Created by Peter Marks on 9/10/13.
//  Copyright (c) 2013 Peter Marks. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    KJKeyModelKeyC,
    KJKeyModelKeyCSharp,
    KJKeyModelKeyD,
    KJKeyModelKeyDSharp,
    KJKeyModelKeyE,
    KJKeyModelKeyF,
    KJKeyModelKeyFSharp,
    KJKeyModelKeyG,
    KJKeyModelKeyGSharp,
    KJKeyModelKeyA,
    KJKeyModelKeyASharp,
    KJKeyModelKeyB
} KJKeyModelKey;

@interface KJKeyModel : NSObject
@property (nonatomic, readonly) KJKeyModelKey keyEnum;
@property (nonatomic, readonly) BOOL isMajor;
@property NSInteger noteNumber;
@property SKShapeNode *shapeNode;
- (void)noteOn;
- (void)noteOff;
+ (instancetype)keyModelWithNoteNumber:(NSUInteger)noteNumber;
@end
