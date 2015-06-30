//
//  ViewController.m
//  OneWordChatApp
//
//  Created by Brandon Hafenrichter on 3/1/15.
//  Copyright (c) 2015 Brandon Hafenrichter. All rights reserved.
//

#import <Parse/Parse.h>
#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)login:(id)sender {
    //takes two textfields and compares them within the database
    [PFUser logInWithUsernameInBackground:self.username.text password:self.password.text block:^(PFUser *user, NSError *error) {
        if(user){
            NSLog(@"%@ logging in.", user.username);
            
            //saves it to be used later
            AppDelegate *ap = [[UIApplication sharedApplication] delegate];
            ap.currentUser = user.username;
            
            //transitions
            [self performSegueWithIdentifier:@"loginToTabBar" sender:self];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error userInfo][@"error"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}
- (IBAction)createAccount:(id)sender {
    //set user properties
    PFUser *user = [PFUser user];
    user.username = self.username.text;
    user.password = self.password.text;
    
    //sign up the user into parse database
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        //check to see if username is already taken
        if(!error){
            //set the user id to access rest of information
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error userInfo][@"error"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];

        }
    }];
}

@end
