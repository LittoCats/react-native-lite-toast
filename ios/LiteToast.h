//
//  RNToast.h
//  RNToast
//
//  Created by 程巍巍 on 19/04/2017.
//  Copyright © 2017 程巍巍. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridge.h>

@interface RNToast : NSObject<RCTBridgeModule>

@property (class, nonatomic, readonly) NSTimeInterval LONG;
@property (class, nonatomic, readonly) NSTimeInterval SHORT;

@property (class, nonatomic, readonly) NSInteger TOP;
@property (class, nonatomic, readonly) NSInteger CENTER;
@property (class, nonatomic, readonly) NSInteger BOTTOM;

+ (void)make:(NSString*)msg withDuration:(NSTimeInterval)duration gravity:(NSInteger)gravity;

@end
