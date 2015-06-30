//
//  ChatListViewController.m
//  OneWordChatApp
//
//  Created by Brandon Hafenrichter on 3/2/15.
//  Copyright (c) 2015 Brandon Hafenrichter. All rights reserved.
//

#import "ChatListViewController.h"
#import <Parse/Parse.h>
#import "ChatViewController.h"
#import "AppDelegate.h"

@interface ChatListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *chatList;
@property NSArray *currentGamesList;
@property NSArray *completedGamesList;
@property NSString *currentUser;
@end

@implementation ChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //gets current user to query table
    AppDelegate *ap = [[UIApplication sharedApplication] delegate];
    self.currentUser = ap.currentUser;
    
    //set tableview delegate to self
    self.chatList.delegate = self;
    self.chatList.dataSource = self;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"player1 = %@ OR player2 = %@", self.currentUser, self.currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Game" predicate:predicate];
    [query orderByAscending:@"updatedAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            self.currentGamesList = [[NSArray alloc] initWithArray:objects];
            for(int i = 0; i < objects.count; i++){
                
            }
            [self.chatList reloadData];
        }else{
            
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.currentGamesList count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.chatList dequeueReusableCellWithIdentifier:@"ChatListCell" forIndexPath:indexPath];
    
    PFObject *curObject = [self.currentGamesList objectAtIndex:indexPath.row];
    NSString *currentUsername = [curObject objectForKey:@"player1"];
    if([currentUsername  isEqual: self.currentUser]){
        cell.textLabel.text = [curObject objectForKey:@"player2"];
    }else{
        cell.textLabel.text = [curObject objectForKey:@"player1"];
    }
    cell.detailTextLabel.text = [curObject objectId];
    return cell;
}



// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([[segue identifier] isEqualToString:@"ChatListToChat"]){
        ChatViewController *cv = [segue destinationViewController];
        //gets selected row
        NSIndexPath *selectedIndexPath = [self.chatList indexPathForSelectedRow];
        PFObject *selectedObject = [self.currentGamesList objectAtIndex:selectedIndexPath.row];
        cv.gameID = [selectedObject objectId];
        //set to toogle depending on which player he is
        if([self.currentUser isEqualToString:[selectedObject objectForKey:@"player1"]]){
            //user is player 1
            cv.myWord = [selectedObject objectForKey:@"player1Word"];
            cv.opponentWord = [selectedObject objectForKey:@"player2Word"];
            cv.currentOpponent = [selectedObject objectForKey:@"player2"];
        }else{
            //user is player 2
            cv.myWord = [selectedObject objectForKey:@"player2Word"];
            cv.opponentWord = [selectedObject objectForKey:@"player1Word"];
            cv.currentOpponent = [selectedObject objectForKey:@"player1"];
        }
        cv.currentUser = self.currentUser;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2 ;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0)
        return @"Current Games";
    else
        return @"Finished Games";
}


@end
