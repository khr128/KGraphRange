//
//  KGRangeViewController.h
//  KGraphRange
//
//  Created by khr on 4/2/16.
//  Copyright © 2016 khr. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KGraphRangeDelegate.h"

@interface KGRangeViewController : NSViewController

@property (strong) IBOutlet id<KGraphRangeDelegate> rangeDelegate;

@end
