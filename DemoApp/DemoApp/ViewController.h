//
//  ViewController.h
//  DemoApp
//
//  Created by John Graham on 4/2/14.
//  Copyright (c) 2014 johngraham262. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JWGCircleCounter.h"

@interface ViewController : UIViewController <JWGCircleCounterDelegate>

@property (strong, nonatomic) IBOutlet JWGCircleCounter *circleCounter;
@property (strong, nonatomic) IBOutlet UILabel *secondsLabel;

@end
