//
//  JWGCircleCounter.m
//  Version 0.2.0
//
//  https://github.com/johngraham262/JWGCircleCounter
//

#import "JWGCircleCounter.h"

#define JWG_SECONDS_ADJUSTMENT 1000
#define JWG_TIMER_INTERVAL .015 // ~60 FPS

@interface JWGCircleCounter()

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSDate *lastStartTime;

@property (assign, nonatomic) NSTimeInterval totalTime;

@property (assign, nonatomic) NSTimeInterval completedTimeUpToLastStop;
@property (assign, nonatomic) NSTimeInterval elapsedTime;

@end

@implementation JWGCircleCounter

#pragma mark - Public methods

- (void)baseInit {
    self.backgroundColor = [UIColor clearColor];

    self.circleColor = JWG_CIRCLE_COLOR_DEFAULT;
    self.circleBackgroundColor = JWG_CIRCLE_BACKGROUND_COLOR_DEFAULT;
    self.circleTimerWidth = JWG_CIRCLE_TIMER_WIDTH;

    self.completedTimeUpToLastStop = 0;
    self.elapsedTime = 0;
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

    [JWGCircleCounter validateInputTime:seconds];

    self.totalTime = seconds;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:JWG_TIMER_INTERVAL
                                                  target:self
                                                selector:@selector(timerFired)
                                                userInfo:nil
                                                 repeats:YES];

    _isRunning = YES;
    _didStart = YES;
    _didFinish = NO;

    self.lastStartTime = [NSDate dateWithTimeIntervalSinceNow:0];
    self.completedTimeUpToLastStop = 0;
    self.elapsedTime = 0;

    [self.timer fire];
}

- (void)timerFired {
    if (!_isRunning) {
        return;
    }

    self.elapsedTime = (self.completedTimeUpToLastStop +
                        [[NSDate date] timeIntervalSinceDate:self.lastStartTime]);

    // Check if timer has expired.
    if (self.elapsedTime > self.totalTime) {
        [self timerCompleted];
    }

    [self setNeedsDisplay];
}

- (void)resume {
    _isRunning = YES;
    NSDate *now = [NSDate dateWithTimeIntervalSinceNow:0];
    self.lastStartTime = now;
    [self.timer setFireDate:now];
}

- (void)stop {
    _isRunning = NO;

    self.completedTimeUpToLastStop += [[NSDate date] timeIntervalSinceDate:self.lastStartTime];
    self.elapsedTime = self.completedTimeUpToLastStop;

    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)reset {
    [self.timer invalidate];
    self.timer = nil;

    _isRunning = NO;
    _didStart = NO;
    _didFinish = NO;
}

#pragma mark - Private methods

+ (void)validateInputTime:(NSInteger)time {
    if (time < 1) {
        [NSException raise:@"JWGInvalidTime"
                    format:@"inputted timer length, %li, must be a positive integer", (long)time];
    }
}

- (void)timerCompleted {
    [self.timer invalidate];

    _isRunning = NO;
    _didFinish = YES;

    self.elapsedTime = self.totalTime;

    if ([self.delegate respondsToSelector:@selector(circleCounterTimeDidExpire:)]) {
        [self.delegate circleCounterTimeDidExpire:self];
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat radius = CGRectGetWidth(rect)/2.0f - self.circleTimerWidth/2.0f;
    CGFloat angleOffset = M_PI_2;

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
    CGFloat startAngle = (((CGFloat)self.elapsedTime) / (CGFloat)self.totalTime)*M_PI*2;

    if (!self.isRunning && !self.didStart && !self.didFinish) {
        // If the timer hasn't started yet, fill the whole circle. (startAngle will be NaN)
        startAngle = 0;
    }

    CGContextAddArc(context,
                    CGRectGetMidX(rect), CGRectGetMidY(rect),
                    radius,
                    startAngle - angleOffset,
                    2*M_PI - angleOffset,
                    0);
    CGContextSetStrokeColorWithColor(context, [self.circleColor CGColor]);
    CGContextStrokePath(context);
}

@end
