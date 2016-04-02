//
//  KGRangeView.m
//  KGraghRange
//
//  Created by khr on 4/2/16.
//  Copyright © 2016 khr. All rights reserved.
//

#import "KGRangeView.h"

@implementation KGRangeView {

  NSColor *_selectedPartColor;
  NSColor *_unselectedPartColor;
  CGRect _selectedPartRect;

}


- (void)awakeFromNib {

  self.lowFraction = 0.2f;
  self.highFraction = 0.57f;

  _selectedPartColor = [NSColor colorWithRed:24.0f / 255.0f green:124.0f / 255.0f blue:31.0f / 255.0f alpha:1.0f];
  _unselectedPartColor = [NSColor colorWithRed:214.0f / 255.0f green:24.0f / 255.0f blue:31.0f / 255.0f alpha:1.0f];

}

- (void)makeSelectedPartRect {

  CGFloat w = NSWidth(self.bounds);
  CGFloat dx1 = _lowFraction * w;
  CGFloat dx2 = _highFraction * w;
  _selectedPartRect = NSMakeRect(dx1, NSMinY(self.bounds), dx2 - dx1, NSHeight(self.bounds));

}


- (void)drawRect:(NSRect)dirtyRect {

  NSGraphicsContext *gcontext = [NSGraphicsContext currentContext];
  CGContextRef context = [gcontext graphicsPort];

  CGContextSetFillColorWithColor(context, _unselectedPartColor.CGColor);
  CGContextFillRect(context, self.bounds);

  [self makeSelectedPartRect];

  CGContextSetFillColorWithColor(context, _selectedPartColor.CGColor);
  CGContextFillRect(context, _selectedPartRect);

}

@end
