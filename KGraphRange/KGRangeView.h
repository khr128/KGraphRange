//
//  KGRangeView.h
//  KGraphRange
//
//  Created by khr on 4/2/16.
//  Copyright © 2016 khr. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KGraphRangeDelegate.h"

@interface KGRangeView : NSView

//@property CGFloat lowFraction;
//@property CGFloat highFraction;

@property (weak) id<KGraphRangeDelegate> rangeDelegate;

@end
