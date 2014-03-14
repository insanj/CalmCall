#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

#define CC_LENIENCY 0.1

// Used to compare the expectant StatusBar color with our favorite neon green color
// (should prevent coloration of bars that /aren't/ the in-call, e.g. iOS 6 apps)
BOOL cc_colorAndComponentsClose(UIColor *color, CGFloat r, CGFloat g, CGFloat b, CGFloat a) {
    const CGFloat *components = CGColorGetComponents([color CGColor]);
    if (!components)
        return NO;

    BOOL redClose = fabs(r-components[0]) < CC_LENIENCY;
    BOOL greenClose = fabs(g-components[1]) < CC_LENIENCY;
    BOOL blueClose = fabs(b-components[2]) < CC_LENIENCY;
    BOOL alphaClose = fabs(a-components[3]) < CC_LENIENCY;

    return redClose && greenClose && blueClose && alphaClose;
}

%hook UIStatusBarBackgroundView

// When in-call...
// -[<UIStatusBarBackgroundView: 0x1783a2a00> initWithFrame:{{0, 0}, {320, 20}} style:<UIStatusBarNewUIDoubleHeightStyleAttributes: 0x1706495a0> backgroundColor:UIDeviceRGBColorSpace 0.0862745 0.94902 0.0862745 1]

- (id)initWithFrame:(CGRect)arg1 style:(id)arg2 backgroundColor:(id)arg3 {
    if(cc_colorAndComponentsClose(arg3, 0.0862745, 0.94902, 0.0862745, 1)) {
        NSLog(@"[CalmCall] Detected in-call bar (with color %@), de-neonifying...", arg3);
        return %orig(arg1, arg2, [UIColor colorWithRed:46/255.0 green:204/255.0 blue:64/255.0 alpha:1.0]);
    }

    return %orig();
}

%end
