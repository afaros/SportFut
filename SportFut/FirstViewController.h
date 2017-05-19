//
//  FirstViewController.h
//  SportFut
//
//  Created by Info Pixlab on 17/5/17.
//  Copyright © 2017 Pixlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Functions.h"
#import "equipoCell.h"
#import "Equipo.h"
@import Firebase;
@import FirebaseDatabaseUI;

@interface FirstViewController : UIViewController <UITableViewDelegate>

// [START define_database_reference]
@property (strong, nonatomic) FIRDatabaseReference *ref;
// [END define_database_reference]

//@property (strong, nonatomic) NSString *postKey;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

