//
//  JWGCircleCounter.m
//
//  https://github.com/johngraham262/JWGCircleCounter
//

#import "JWGCircleCounter.h"

#define JWG_SECONDS_ADJUSTMENT 1000
#define JWG_NUM_TIME_INTERVALS 400.0f

#define JWG_CIRCLE_COLOR_DEFAULT [UIColor colorWithRed:239/255.0f green:101/255.0f blue:48/255.0f alpha:1]
#define JWG_CIRCLE_BACKGROUND_COLOR_DEFAULT [UIColor colorWithWhite:.85f alpha:1]
#define JWG_CIRCLE_TIMER_WIDTH 8.0f

@interface JWGCircleCounter() {
    NSUInteger numAdjustedSecondsCompleted;
    NSUInteger numAdjustedSecondsCompletedIncrementor;
    NSUInteger numAdjustedSecondsTotal;
    NSUInteger numSeconds;
    CGFloat timerInterval;
}
@end

@implementation JWGCircleCounter

#pragma mark - Public methods

- (void)baseInit {
    self.backgroundColor = [UIColor clearColor];

    self.circleColor = JWG_CIRCLE_COLOR_DEFAULT;
    self.circleBackgroundColor = JWG_CIRCLE_BACKGROUND_COLOR_DEFAULT;
    self.circleTimerWidth = JWG_CIRCLE_TIMER_WIDTH;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self baseInit];
    }

    return self;
}

- (void)startWithSeconds:(NSInteger)seconds {
    if (seconds < 1) {
        return;
    }

    if (self.didStart && !self.didFinish) {
        return;
    }

    numSeconds = seconds;
    numAdjustedSecondsCompleted = 0;
    numAdjustedSecondsCompletedIncrementor = seconds;
    numAdjustedSecondsTotal = seconds * JWG_SECONDS_ADJUSTMENT;
    timerInterval = (CGFloat)numSeconds / JWG_NUM_TIME_INTERVALS;

    _didStart = YES;
    _didFinish = NO;
    [self resume];
}

- (void)resume {
    if (!self.didStart || self.isRunning) {
        return;
    }

    _isRunning = YES;
    [self update];
}

- (void)stop {
    _isRunning = NO;
}

#pragma mark - Private methods

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    float radius = CGRectGetWidth(rect)/2.0f - self.circleTimerWidth/2.0f;
    float angleOffset = M_PI_2;

    // Draw the background of the circle.
    CGContextSetLineWidth(context, self.circleTimerWidth);
    CGContextBeginPath(context);
    CGContextAddArc(context,
                    CGRectGetMidX(rect), CGRectGetMidY(rect),
                    radius,
                    0,
                    2*M_PI,
                    0);
    CGContextSetStrokeColorWithColor(context, [self.circleBackgroundColor CGColor]);
    CGContextStrokePath(context);

    // Draw the remaining amount of timer circle.
    CGContextSetLineWidth(context, self.circleTimerWidth);
    CGContextBeginPath(context);
    CGFloat startAngle = (((CGFloat)numAdjustedSecondsCompleted + 1.0f) /
                          ((CGFloat)numAdjustedSecondsTotal)*M_PI*2 - angleOffset);
    CGFloat endAngle = 2*M_PI - angleOffset;
    CGContextAddArc(context,
                    CGRectGetMidX(rect), CGRectGetMidY(rect),
                    radius,
                    startAngle,
                    endAngle,
                    0);
    CGContextSetStrokeColorWithColor(context, [self.circleColor CGColor]);
    CGContextStrokePath(context);
}

- (void)update {
    if (self.isRunning) {
        numAdjustedSecondsCompleted += numAdjustedSecondsTotal / (numSeconds / timerInterval);
        if (numAdjustedSecondsCompleted >= numAdjustedSecondsTotal) {
            // finished
            numAdjustedSecondsCompleted = numAdjustedSecondsTotal - 1;
            [self stop];
            // alert delegate method that it finished
            if ([self.delegate respondsToSelector:@selector(circleCounterTimeDidExpire:)]) {
                _didFinish = YES;
                [self.delegate circleCounterTimeDidExpire:self];
            }
        } else {
            // in progress
            [NSTimer scheduledTimerWithTimeInterval:timerInterval
                                             target:self
                                           selector:@selector(update)
                                           userInfo:nil
                                            repeats:NO];
        }
        [self setNeedsDisplay];
    }
}

@end
