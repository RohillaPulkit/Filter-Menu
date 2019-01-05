//
//  SortMenuControl.h
//  SortMenu
//
//  Created by Pulkit Rohilla on 28/09/16.
//  Copyright © 2016 PulkitRohilla. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface SortMenuControl : UIControl

@property (strong, nonatomic) IBInspectable UIColor *backColor;
@property (strong, nonatomic) IBInspectable UIColor *foreColor;

@property (nonatomic) NSInteger selectedIndex;

@end



