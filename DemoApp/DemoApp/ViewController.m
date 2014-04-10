//
//  ViewController.m
//  DemoApp
//
//  Created by John Graham on 4/2/14.
//  Copyright (c) 2014 johngraham262. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.circleCounter.delegate = self;
    self.resetButton.enabled = NO;
}

- (IBAction)startButtonAction:(id)sender {
    if (![self.circleCounter didStart] || [self.circleCounter didFinish]) {
        [self.circleCounter startWithSeconds:3];
        [self.startButton setTitle:@"Pause" forState:UIControlStateNormal];
        self.resetButton.enabled = YES;
    }
    else if ([self.circleCounter isRunning]) {
        [self.circleCounter stop];
        [self.startButton setTitle:@"Resume" forState:UIControlStateNormal];
    }
    else {
        [self.circleCounter resume];
        [self.startButton setTitle:@"Pause" forState:UIControlStateNormal];
    }
}

- (IBAction)resetButtonAction:(id)sender {
    [self.circleCounter reset];
    self.resetButton.enabled = NO;
    [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
}

- (void)circleCounterTimeDidExpire:(JWGCircleCounter *)circleCounter {
    [self.startButton setTitle:@"Restart" forState:UIControlStateNormal];

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Timer Expired"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

@end
