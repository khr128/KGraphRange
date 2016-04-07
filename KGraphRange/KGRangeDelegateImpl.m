//
//  KGRangeDelegateImpl.m
//  KGraphRange
//
//  Created by DMITRI KHREBTUKOV on 4/7/16.
//  Copyright © 2016 khr. All rights reserved.
//

#import "KGRangeDelegateImpl.h"

@implementation KGRangeDelegateImpl

@synthesize lowFraction = _lowFraction, highFraction = _highFraction;

- (void)setLowFraction:(CGFloat)lowFraction {
  
  _lowFraction = lowFraction;
  NSLog(@"Low fraction changed to %g", self.lowFraction);
  
}

- (void)setHighFraction:(CGFloat)highFraction {
  
  _highFraction = highFraction;
  NSLog(@"High fraction changed to %g", self.highFraction);
  
}

@end
