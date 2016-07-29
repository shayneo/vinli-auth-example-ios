//
//  ViewController.m
//  Vinli-Auth-Example
//
//  Created by Shayne O'Sullivan on 7/26/16.
//  Copyright © 2016 Shayne O'Sullivan. All rights reserved.
//

#import "ViewController.h"
#import "secrets.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *StatusView;
@property (weak, nonatomic) IBOutlet UILabel *LoginStatusLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // If we are already logged in, we can create a VLService and continue with the app.
    if([VLSessionManager loggedIn]){
        _vlService = [[VLService alloc] initWithSession:[VLSessionManager currentSession]];
        _StatusView.backgroundColor = [UIColor greenColor];
        _LoginStatusLabel.text = @"Logged in, yay!";
        
    } else {
        _StatusView.backgroundColor = [UIColor redColor];
        _LoginStatusLabel.text = @"Not Logged In.";
    }
}

- (IBAction)LoginButtonPressed:(UIButton *)sender {
    [self loginWithVinli];
}

- (void) loginWithVinli{
    // Clear cookies before calling loginWithClientId
    [self clearCookies];
    
    // This will launch the Vinli login flow.
    [VLSessionManager loginWithClientId:CLIENT_ID // Get your app client id at dev.vin.li
                            redirectUri:REDIRECT_URI // Get your app redirect uri at dev.vin.li
                             completion:^(VLSession * _Nullable session, NSError * _Nullable error) { // Called if the user successfully logs in, or if there is an error
                                 if(!error){
                                     NSLog(@"Logged in successfully");
                                     _StatusView.backgroundColor = [UIColor greenColor];
                                     _LoginStatusLabel.text = @"Logged in, yay!";
                                 }else{
                                     NSLog(@"Error logging in: %@", [error localizedDescription]);
                                     _StatusView.backgroundColor = [UIColor redColor];
                                     _LoginStatusLabel.text = @"Not Logged In.";
                                 }
                             } onCancel:^{ // Called if the user presses the 'Cancel' button
                                 NSLog(@"Canceled login");
                             }];
}

- (void) logOutWithVinli{
    [VLSessionManager logOut];
}

- (IBAction)logOutButtonPressed:(id)sender {
    //[VLSessionManager logOut];
    [self logOutWithVinli];
    _StatusView.backgroundColor = [UIColor redColor];
    _LoginStatusLabel.text = @"Not Logged In.";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) clearCookies{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}


@end
