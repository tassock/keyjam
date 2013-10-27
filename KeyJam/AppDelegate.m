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

#import "BMAudio.h"
#import "BMAudioTrack.h"
#import "BMSamplerUnit.h"
#import "BMReverbUnit.h"
#import "BMDistortionUnit.h"
#import "BMMidiManager.h"
#import "BMMusicPlayer.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self setUpBMAudio];
    
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

- (void)setUpBMAudio
{
    // Insert code here to initialize your application
    BMSamplerUnit *sampler1 = [BMSamplerUnit unit];
    BMReverbUnit *reverbUnit = [BMReverbUnit unit];
    BMAudioTrack *tromboneTrack = [BMAudioTrack trackWithUnits:@[sampler1, reverbUnit]];
    [[BMAudio sharedInstance] loadAudioTrack:tromboneTrack];
    
    BMSamplerUnit *sampler2 = [BMSamplerUnit unit];
    BMDistortionUnit *distortionUnit = [BMDistortionUnit unit];
    BMAudioTrack *tromboneTrack2 = [BMAudioTrack trackWithUnits:@[sampler2, distortionUnit]];
    [[BMAudio sharedInstance] loadAudioTrack:tromboneTrack2];
    
    [[BMAudio sharedInstance] setUpAudioGraph];
    
    [sampler1 loadPreset:@"Trombone"];
    [sampler2 loadPreset:@"Trombone"];
    
    [[BMMidiManager sharedInstance] setUp];
    [BMMidiManager sharedInstance].instrumentDelegate = sampler2;
    
    BMMusicPlayer *musicPlayer = [BMMusicPlayer sharedInstance];
    [musicPlayer loadSequenceFromMidiFile:@"CarntSleepBassline"];
    musicPlayer.currentTempo = 70.0;
    [musicPlayer noteEventsOnOrAfterBeat:0 beforeBeat:32];
}

@end
