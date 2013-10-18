//
//  AppDelegate.m
//  KeyJam
//
//  Created by Peter Marks on 9/9/13.
//  Copyright (c) 2013 Peter Marks. All rights reserved.
//

#import "AppDelegate.h"
#import "MyScene.h"
#import "KJKeyboardManager.h"
#import "KJAudioManager.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[KJAudioManager sharedManager] setUp];
    
    // Set up keyboard manager with 25 note keyboard
    [[KJKeyboardManager sharedManager] setNoteRange:NSMakeRange(0, 25)];
    
    /* Pick a size for the scene */
    SKScene *scene = [MyScene sceneWithSize:CGSizeMake(1024, 768)];

    /* Set the scale mode to scale to fit the window */
    scene.scaleMode = SKSceneScaleModeAspectFit;

    [self.skView presentScene:scene];

    self.skView.showsFPS = YES;
    self.skView.showsNodeCount = YES;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end
