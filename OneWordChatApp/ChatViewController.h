//
//  ChatViewController.h
//  OneWordChatApp
//
//  Created by Brandon Hafenrichter on 3/9/15.
//  Copyright (c) 2015 Brandon Hafenrichter. All rights reserved.
//

#import "ViewController.h"

@interface ChatViewController : ViewController <UITableViewDataSource, UITableViewDelegate>
//game setup
@property NSString *myWord;
@property NSString *opponentWord;
@property NSString *gameID;
@property NSString *currentUser;
@property NSString *currentOpponent;
@property NSArray *chatData;

@end
