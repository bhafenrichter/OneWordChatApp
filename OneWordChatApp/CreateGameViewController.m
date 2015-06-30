//
//  CreateGameViewController.m
//  OneWordChatApp
//
//  Created by Brandon Hafenrichter on 3/2/15.
//  Copyright (c) 2015 Brandon Hafenrichter. All rights reserved.
//

#import "CreateGameViewController.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"

@interface CreateGameViewController ()
@property (weak, nonatomic) IBOutlet UITableView *potentialGameList;
@property NSArray *potentialUsers;
@property NSString *currentUser;

@end

@implementation CreateGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //loads current user
    AppDelegate *ap = [[UIApplication sharedApplication] delegate];
    self.currentUser = ap.currentUser;
    
    //set up tableview
    self.potentialGameList.delegate = self;
    self.potentialGameList.dataSource = self;
    
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            //get query and store it to populate table
            self.potentialUsers = [[NSArray alloc] initWithArray:objects];
            [self.potentialGameList reloadData];
            
        }else{
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.potentialUsers count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.potentialGameList dequeueReusableCellWithIdentifier:@"CreateGameCell" forIndexPath:indexPath];
    
    //set up table cell
    PFObject *curObject = [self.potentialUsers objectAtIndex:indexPath.row];
    cell.textLabel.text = [curObject objectForKey:@"username"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New Game"
                                                    message:@"Would you like to start a new game with "
                                                   delegate:self
                                          cancelButtonTitle:@"Yes"
                                          otherButtonTitles:nil];
    [alert show];
    
    //create game in backend
    PFObject *game = [PFObject objectWithClassName:@"Game"];
    //HARDCODED
    game[@"player1"] = self.currentUser;
    game[@"player2"] = [[self.potentialUsers objectAtIndex:indexPath.row] objectForKey:@"username"];
    //generate random word
    game[@"player1Word"] = @"Beach";
    game[@"player2Word"] = @"Batch";
    
    [game saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded){
            //move to chat
            [self performSegueWithIdentifier:@"CreateGameToChat" sender:self];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Unable to Create Game."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        }
    }];
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //responds to alertview click
    NSLog(@"Transitioning");
    
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
