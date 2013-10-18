//
//  KJAudioManager.h
//  KeyJam
//
//  Created by Peter Marks on 9/15/13.
//  Copyright (c) 2013 Peter Marks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KJAudioManager : NSObject
+ (instancetype)sharedManager;
- (void)setUp;
@end
