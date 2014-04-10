#import <UIKit/UIKit.h>

#define CC_LENIENCY 0.1
#define PERSONAL_COLOR [UIColor colorWithRed:46/255.0 green:204/255.0 blue:64/255.0 alpha:1.0]
#define IVE_COLOR [UIColor colorWithRed:76/255.0 green:217/255.0 blue:100/255.0 alpha:1.0]
#define NEON_COLOR [UIColor colorWithRed:0.0862745 green:0.94902 blue:0.0862745 alpha:1]

@interface UIColor (Private)
- (BOOL)_isSimilarToColor:(UIColor *)color withinPercentage:(CGFloat)percentage;
@end


%hook UIStatusBarBackgroundView

// When in-call...
// -[<UIStatusBarBackgroundView: 0x1783a2a00> initWithFrame:{{0, 0}, {320, 20}} style:<UIStatusBarNewUIDoubleHeightStyleAttributes: 0x1706495a0> backgroundColor:UIDeviceRGBColorSpace 0.0862745 0.94902 0.0862745 1]

- (id)initWithFrame:(CGRect)arg1 style:(id)arg2 backgroundColor:(UIColor *)arg3 {
    if ([arg3 _isSimilarToColor:NEON_COLOR withinPercentage:CC_LENIENCY]) {
        NSLog(@"[CalmCall] Detected in-call bar (with color %@), de-neonifying...", arg3);
        return %orig(arg1, arg2, IVE_COLOR);
    }

    return %orig();
}

%end
