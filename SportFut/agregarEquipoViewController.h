//
//  agregarEquipoViewController.h
//  SportFut
//
//  Created by Info Pixlab on 17/5/17.
//  Copyright © 2017 Pixlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Functions.h"
#import <RMPickerViewController/RMPickerViewController.h>
@import Firebase;

@interface agregarEquipoViewController : UITableViewController <UIPickerViewDelegate, UIPickerViewDataSource>

// [START define_database_reference]
@property (strong, nonatomic) FIRDatabaseReference *ref;
// [END define_database_reference]
@property (nonatomic, strong) NSMutableArray *colores;
@property int rowColorSelected;
@property (weak, nonatomic) IBOutlet UITextField *nombreEquipo;
@property (weak, nonatomic) IBOutlet UIButton *color;

- (IBAction)clicAgregar:(id)sender;
- (IBAction)clicColor:(id)sender;



@end
