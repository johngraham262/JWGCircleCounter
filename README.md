JWGCircleCounter [![Build Status](https://travis-ci.org/johngraham262/JWGCircleCounter.png?branch=master)](https://travis-ci.org/johngraham262/JWGCircleCounter)
=========

This control is a simple view that counts down a specified amount and alerts you on completion. You can see this live in [Teleportante].

![alt tag](https://raw.github.com/johngraham262/JWGCircleCounter/master/Screenshots/JWGCircleCounterDemo.gif)

Demo
---

This example uses [Cocoapods], please install before running.

Navigate to `DemoApp` and run `pod install` in your terminal. Open `DemoApp.xcworkspace` and run the application.

Installation
---

Easiest installation is through [Cocoapods]. Add the following line to your `Podfile`:
```sh
pod `JWGCircleCounter`
```
and run `pod install` in your terminal.

Alternatively, you can manually add the files in the `JWGCircleCounter` directory to your project.

Usage
--

Start by creating a `JWGCircleCounter` of your own and add it to your view:

```objective-c
JWGCircleCounter *circleCounter = [[JWGCircleCounter alloc] initWithFrame:CGRectMake(0,0,40,40)];
...
[your_view addSubview:circleCounter];
```

After initialization, start the counter by:
```objective-c
[circleCounter startWithSeconds:5];
```

Once it's been started, the counter can be managed with:
```objective-c
[circleCounter stop];
[circleCounter resume];
```

Customization & counter state
--
When the frame is set, the circle counter will expand to fit the bounds.

The following properties can be set:
```objective-c
@property (nonatomic, strong) UIColor *circleColor;
@property (nonatomic, strong) UIColor *circleBackgroundColor;
@property (nonatomic, assign) CGFloat circleTimerWidth;
```

You can inspect the state of a counter through a few `readonly` properties:
```objective-c
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

Shoutout
--

This was inspired by pppoe's [Circle-Counter-Down]. Thank you!

[Cocoapods]: http://cocoapods.org/
[Circle-Counter-Down]: https://github.com/pppoe/Circle-Counter-Down
[Teleportante]: http://bit.ly/Teleportante
