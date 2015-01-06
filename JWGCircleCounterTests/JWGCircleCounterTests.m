//
//  JWGCircleCounterTests.m
//  Version 0.2.1
//
//  https://github.com/johngraham262/JWGCircleCounter
//

#import <XCTest/XCTest.h>
#import "JWGCircleCounter.h"
#import "Expecta.h"

@interface JWGCircleCounterTests : XCTestCase <JWGCircleCounterDelegate>

@property (nonatomic, strong) JWGCircleCounter *circleCounter;
@property (nonatomic, assign) __block BOOL delegateCalled;

@end

@implementation JWGCircleCounterTests

- (void)setUp {
    [super setUp];
    self.circleCounter = [[JWGCircleCounter alloc] init];
}

- (void)tearDown {
    self.circleCounter = nil;
    [Expecta setAsynchronousTestTimeout:1];
    [super tearDown];
}

- (void)circleCounterTimeDidExpire:(JWGCircleCounter *)circleCounter {
    self.delegateCalled = YES;
}

- (void)testStartWithInvalidTimerLengthFails {
    EXP_expect(^{ [self.circleCounter startWithSeconds:0]; }).to.raise(@"JWGInvalidTime");
    EXP_expect(^{ [self.circleCounter startWithSeconds:-5]; }).to.raise(@"JWGInvalidTime");
}

- (void)testStartWithValidTimerLengthSucceeds {
    [self.circleCounter startWithSeconds:2];
    XCTAssertTrue(self.circleCounter.isRunning,
                  @"Circle counter started with lenght > 0 shouldn't be nil.");
}

- (void)testStartWorks {
    [self.circleCounter startWithSeconds:2];
    XCTAssertFalse(self.circleCounter.didFinish, @"Circle counter shouldn't have finished yet.");
    XCTAssertTrue(self.circleCounter.didStart,
                  @"Circle counter started should work.");
}

- (void)testStopPausesTimer {
    [self.circleCounter startWithSeconds:3];
    [self.circleCounter stop];
    XCTAssertFalse(self.circleCounter.isRunning,
                   @"Circle counter should not be running when stopped.");
    XCTAssertTrue(self.circleCounter.didStart,
                  @"Circle counter should still be marked as started.");
}

- (void)testElapsedTimeDuringStop {
    NSInteger timerLength = 3;
    XCTAssertEqual(self.circleCounter.elapsedTime, 0,
                  @"Circle counter elapsed time should be 0 before starting");
    [self.circleCounter startWithSeconds:timerLength];
    [self.circleCounter stop];
    XCTAssertTrue(self.circleCounter.elapsedTime > 0,
                  @"Circle counter elapsed time should be greater than 0");
    XCTAssertTrue(self.circleCounter.elapsedTime < timerLength,
                  @"Circle counter elapsed time should not be completed yet");
}

- (void)testResumeWorks {
    [self.circleCounter startWithSeconds:3];
    [self.circleCounter stop];
    [self.circleCounter resume];
    XCTAssertTrue(self.circleCounter.isRunning,
                  @"Circle counter should run after resumed.");
}

- (void)testMultipleResumesWork {
    [self.circleCounter startWithSeconds:3];
    [self.circleCounter resume];
    [self.circleCounter resume];
    [self.circleCounter resume];
    XCTAssertTrue(self.circleCounter.isRunning,
                  @"Circle counter should run properly on resumes.");
}

- (void)testTimerExpirationMarksCounterAsFinished {
    [Expecta setAsynchronousTestTimeout:3];
    [self.circleCounter startWithSeconds:1];

    EXP_expect(self.circleCounter.didFinish).will.beTruthy();
}

- (void)testTimerExpirationElapsedTime {
    [Expecta setAsynchronousTestTimeout:3];
        NSInteger timerLength = 1;
    self.circleCounter.delegate = self;
    [self.circleCounter startWithSeconds:timerLength];

    EXP_expect(self.circleCounter.elapsedTime == timerLength).will.beTruthy();
}

- (void)testTimerExpirationTriggersDelegate {
    [Expecta setAsynchronousTestTimeout:3];
    self.circleCounter.delegate = self;
    [self.circleCounter startWithSeconds:1];

    EXP_expect(self.delegateCalled).will.beTruthy();
    EXP_expect(self.circleCounter.didFinish).will.beTruthy();
}

- (void)testReset {
    [self.circleCounter startWithSeconds:3];
    [self.circleCounter reset];
    XCTAssertEqual(self.circleCounter.elapsedTime, 0,
                   @"Circle counter elapsed time should be 0 after reset.");
    XCTAssertFalse(self.circleCounter.didStart,
                   @"Circle counter should not have started after a reset.");
    XCTAssertFalse(self.circleCounter.isRunning,
                   @"Circle counter should not be running after a reset.");
    XCTAssertFalse(self.circleCounter.didFinish,
                   @"Circle counter should not be finished after a reset.");
}

- (void)testTimerLabelDisplaysCorrectly {
    [Expecta setAsynchronousTestTimeout:3];
    self.circleCounter.delegate = self;
    self.circleCounter.timerLabelHidden = NO;
    [self.circleCounter startWithSeconds:2];
    XCTAssertTrue([self.circleCounter.timerLabel.text isEqualToString:@"2"],
                   @"Circle timer label should display the start time on start.");
    
    EXP_expect(self.delegateCalled).will.beTruthy();
    XCTAssertTrue([self.circleCounter.timerLabel.text isEqualToString:@"0"],
                  @"Circle timer label should display 0 on finish." );
}

- (void)testTimerLabelHiddenYes {
    self.circleCounter.timerLabelHidden = YES;
    [self.circleCounter startWithSeconds:3];
    XCTAssertEqual(self.circleCounter.timerLabel.hidden, YES,
                   @"Circle timer label should be hidden.");
}

- (void)testTimerLabelHiddenNo {
    self.circleCounter.timerLabelHidden = NO;
    [self.circleCounter startWithSeconds:3];
    XCTAssertEqual(self.circleCounter.timerLabel.hidden, NO,
                   @"Circle timer label should not be hidden.");
}

@end
