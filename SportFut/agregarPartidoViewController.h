//
//  agregarPartidoViewController.h
//  SportFut
//
//  Created by Info Pixlab on 17/5/17.
//  Copyright © 2017 Pixlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Functions.h"
#import <RMPickerViewController/RMPickerViewController.h>
@import Firebase;

@interface agregarPartidoViewController : UITableViewController<UIPickerViewDelegate, UIPickerViewDataSource>

// [START define_database_reference]
@property (strong, nonatomic) FIRDatabaseReference *ref;
// [END define_database_reference]
@property (nonatomic, strong) NSMutableArray *equipos;
@property int rowEquipo1Selected;
@property int rowEquipo2Selected;

@property (weak, nonatomic) IBOutlet UITextField *nombrePartido;
@property (weak, nonatomic) IBOutlet UIButton *botonEquipo1;
@property (weak, nonatomic) IBOutlet UIButton *botonEquipo2;
@property (weak, nonatomic) IBOutlet UIStepper *golesEquipo1;
@property (weak, nonatomic) IBOutlet UILabel *golesEquipo1Display;
@property (weak, nonatomic) IBOutlet UIStepper *golesEquipo2;
@property (weak, nonatomic) IBOutlet UILabel *golesEquipo2Display;

- (IBAction)clicEquipo1:(id)sender;
- (IBAction)clicEquipo2:(id)sender;
- (IBAction)clicGolesEquipo1:(id)sender;
- (IBAction)clicGolesEquipo2:(id)sender;
- (IBAction)clicAgregar:(id)sender;


@end
