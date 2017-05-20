//
//  SecondViewController.h
//  SportFut
//
//  Created by Info Pixlab on 17/5/17.
//  Copyright © 2017 Pixlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Functions.h"
#import "Partido.h"
#import "partidoCell.h"
@import Firebase;
@import FirebaseDatabaseUI;

@interface SecondViewController : UIViewController <UITableViewDelegate>{
    BOOL isSearching;
}

// [START define_database_reference]
@property (strong, nonatomic) FIRDatabaseReference *ref;
// [END define_database_reference]

@property (weak, nonatomic) IBOutlet UISearchBar *searchTab;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

