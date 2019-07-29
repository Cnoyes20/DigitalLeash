//
//  ViewController.h
//  DigitalLeashParentApp
//
//  Created by Christopher Noyes on 6/26/19.
//  Copyright © 2019 Christopher Noyes. All rights reserved.
//

@import UIKit;
@import CoreLocation;

@interface ViewController : UIViewController <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

@property (weak, nonatomic) IBOutlet UITextField *radiusTextField;

@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;

@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;

@property (weak, nonatomic) IBOutlet UILabel *ErrorLabel;

- (IBAction)createButton:(id)sender;

- (IBAction)updateButton:(id)sender;

- (IBAction)statusButton:(id)sender;


@end

