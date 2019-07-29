//
//  ViewController.m
//  DigitalLeashChildApp
//
//  Created by Christopher Noyes on 6/27/19.
//  Copyright © 2019 Christopher Noyes. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
     CLLocationManager *locationManager;
     CLLocationCoordinate2D coordinate;
     UIButton *selectedButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager requestWhenInUseAuthorization];
}

-(void)parseJsonFromData:(NSData*)responseData {
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:kNilOptions
                                                           error:&error];
    NSString* userInfo = [json objectForKey:@"username"];
    NSLog(@"Username: %@", userInfo);
}

- (void)postToJson {
    
    NSString *urlInput = [NSString stringWithFormat:@"https://turntotech.firebaseio.com/digitalleash/%@.json", self.UsernameTextField.text];
    
    NSURL *url = [NSURL URLWithString:urlInput];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    // 2
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"PATCH";
    
    // 3
    NSDictionary *childDetails = @{ @"username": self.UsernameTextField.text, @"current_latitude": [NSNumber numberWithDouble: coordinate.latitude] , @"current_longitude": [NSNumber numberWithDouble: coordinate.longitude]};
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:childDetails
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

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    NSLog(@"didUpdateToLocation: %@", locations);
    CLLocation *currentLocation = locations[locations.count-1];
    
    if (currentLocation != nil) {
        coordinate = currentLocation.coordinate;
    
        if([selectedButton.titleLabel.text isEqual:@"Report Location"]){
            [self postToJson];
            
        }
    }
    
    [locationManager stopUpdatingLocation];
    
}

- (IBAction)UsernameLabel:(id)sender {
    
}

- (IBAction)ReportLocationButton:(id)sender {
    
    [locationManager startUpdatingLocation];
    
    selectedButton = sender;
    
    }

@end
