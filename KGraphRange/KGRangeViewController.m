//
//  KGRangeViewController.m
//  KGraphRange
//
//  Created by khr on 4/2/16.
//  Copyright © 2016 khr. All rights reserved.
//

#import "KGRangeViewController.h"
#import "KGRangeView.h"

@interface KGRangeViewController ()

@end

@implementation KGRangeViewController

- (void)viewDidLoad {

  [super viewDidLoad];
  self.view.layer.backgroundColor = [NSColor redColor].CGColor;
  
  KGRangeView *rangeView = (KGRangeView *)self.view;
  rangeView.rangeDelegate = self.rangeDelegate;

}

@end
