//
//  JWGCircleCounterTests.m
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
    [self.circleCounter startWithSeconds:0];
    XCTAssertFalse(self.circleCounter.isRunning,
                   @"Circle counter started with length < 1 should be nil.");
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

- (void)testTimerExpirationTriggersDelegate {
    [Expecta setAsynchronousTestTimeout:3];
    self.circleCounter.delegate = self;
    [self.circleCounter startWithSeconds:1];

    EXP_expect(self.delegateCalled).will.beTruthy();
    EXP_expect(self.circleCounter.didFinish).will.beTruthy();
}

@end
