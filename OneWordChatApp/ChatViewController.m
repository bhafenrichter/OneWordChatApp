//
//  ChatViewController.m
//  OneWordChatApp
//
//  Created by Brandon Hafenrichter on 3/9/15.
//  Copyright (c) 2015 Brandon Hafenrichter. All rights reserved.
//

#import "ChatViewController.h"
#import <Parse/Parse.h>

@interface ChatViewController ()
@property (weak, nonatomic) IBOutlet UILabel *goalWord;
@property (weak, nonatomic) IBOutlet UITableView *chatList;
@property (weak, nonatomic) IBOutlet UITextField *messageContents;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //get game information
    self.goalWord.text = self.myWord;
    
    //set up table
    self.chatList.delegate = self;
    self.chatList.dataSource = self;
    
    //query for chat list
    PFQuery *query = [PFQuery queryWithClassName:@"Chat"];
    [query whereKey:@"gameID" containsString:self.gameID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            self.chatData = [[NSArray alloc] initWithArray:objects];
            [self.chatList reloadData];
        }else{
            NSLog(error);
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendMessage:(id)sender {
    PFObject *message = [PFObject objectWithClassName:@"Chat"];
    [message setValue:self.messageContents.text forKey:@"message"];
    [message setValue:self.gameID forKey:@"gameID"];
    [message setValue:self.currentUser forKey:@"authorID"];
    [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(!error){
            //check to see if message contains word
            NSString *comparedString = [self.messageContents.text lowercaseString];
            if([[self.messageContents.text lowercaseString] containsString:[self.opponentWord lowercaseString]]){
                NSLog(@"USER LOSES");
                [self finishGame];
            }else{
                NSLog(@"%@ != %@", [self.messageContents.text lowercaseString], self.opponentWord);
                self.messageContents.text = @"";
                NSLog(@"Message Successfully sent.");
            }
            [self.chatList reloadData];
        }else{
            NSLog(@"Message did NOT send.");
        }
    }];
}

-(void) finishGame {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh..." message: [NSString stringWithFormat: @"You have lost to your opponent, %@, with the word %@", self.currentOpponent, self.opponentWord] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    
    //update backend
    PFQuery *query = [PFQuery queryWithClassName:@"Game"];
    [query getObjectInBackgroundWithId:self.gameID block:^(PFObject *game, NSError *error) {
        if(!error){
            game[@"isFinished"] = @YES;
            [game saveInBackground];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh..." message: [NSString stringWithFormat: @"Error"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

//table
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.chatData.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.chatList dequeueReusableCellWithIdentifier:@"ChatCell" forIndexPath:indexPath];
    
    PFObject *curObject = [self.chatData objectAtIndex:indexPath.row];
    NSString *curMessageContents = [curObject objectForKey:@"message"];
    NSString *curMessageAuthor = [curObject objectForKey:@"authorID"];
    cell.textLabel.text = curMessageContents;
    cell.detailTextLabel.text = curMessageAuthor;
    
    return cell;
}



// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

@end
