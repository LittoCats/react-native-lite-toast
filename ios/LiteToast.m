//
//  RNToast.m
//  RNToast
//
//  Created by 程巍巍 on 19/04/2017.
//  Copyright © 2017 程巍巍. All rights reserved.
//

#import "LiteToast.h"

@implementation RNToast

RCT_EXPORT_MODULE(ToastIOS)

RCT_REMAP_METHOD(showWithGravity, toast:(NSString*)msg withDuration:(NSInteger)duration gravity:(NSInteger)gravity)
{
    [self.class make:msg withDuration:duration gravity:gravity];
}

- (NSDictionary<NSString *, id> *)constantsToExport
{
    NSMutableDictionary* constants = [NSMutableDictionary new];
    constants[@"LONG"] = @(self.class.LONG);
    constants[@"SHORT"] = @(self.class.SHORT);
    constants[@"TOP"] = @(self.class.TOP);
    constants[@"CENTER"] = @(self.class.CENTER);
    constants[@"BOTTOM"] = @(self.class.BOTTOM);

    return constants;
}

+ (void)make:(NSString *)msg withDuration:(NSTimeInterval)duration gravity:(NSInteger)gravity
{
    if (!msg || !msg.length || !duration) return;
    duration = duration == self.LONG ? duration : self.SHORT;
    gravity = gravity == self.TOP || gravity == self.CENTER ? gravity : self.BOTTOM;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        makeText(msg, duration, gravity);
    });
}

+ (NSTimeInterval)LONG { return 3000; }
+ (NSTimeInterval)SHORT { return 2000; }
+ (NSInteger)TOP { return 1; }
+ (NSInteger)CENTER { return 2; }
+ (NSInteger)BOTTOM { return 3; }

static void makeText(NSString* message, NSTimeInterval duration, NSInteger gravity)
{
    static UIView* toast;
    static UILabel* label;
    static NSUInteger flag = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        toast = [UIView new];
        label = [UILabel new];
        
        toast.layer.cornerRadius = 5;
        toast.layer.shadowOpacity = 0.7;
        toast.layer.shadowRadius = 1.5;
        toast.layer.shadowOffset = CGSizeMake(1, 1);
        
        label.numberOfLines = 0;
        label.font = [label.font fontWithSize:13];
        label.textColor = UIColor.whiteColor;
        
        toast.translatesAutoresizingMaskIntoConstraints = label.translatesAutoresizingMaskIntoConstraints = NO;
        toast.backgroundColor = label.backgroundColor = UIColor.blackColor;
        toast.opaque = label.opaque = YES;
        
        [toast addSubview:label];
        [toast addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[label]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];
        [toast addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-7-[label]-7-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];
    });
    
    [toast removeFromSuperview];
    
    label.text = message;
    
    UIWindow* window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:toast];
    
    [window addConstraint:[NSLayoutConstraint constraintWithItem:toast attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:window attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [window addConstraint:[NSLayoutConstraint constraintWithItem:toast attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:window attribute:NSLayoutAttributeCenterY multiplier:0.5*gravity constant:0]];
    
    NSUInteger mFlag = ++flag;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
        if (mFlag == flag) [toast removeFromSuperview];
    });
}
@end
