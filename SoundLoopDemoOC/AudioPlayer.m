//
//  AudioPlayer.m
//  SoundLoopDemoOC
//
//  Created by DP Bhatt on 01/05/2018.
//  Copyright © 2018 Sensus ApS. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "AudioPlayer.h"

@implementation AudioPlayer
{
    NSArray *audioPlayers;
    AVAudioEngine *engine;
    AVAudioPlayerNode *player;
    NSArray *audioFiles;
    AVAudioUnitTimePitch *avAudioPlayerTimePitch;
    NSArray *audioFileNames;
}

@synthesize activePlayerIndex,pitch, rate, volume;

- (instancetype)init
{
    self = [super init];
    if (self) {
        pitch = -2400;
        rate = 1.0;
        volume = 100.0;
        activePlayerIndex = -1;
        
        audioFileNames = [NSArray arrayWithObjects:@"bell_multiple", @"buzzer_x", @"Beep",@"flatline", nil];
        engine = [[AVAudioEngine alloc] init];
        avAudioPlayerTimePitch = [[AVAudioUnitTimePitch alloc] init];
        
        [self createAudioFiles];
        [self createPlayers];
        
        [engine prepare];
        [engine startAndReturnError:nil];
    }
    return self;
}

/*
 -(void) setAudioPlayerPitch:(float) pitch rate: (float) rate{
 //[[audioPlayers objectAtIndex: _currentPlayer] pause];
 [avAudioPlayerTimePitch setPitch:pitch];
 [avAudioPlayerTimePitch setRate:rate];
 //[(AVAudioPlayerNode*)[audioPlayers objectAtIndex: _currentPlayer] play];
 }
 
 -(void) setAudioPlayerPitch:(float) pitch rate: (float) rate volume:(float) volume{
 //[[audioPlayers objectAtIndex: _currentPlayer] pause];
 [avAudioPlayerTimePitch setPitch:pitch];
 [avAudioPlayerTimePitch setRate:rate];
 [[audioPlayers objectAtIndex: _currentPlayer] setVolume: volume];
 //[(AVAudioPlayerNode*)[audioPlayers objectAtIndex: _currentPlayer] play];
 }
 
 -(void) setVolume:(float) tag{
 //[[audioPlayers objectAtIndex: _currentPlayer] pause];
 [[audioPlayers objectAtIndex: _currentPlayer] setVolume:tag];
 //[(AVAudioPlayerNode*)[audioPlayers objectAtIndex: _currentPlayer] play];
 }
 */
-(void) stopAudio: (NSInteger) tag{
    if([audioPlayers[tag] isPlaying]){
        [audioPlayers[tag] pause];
        [self setActivePlayerIndex: -1];
    }
}

-(void) stopAllPlayer {
    for (AVAudioPlayerNode *player in audioPlayers) {
        if([player isPlaying]){
            [player pause];
        }
    }
}

-(void) createAudioFiles{
    NSMutableArray *buffer = [NSMutableArray array];
    
    for (int i = 0; i < [audioFileNames count]; i++) {
        NSString *audioPath = [[NSBundle mainBundle] pathForResource:audioFileNames[i] ofType:@"wav"];
        NSURL *url = [NSURL fileURLWithPath:audioPath];
        AVAudioFile *file = [[AVAudioFile alloc] initForReading:url error:nil];
        [buffer addObject:file];
    }
    
    audioFiles = [buffer copy];
}

-(void) playAudio: (NSInteger) tag{
    if(tag >= 0){
        NSLog(@"Ring");
        [self stopAllPlayer];
        [self setActivePlayerIndex:tag];
        
        AVAudioPlayerNode *player = audioPlayers[tag];
        AVAudioFile *audioFile = audioFiles[tag];
        
        [player setVolume:[self volume]];
        
        if (tag == 0 || tag == 1) {
            [player scheduleFile:audioFile atTime:nil completionHandler:nil];
        } else if(tag == 2){
            
            [avAudioPlayerTimePitch setRate: [self rate]];
            [avAudioPlayerTimePitch setPitch: [self pitch]];
            AVAudioPCMBuffer *buffer =  [[AVAudioPCMBuffer alloc] initWithPCMFormat:audioFile.processingFormat frameCapacity:(AVAudioFrameCount)[audioFile length]];
            [audioFile readIntoBuffer:buffer error:nil];
            [player scheduleBuffer:buffer atTime:nil options:AVAudioPlayerNodeBufferLoops completionHandler:nil];
            
        } else if (tag == 3){
            AVAudioPCMBuffer *buffer = [[AVAudioPCMBuffer alloc] initWithPCMFormat:[audioFile processingFormat] frameCapacity:(AVAudioFrameCount)[audioFile length]];
            [audioFile readIntoBuffer:buffer error:nil];
            [player scheduleBuffer:buffer atTime:nil options:AVAudioPlayerNodeBufferLoops completionHandler:nil];
        }
        [player play];
    }
}

-(void) createPlayers{
    NSMutableArray *bufferArray = [NSMutableArray array];
    for (NSString *key in audioFileNames){
        player = [[AVAudioPlayerNode alloc] init];
        // Cant't believe on documentation
        [player setVolume:[self volume]];
        
        NSString *audioPath = [[NSBundle mainBundle] pathForResource:key ofType:@"wav"];
        NSURL *url = [NSURL fileURLWithPath:audioPath];
        //Error handling
        AVAudioFile *file = [[AVAudioFile alloc] initForReading:url error:nil];
        [engine attachNode:player];
        
        if([key isEqualToString: @"bell_multiple"] || [key isEqualToString: @"buzzer_x"]){
            [engine connect:player to:[engine mainMixerNode] format:[file processingFormat]];
            [player scheduleFile:file atTime:nil completionHandler:nil];
        } else if([key isEqualToString:@"flatline"]){
            AVAudioPCMBuffer *buffer = [[AVAudioPCMBuffer alloc] initWithPCMFormat:[file processingFormat] frameCapacity: (AVAudioFrameCount)[file length]];
            [file readIntoBuffer:buffer error:nil];
            [engine connect:player to:[engine mainMixerNode] format: file.processingFormat];
            [player scheduleBuffer:buffer atTime:nil options:AVAudioPlayerNodeBufferLoops completionHandler:nil];
        } else if ([key isEqualToString: @"Beep"]){
            [avAudioPlayerTimePitch setRate:[self rate]];
            [avAudioPlayerTimePitch setPitch:[self pitch]];
            
            AVAudioPCMBuffer *buffer =  [[AVAudioPCMBuffer alloc] initWithPCMFormat:[file processingFormat] frameCapacity:(AVAudioFrameCount)[file length]];
            [file readIntoBuffer:buffer error:nil];
            
            [engine attachNode:avAudioPlayerTimePitch];
            [engine connect:player to:avAudioPlayerTimePitch format:file.processingFormat];
            [engine connect:avAudioPlayerTimePitch to:engine.mainMixerNode format:file.processingFormat];
            [player scheduleBuffer:buffer atTime:nil options:AVAudioPlayerNodeBufferLoops completionHandler:nil];
        }
        [bufferArray addObject:player];
    }
    audioPlayers = [bufferArray copy];
}
@end
