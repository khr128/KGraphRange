//
//  KGRangeView.m
//  KGraphRange
//
//  Created by khr on 4/2/16.
//  Copyright © 2016 khr. All rights reserved.
//

#import "KGRangeView.h"

@implementation KGRangeView {

  NSColor *_selectedPartColor;
  NSColor *_unselectedPartColor;
  NSColor *_trackingAreaColor;

  CGRect _selectedPartRect;
  CGRect _lowTrackingRect;
  CGRect _highTrackingRect;
  CGRect _currentTrackingRect;

  BOOL _enteredLowTrackingArea;
  BOOL _enteredHighTrackingArea;
  
  BOOL _draggingLowTrackingArea;
  BOOL _draggingHighTrackingArea;

  CGFloat _trackingAreaHalfWidth;
  
}

static CGFloat kMinFractionDifference = 0.01;

- (void)awakeFromNib {

  self.lowFraction = 0.2f;
  self.highFraction = 0.57f;

  _selectedPartColor = [NSColor colorWithRed:24.0f / 255.0f green:124.0f / 255.0f blue:31.0f / 255.0f alpha:1.0f];
  _unselectedPartColor = [NSColor colorWithRed:234.0f / 255.0f green:20.0f / 255.0f blue:3.0f / 255.0f alpha:1.0f];
  _trackingAreaColor = [NSColor colorWithRed:220.0f / 255.0f green:214.0f / 255.0f blue:214.0f / 255.0f alpha:0.3f];

  _trackingAreaHalfWidth = 5;
  _enteredLowTrackingArea = NO;
  _enteredHighTrackingArea = NO;
  _draggingHighTrackingArea = NO;
  _draggingHighTrackingArea = NO;

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

  if (_enteredLowTrackingArea || _enteredHighTrackingArea) {

    CGContextSetFillColorWithColor(context, _trackingAreaColor.CGColor);
    CGContextFillRect(context, _currentTrackingRect);

  }

}

- (CGRect)addTrackingAreaForType:(NSString *)trackingAreaType {

  BOOL isLow = [trackingAreaType isEqualToString:@"low"];

  CGFloat fraction =  isLow ? _lowFraction : _highFraction;
  CGFloat w = NSWidth(self.bounds);
  CGFloat xc = fraction * w;

  CGRect trackingRect = NSMakeRect(xc - _trackingAreaHalfWidth,
                                   NSMinY(self.bounds),
                                   2*_trackingAreaHalfWidth,
                                   NSHeight(self.bounds));

  NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:trackingRect
                                                              options:
                                  NSTrackingMouseEnteredAndExited
                                  | NSTrackingCursorUpdate
                                  | NSTrackingActiveInKeyWindow
                                                                owner:self
                                                             userInfo:@{
                                                                        @"type" : trackingAreaType
                                                                        }
                                  ];

  [self addTrackingArea:trackingArea];

  return trackingRect;
}

- (void)updateTrackingAreas {

  [self.trackingAreas enumerateObjectsUsingBlock:^(NSTrackingArea *ta, NSUInteger idx, BOOL *stop) {

    [self removeTrackingArea:ta];

  }];

  _lowTrackingRect = [self addTrackingAreaForType:@"low"];
  _highTrackingRect = [self addTrackingAreaForType:@"high"];
  
}

- (void)viewDidMoveToWindow {

  NSLog(@"Window: %c", self.window.acceptsMouseMovedEvents);
  self.window.acceptsMouseMovedEvents = YES;

  _lowTrackingRect = [self addTrackingAreaForType:@"low"];
  _highTrackingRect = [self addTrackingAreaForType:@"high"];

}

- (void)mouseEntered:(NSEvent *)theEvent {
  
  if (_draggingHighTrackingArea || _draggingLowTrackingArea) {
    
    return;
    
  }

  NSDictionary *userData = theEvent.userData;

  if (userData && [userData[@"type"] isEqualToString:@"low"]) {

    _currentTrackingRect = _lowTrackingRect;
    _enteredLowTrackingArea = YES;

  } else if (userData && [userData[@"type"] isEqualToString:@"high"]) {

    _currentTrackingRect = _highTrackingRect;
    _enteredHighTrackingArea = YES;

  }

  self.needsDisplay = YES;
  
}

- (void)mouseDragged:(NSEvent *)theEvent {
  
  NSPoint eventLocation = theEvent.locationInWindow;
  NSPoint localPoint = [self convertPoint:eventLocation fromView:nil];
  
  CGFloat fraction = localPoint.x / NSWidth(self.bounds);
  
  NSLog(@"Local point: (%g, %g)", localPoint.x, localPoint.y);
  NSLog(@"Low x: %g, fraction: %g", _lowFraction * NSWidth(self.bounds), fraction);
  
  if (_enteredLowTrackingArea || _draggingLowTrackingArea) {
    
    if (_draggingLowTrackingArea == NO) {
      
      _draggingLowTrackingArea = YES;
      _enteredLowTrackingArea = NO;
      _enteredHighTrackingArea = NO;
      
    }
    
    if (fraction < _highFraction - kMinFractionDifference) {
      
      _lowFraction = fraction > 0.0 ? fraction : 0.0;
      self.needsDisplay = true;
      
    }
    
  } else if (_enteredHighTrackingArea || _draggingHighTrackingArea) {
    
    if (_draggingHighTrackingArea == NO) {
      
      _draggingHighTrackingArea = YES;
      _enteredLowTrackingArea = NO;
      _enteredHighTrackingArea = NO;
      
    }
    
    if (fraction > _lowFraction + kMinFractionDifference) {
      
      _highFraction = fraction <= 1.0 ? fraction : 1.0;
      self.needsDisplay = true;
      
    }
    
  }
  
}

- (void)mouseUp:(NSEvent *)theEvent {
  
  _draggingLowTrackingArea = NO;
  _draggingHighTrackingArea = NO;
  
  [self updateTrackingAreas];
  self.needsDisplay = YES;
  
}

- (void)mouseExited:(NSEvent *)theEvent {

  _enteredLowTrackingArea = NO;
  _enteredLowTrackingArea = NO;
  self.needsDisplay = YES;

}

- (void)cursorUpdate:(NSEvent *)event {
  

  NSDictionary *userData = event.userData;
  if (userData && [userData[@"type"] isEqualToString:@"low"]) {

    [self addCursorRect:_lowTrackingRect cursor:[NSCursor resizeLeftRightCursor]];

  } else if (userData && [userData[@"type"] isEqualToString:@"high"]) {

    [self addCursorRect:_highTrackingRect cursor:[NSCursor resizeLeftRightCursor]];

  }


}


@end
