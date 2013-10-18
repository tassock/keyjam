//
//  KJKeyboardManager.h
//  KeyJam
//
//  Created by Peter Marks on 9/10/13.
//  Copyright (c) 2013 Peter Marks. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KJKeyModel;

@interface KJKeyboardManager : NSObject
@property (nonatomic) NSArray *keyModels;
@property (nonatomic, readonly) NSInteger majorKeyCount;
@property (nonatomic, assign) NSRange noteRange;
+ (instancetype)sharedManager;
- (KJKeyModel*)keyModelForNoteNumber:(NSInteger)noteNumber;
- (void)noteOn:(NSInteger)noteNumber;
- (void)noteOff:(NSInteger)noteNumber;
@end
