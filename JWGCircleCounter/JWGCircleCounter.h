//
//  JWGCircleCounter.h
//
//  https://github.com/johngraham262/JWGCircleCounter
//

#import <UIKit/UIKit.h>

@protocol JWGCircleCounterDelegate;

@interface JWGCircleCounter : UIView

@property (nonatomic, strong) id<JWGCircleCounterDelegate> delegate;

@property (nonatomic, strong) UIColor *circleColor;
@property (nonatomic, strong) UIColor *circleBackgroundColor;
@property (nonatomic, assign) CGFloat circleTimerWidth;

@property (nonatomic, assign, readonly) BOOL didStart;
@property (nonatomic, assign, readonly) BOOL isRunning;
@property (nonatomic, assign, readonly) BOOL didFinish;

- (void)startWithSeconds:(NSInteger)seconds;
- (void)resume;
- (void)stop;

@end

@protocol JWGCircleCounterDelegate <NSObject>

@optional
- (void)circleCounterTimeDidExpire:(JWGCircleCounter *)circleCounter;

@end
