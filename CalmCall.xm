#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

%hook UIStatusBarBackgroundView

// When In-Call...
// -[<UIStatusBarBackgroundView: 0x1783a2a00> initWithFrame:{{0, 0}, {320, 20}} style:<UIStatusBarNewUIDoubleHeightStyleAttributes: 0x1706495a0> backgroundColor:UIDeviceRGBColorSpace 0.0862745 0.94902 0.0862745 1]

- (id)initWithFrame:(CGRect)arg1 style:(id)arg2 backgroundColor:(id)arg3 {
    const CGFloat *components = CGColorGetComponents([arg3 CGColor]);
    if(components && components[1] > 0.9) {
        NSLog(@"[CalmCall] Detected in-call bar (with color %@), de-neonifing...", arg3);
        return %orig(arg1, arg2, [UIColor colorWithRed:46/255.0 green:204/255.0 blue:64/255.0 alpha:1.0]);
    }

    return %orig();
}

%end
