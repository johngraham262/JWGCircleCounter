//
//  JWGCircleCounter.h
//  Version 0.2.2
//
//  https://github.com/johngraham262/JWGCircleCounter
//

#import <UIKit/UIKit.h>

// Defaults
#define JWG_CIRCLE_COLOR_DEFAULT [UIColor colorWithRed:239/255.0f green:101/255.0f blue:48/255.0f alpha:1]
#define JWG_CIRCLE_BACKGROUND_COLOR_DEFAULT [UIColor colorWithWhite:.85f alpha:1]
#define JWG_CIRCLE_FILL_COLOR_DEFAULT [UIColor clearColor]
#define JWG_CIRCLE_TIMER_WIDTH 8.0f

@protocol JWGCircleCounterDelegate;

@interface JWGCircleCounter : UIView

/// The receiver of all counter delegate callbacks.
@property (nonatomic, weak) id<JWGCircleCounterDelegate> delegate;

/// The color of the circle indicating the remaining amount of time - default is JWG_CIRCLE_COLOR_DEFAULT.
@property (nonatomic, strong) UIColor *circleColor;

/// The color of the circle indicating the expired amount of time - default is JWG_CIRCLE_BACKGROUND_COLOR_DEFAULT.
@property (nonatomic, strong) UIColor *circleBackgroundColor;

/// The color of inside of the circle - default is JWG_CIRCLE_FILL_COLOR_DEFAULT.
@property (nonatomic, strong) UIColor *circleFillColor;

/// The thickness of the circle color - default is JWG_CIRCLE_TIMER_WIDTH.
@property (nonatomic, assign) CGFloat circleTimerWidth;

/// Indicates if the circle counter did start the countdown and animation.
@property (nonatomic, assign, readonly) BOOL didStart;

/// Indicates if the circle counter is currently counting down and animating.
@property (nonatomic, assign, readonly) BOOL isRunning;

/// Indicates if the circle counter finishing counting down and animating.
@property (nonatomic, assign, readonly) BOOL didFinish;

/// The amount of time that the timer has completed. It takes into account any stops/resumes
/// and is updated in real time.
@property (assign, nonatomic, readonly) NSTimeInterval elapsedTime;

/// Label that shows remaining time in the middle of the circle. It can be styled
/// using textColor and font properties of UILabel.
@property (nonatomic, strong, readonly) UILabel *timerLabel;

/// Hides or shows timeLabel - default is YES.
@property (nonatomic, assign) BOOL timerLabelHidden;

/// Hides timeLabel when time is expired - default is YES.
@property (nonatomic, assign) BOOL hidesTimerLabelWhenFinished;


/**
 * Begins the count down and starts the animation. This has no effect if the counter
 * isRunning. If a counter didFinish, you may restart it again by calling this method.
 *
 * @param seconds the length of the countdown timer
 */
- (void)startWithSeconds:(NSInteger)seconds;

/**
 * Pauses the countdown timer and stops animation. This only has an effect if the
 * counter isRunning.
 */
- (void)stop;

/**
 * Continues the countdown timer and resumes animation. This only has an effect if the
 * counter is not running.
 */
- (void)resume;

/**
 * Stops the counter and pauses animation as if it were at the initial, pre-started, state.
 * After reset is called, didStart, isRunning, and didFinish will all be NO.
 * You may start the timer again with startWithSeconds:.
 */
- (void)reset;

@end


@protocol JWGCircleCounterDelegate <NSObject>

/**
 * Alerts the delegate when the timer expires. At this point, counter animation is completed too.
 *
 * @param circleCounter the counter that just expired in time
 */
@optional
- (void)circleCounterTimeDidExpire:(JWGCircleCounter *)circleCounter;

@end
