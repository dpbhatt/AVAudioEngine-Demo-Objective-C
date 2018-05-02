//
//  AudioPlayer.h
//  SoundLoopDemoOC
//
//  Created by DP Bhatt on 01/05/2018.
//  Copyright © 2018 Sensus ApS. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface AudioPlayer: NSObject

@property NSInteger activePlayerIndex;
@property float pitch;
@property float rate;
@property float volume;

/*
 Tag values
 0 - Enter Region - bell_multiple.wav
 1 - Exit Region  - buzzer_x.wav
 2 - Progress     - Beep.wav
 3 - Immediate    - flatline.wav
 */

-(void) playAudio: (NSInteger) tag;
-(void) stopAudio: (NSInteger) tag;
/*
-(void) setVolume: (float) tag;
-(void) setAudioPlayerPitch:(float) pitch rate: (float) rate;
-(void) setAudioPlayerPitch:(float) pitch rate: (float) rate volume:(float) volume;
*/
@end
