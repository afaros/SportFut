//
//  agregarEquipoViewController.m
//  SportFut
//
//  Created by Info Pixlab on 17/5/17.
//  Copyright © 2017 Pixlab. All rights reserved.
//

#import "agregarEquipoViewController.h"

@interface agregarEquipoViewController ()

@property (strong, nonatomic) FIRDatabaseQuery *postRef;

@end

@implementation agregarEquipoViewController

FIRDatabaseHandle _refHandleColors;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // [START create_database_reference]
    self.ref = [[FIRDatabase database] reference];
    // [END create_database_reference]

    // Botón color
    self.color.layer.cornerRadius = 4.0f;
    self.color.clipsToBounds = YES;
    self.color.layer.borderColor = [[Functions colorWithHexString:@"e6e5e6"] CGColor];
    self.color.layer.borderWidth = 1;
    [self.color setTitleColor:[Functions colorWithHexString:@"c7c7cd"] forState:UIControlStateNormal];
    
    self.rowColorSelected = -1;
    
    // [START create_database_reference]
    self.ref = [[FIRDatabase database] reference];
    // [END create_database_reference]
    
    FIRDatabaseReference *ref = [FIRDatabase database].reference;
    self.postRef = [[ref child:@"colores"] queryOrderedByChild:@"nombre"];
    
    if (!self.colores) self.colores = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.colores removeAllObjects];
    // [START child_event_listener]
    // Listen for new club in the Firebase database
    [_postRef
     observeEventType:FIRDataEventTypeChildAdded
     withBlock:^(FIRDataSnapshot *snapshot) {
         [self.colores addObject:snapshot];
     }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.postRef removeAllObservers];
}

- (IBAction)clicAgregar:(id)sender {
    if(![self.nombreEquipo.text isEqualToString:@""] && self.rowColorSelected != -1){
        FIRDataSnapshot *snapshot = _colores[self.rowColorSelected];
        NSDictionary *color = snapshot.value;
        
        // Id automático
        NSString *key = [[_ref child:@"equipos"] childByAutoId].key;
        NSDictionary *post = @{@"nombre": self.nombreEquipo.text, @"color": color[@"hexadecimal"],};
        NSDictionary *childUpdates = @{[@"/equipos/" stringByAppendingString:key]: post,
                                   };
        [_ref updateChildValues:childUpdates];
        
        // Mostramos mensaje de exito
        UIAlertAction *btnAceptar = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self.navigationController popViewControllerAnimated:true];
        }];
        
        NSArray *actions = [[NSArray alloc] initWithObjects:btnAceptar, nil];
        
        UIAlertController *alert = [Functions getAlert:@"Exito" withMessage:@"Se ha agregado el equipo exitosamente." withActions:actions];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        UIAlertController *alert = [Functions getAlert:@"Error" withMessage:@"Todos los campos son requeridos"];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)clicColor:(id)sender {
    RMActionControllerStyle style = RMActionControllerStyleWhite;
    
    RMAction<UIPickerView *> *selectAction = [RMAction<UIPickerView *> actionWithTitle:@"Seleccionar" style:RMActionStyleDone andHandler:^(RMActionController<UIPickerView *> *controller) {
        
        // Selecciono un color exitosamente
        self.rowColorSelected = [controller.contentView selectedRowInComponent:0];
        
        FIRDataSnapshot *snapshot = _colores[[controller.contentView selectedRowInComponent:0]];
        NSDictionary *color = snapshot.value;
        
        [self.color setTitle:color[@"nombre"] forState:UIControlStateNormal];
        [self.color setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }];
    
    RMAction<UIPickerView *> *cancelAction = [RMAction<UIPickerView *> actionWithTitle:@"Cancelar" style:RMActionStyleCancel andHandler:^(RMActionController<UIPickerView *> *controller) {
        NSLog(@"Row selection was canceled");
    }];
    
    RMPickerViewController *pickerController = [RMPickerViewController actionControllerWithStyle:style];
    pickerController.message = @"Seleccione el color del equipo";
    pickerController.picker.dataSource = self;
    pickerController.picker.delegate = self;
    
    [pickerController addAction:selectAction];
    [pickerController addAction:cancelAction];
    
    // Default
    [pickerController.picker selectRow:self.rowColorSelected inComponent:0 animated:NO];
    
    //You can enable or disable blur, bouncing and motion effects
    pickerController.disableBouncingEffects = NO;
    pickerController.disableMotionEffects = NO;
    pickerController.disableBlurEffects =  NO;
    
    //Now just present the picker view controller using the standard iOS presentation method
    [self presentViewController:pickerController animated:YES completion:nil];
}

#pragma mark - RMPickerViewController Delegates
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.colores count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    FIRDataSnapshot *snapshot = _colores[row];
    NSDictionary *color = snapshot.value;
    
    return color[@"nombre"];
}

@end
