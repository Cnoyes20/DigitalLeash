//
//  BadParentViewController.m
//  DigitalLeashParentApp
//
//  Created by Christopher Noyes on 6/27/19.
//  Copyright © 2019 Christopher Noyes. All rights reserved.
//

#import "BadParentViewController.h"

@interface BadParentViewController ()

@end

@implementation BadParentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)UhOhButton:(id)sender {
      [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
