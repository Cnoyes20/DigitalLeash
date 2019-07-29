//
//  GoodParentViewController.m
//  DigitalLeashParentApp
//
//  Created by Christopher Noyes on 6/27/19.
//  Copyright © 2019 Christopher Noyes. All rights reserved.
//

#import "GoodParentViewController.h"

@interface GoodParentViewController ()

@end

@implementation GoodParentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)GoodParentBackButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
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
