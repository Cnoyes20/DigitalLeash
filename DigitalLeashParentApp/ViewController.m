//
//  ViewController.m
//  DigitalLeashParentApp
//
//  Created by Christopher Noyes on 6/26/19.
//  Copyright © 2019 Christopher Noyes. All rights reserved.
//


#import "ViewController.h"

@implementation ViewController {
    CLLocationManager *locationManager;
    UIButton *selectedButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;

    [locationManager requestWhenInUseAuthorization];
    
    [self getMethod];
    self.ErrorLabel.hidden = YES;
}

//Retrieving data from JSON and converting it into a string
- (void) getMethod {
    NSString *dataUrl = @"https://turntotech.firebaseio.com/digitalleash/kb.json";
    NSURL *url = [NSURL URLWithString:dataUrl];
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession]
                                          dataTaskWithURL:url
                                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                              // 4: Handle response here
                                              if(error){
                                                  //print error
                                                  NSLog(@"%@", error.description);
                                              }
                                              else {
                                                  [self parseJsonFromData:data];
                                              }
                                          }];
    [downloadTask resume];
}

-(void)parseJsonFromData:(NSData*)responseData {
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:kNilOptions
                                                           error:&error];
    NSString* userInfo = [json objectForKey:@"Username"];
    NSLog(@"Username: %@", userInfo);

}

- (void)postToJson {

NSString *urlInput = [NSString stringWithFormat:@"https://turntotech.firebaseio.com/digitalleash/%@.json", self.usernameTextField.text];
    
NSURL *url = [NSURL URLWithString:urlInput];
NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
NSURLSession *session = [NSURLSession sessionWithConfiguration:config];

// 2
NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
request.HTTPMethod = @"PUT";

// 3
NSDictionary *userDetails = @{ @"username": self.usernameTextField.text, @"latitude": self.latitudeLabel.text, @"longitude": self.longitudeLabel.text, @"radius": self.radiusTextField.text };
NSError *error = nil;
NSData *data = [NSJSONSerialization dataWithJSONObject:userDetails
                                               options:kNilOptions
                                               error:&error];

if (!error) {
    // 4
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request
                                                               fromData:data
                                                               completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
                                                                   // Handle response here
                                                                   if(error){
                                                                       //print error
                                                                       NSLog(@"%@", error.description);
                                                                   }
                                                                   else {
                                                                       [self parseJsonFromData:data];
                                                                   }
                                                               }];
    
    //5
    [uploadTask resume];
}
    
    
}

- (IBAction)createButton:(id)sender {
    
    [locationManager startUpdatingLocation];
    selectedButton = sender;
    
}

- (IBAction)updateButton:(id)sender {
    
    selectedButton = sender;
    [locationManager startUpdatingLocation];

}

- (IBAction)statusButton:(id)sender {
    long long lat1 = [self.latitudeLabel.text floatValue];
    long long lon1 = [self.longitudeLabel.text floatValue];
    double radius = [self.radiusTextField.text doubleValue];
    //define childLocation by fetching data from the json file "current_latitude/longitude"

    NSError *error;
    
    //error message
    if([_usernameTextField.text  isEqual: @""]) {
        self.ErrorLabel.hidden = NO;
        NSLog(@"error: %@", error.description);
        [locationManager stopUpdatingLocation];
        UIAlertController * errorAlert = [UIAlertController
                                          alertControllerWithTitle:@"Error"
                                          message:@"Failed to enter a valid Username"
                                          
                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [errorAlert addAction:defaultAction];
        
        [self presentViewController:errorAlert animated:YES completion:nil];
    }
    else {
        self.ErrorLabel.hidden = YES;
    }
    
    NSString *url_string = [NSString stringWithFormat:@"https://turntotech.firebaseio.com/digitalleash/%@.json", self.usernameTextField.text];
    NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:url_string]];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSLog(@"json: %@", json);
    

    NSString *lat2 = [json objectForKey:@"current_latitude"];
    NSString *lon2 = [json objectForKey:@"current_longitude"];
    
    long long lat3 = [lat2 floatValue];
    long long lon3 = [lon2 floatValue];
    
    //
    CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:lat1 longitude:lon1];
    CLLocation *childLocation = [[CLLocation alloc] initWithLatitude:lat3 longitude:lon3];
    double distance = [loc1 distanceFromLocation:childLocation];
    if(distance < radius) {
    [self performSegueWithIdentifier:@"GoodPage" sender:self];
    }
    else if(distance > radius){
    [self performSegueWithIdentifier:@"BadPage" sender:self];
    }
    
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", error);
    
    UIAlertController * errorAlert = [UIAlertController
                                      alertControllerWithTitle:@"Error"
                                      message:@"Failed to Get Your Location"
                                      
                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [errorAlert addAction:defaultAction];
    
    [self presentViewController:errorAlert animated:YES completion:nil];

}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    NSLog(@"didUpdateToLocation: %@", locations);
    CLLocation *currentLocation = locations[locations.count-1];
    
    if (currentLocation != nil) {
        _longitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        _latitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        
        if([selectedButton.titleLabel.text isEqual:@"Create"]){
            [self postToJson];
        }
        
        
    }
    
    [locationManager stopUpdatingLocation];
  
}

@end
