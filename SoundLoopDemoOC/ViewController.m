//
//  ViewController.m
//  SoundLoopDemoOC
//
//  Created by DP Bhatt on 01/05/2018.
//  Copyright © 2018 XYZ. All rights reserved.
//
#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISlider *pitchSlider;
@property (weak, nonatomic) IBOutlet UISlider *rateSlider;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
@property (weak, nonatomic) IBOutlet UILabel *pitchLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;

@end

@implementation ViewController
{
    float step;
}
@synthesize player;
@synthesize pitchSlider, rateSlider, volumeSlider;
@synthesize pitchLabel, rateLabel, volumeLabel;

- (IBAction)pitchSlider:(UISlider *)sender {
    float roundedValue = round(sender.value/step) * step;
    sender.value = roundedValue;
    [self setLabels];
    
    [player setPitch:pitchSlider.value];
    [player playAudio: [player activePlayerIndex]];
}
- (IBAction)rateSlider:(UISlider *)sender {
    float roundedValue = round(sender.value/step) * step;
    sender.value = roundedValue;
    [self setLabels];
    [player setRate:rateSlider.value];
    [player playAudio: [player activePlayerIndex]];
}

- (IBAction)volumeSlider:(UISlider *)sender {
    
    float roundedValue = round(sender.value/step) * step;
    sender.value = roundedValue;
    [self setLabels];
    
    [player setVolume:volumeSlider.value];
    [player playAudio: [player activePlayerIndex]];
}

- (IBAction)playSound:(UIButton *)sender {
    if([sender tag] == 0){
        [player playAudio: 0];
    } else if ([sender tag] == 1){
        [player playAudio:1];
    } else if ([sender tag] == 2){
        [player playAudio:2];
    } else if([sender tag] == 3){
        [player playAudio:3];
    }
}
- (IBAction)stopSound:(UIButton *)sender {
    [player stopAudio: (int) [sender tag]];
}

-(void) setLabels{
    [pitchLabel setText: [NSString stringWithFormat:@"%.2f", pitchSlider.value]];
    [rateLabel setText:[NSString stringWithFormat:@"%.2f", rateSlider.value]];
    [volumeLabel setText:[NSString stringWithFormat:@"%.2f", volumeSlider.value]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    step = 1.0;
    [self setLabels];
    player = [[AudioPlayer alloc] init];
}
@end
