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
@property (nonatomic, strong, readonly)NSArray *keyModels;
@property (nonatomic, assign, readonly) NSInteger majorKeyCount;
@property (nonatomic, assign, readwrite) NSRange noteRange;

// width of keys in UI, in points
@property (nonatomic, assign, readwrite) NSUInteger keyWidth;

+ (instancetype)sharedManager;
- (KJKeyModel*)keyModelForNoteNumber:(NSUInteger)noteNumber;

/**
 *  the x value (points) that ui elements should be for a given key model
 *
 *  @param keyModel key model to base the measurement from
 *
 *  @return x value to be used in a CGRect with anchorPoint CGPointZero
 */
- (CGFloat)xOffsetForKeyModel:(KJKeyModel*)keyModel;
@end