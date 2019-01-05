//
//  ViewController.m
//  FilterMenu
//
//  Created by Pulkit Rohilla on 28/09/16.
//  Copyright © 2016 PulkitRohilla. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)actionSelectedSortOption:(SortMenuControl *)sender {
    
    NSLog(@"Selected option at index : %li",(long)sender.selectedIndex);
}

@end
