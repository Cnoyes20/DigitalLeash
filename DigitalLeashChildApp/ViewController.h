//
//  ViewController.h
//  DigitalLeashChildApp
//
//  Created by Christopher Noyes on 6/27/19.
//  Copyright © 2019 Christopher Noyes. All rights reserved.
//

@import UIKit;
@import CoreLocation;

@interface ViewController : UIViewController <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *UsernameLabel;

@property (weak, nonatomic) IBOutlet UITextField *UsernameTextField;

@property (weak, nonatomic) IBOutlet UIButton *ReportLocationButton;


@end

