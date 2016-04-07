//
//  KGraphRangeDelegate.h
//  KGraphRange
//
//  Created by DMITRI KHREBTUKOV on 4/7/16.
//  Copyright © 2016 khr. All rights reserved.
//


@protocol KGraphRangeDelegate <NSObject>

@property (readwrite) CGFloat lowFraction;
@property (readwrite) CGFloat highFraction;

@end