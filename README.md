JWGCircleCounter
=========

This control is a simple view that counts down a specified amount and alerts you on completion.

** gif coming soon **

Demo
---

This example uses [Cocoapods], please install before running.

Navigate to `DemoApp` and run `pod install` in your terminal. Open `DemoApp.xcworkspace` and run the application.

Installation
---

[PENDING] Easiest installation is through [Cocoapods]. Add the following line to your `Podfile`:
```sh
pod `JWGCircleCounter`
```
and run `pod install` in your terminal.

Alternatively, you can manually add the files in the `JWGCircleCounter` directory to your project.

Usage
--

Start by creating a `JWGCircleCounter` of your own:

```ios
JWGCircleCounter *circleCounter = [[JWGCircleCounter alloc] init];
```

After initialization, start the counter by:
```ios
- (void)startWithSeconds:(NSInteger)seconds;
```

Once it's been started, the counter can be managed with:
```ios
- (void)resume;
- (void)stop;
```

Customization & counter state
--
When the frame is set, the circle counter will expand to fit the bounds.

The following properties can be set:
```ios
@property (nonatomic, strong) UIColor *circleColor;
@property (nonatomic, strong) UIColor *circleBackgroundColor;
@property (nonatomic, assign) CGFloat circleTimerWidth;
```

You can inspect the state of a counter through a few `readonly` properties:
```ios
@property (nonatomic, assign, readonly) BOOL didStart;
@property (nonatomic, assign, readonly) BOOL isRunning;
@property (nonatomic, assign, readonly) BOOL didFinish;
```

Contributing
--

Please write tests and ensure that existing tests pass too. Open a pull request when you're ready.

Roadmap
--
1. Move `didStart`, `isRunning`, and `didFinish` properties to an enum.
2. Create a single "smart" method that can do start/pause/restart.
3. A circle counter that hasn't been started yet shows a full circle, instead of an empty one.

Shoutout
--

This was inspired by pppoe's [Circle-Counter-Down]. Thank you!

[Cocoapods]: http://cocoapods.org/
[Circle-Counter-Down]: https://github.com/pppoe/Circle-Counter-Down

