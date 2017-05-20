//
//  agregarPartidoViewController.m
//  SportFut
//
//  Created by Info Pixlab on 17/5/17.
//  Copyright © 2017 Pixlab. All rights reserved.
//

#import "agregarPartidoViewController.h"

@interface agregarPartidoViewController ()

@property (strong, nonatomic) FIRDatabaseQuery *postRef;

@end

@implementation agregarPartidoViewController

FIRDatabaseHandle _refHandleEquipos;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // [START create_database_reference]
    self.ref = [[FIRDatabase database] reference];
    // [END create_database_reference]
    
    // Botón equipo2
    self.botonEquipo1.layer.cornerRadius = 4.0f;
    self.botonEquipo1.clipsToBounds = YES;
    self.botonEquipo1.layer.borderColor = [[Functions colorWithHexString:@"e6e5e6"] CGColor];
    self.botonEquipo1.layer.borderWidth = 1;
    [self.botonEquipo1 setTitleColor:[Functions colorWithHexString:@"c7c7cd"] forState:UIControlStateNormal];
    
    self.botonEquipo2.layer.cornerRadius = 4.0f;
    self.botonEquipo2.clipsToBounds = YES;
    self.botonEquipo2.layer.borderColor = [[Functions colorWithHexString:@"e6e5e6"] CGColor];
    self.botonEquipo2.layer.borderWidth = 1;
    [self.botonEquipo2 setTitleColor:[Functions colorWithHexString:@"c7c7cd"] forState:UIControlStateNormal];
    
    self.rowEquipo1Selected = -1;
    self.rowEquipo2Selected = -1;
    
    self.golesEquipo1Display.text = [NSString stringWithFormat:@"%d", [[NSNumber numberWithFloat:self.golesEquipo1.value] intValue]];
    self.golesEquipo2Display.text = [NSString stringWithFormat:@"%d", [[NSNumber numberWithFloat:self.golesEquipo2.value] intValue]];
    
    // [START create_database_reference]
    self.ref = [[FIRDatabase database] reference];
    // [END create_database_reference]
    
    FIRDatabaseReference *ref = [FIRDatabase database].reference;
    self.postRef = [[ref child:@"equipos"] queryOrderedByChild:@"nombre"];
    
    if (!self.equipos) self.equipos = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.equipos removeAllObjects];
    // [START child_event_listener]
    // Listen for new club in the Firebase database
    [_postRef
     observeEventType:FIRDataEventTypeChildAdded
     withBlock:^(FIRDataSnapshot *snapshot) {
         [self.equipos addObject:snapshot];
     }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.postRef removeObserverWithHandle:_refHandleEquipos];
    [self.postRef removeAllObservers];
}

#pragma mark - RMPickerViewController Delegates
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.equipos count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    FIRDataSnapshot *snapshot = _equipos[row];
    NSDictionary *equipo = snapshot.value;
    
    return equipo[@"nombre"];
}

- (IBAction)clicEquipo1:(id)sender {
    [self mostrarPicker:1];
}

- (IBAction)clicEquipo2:(id)sender {
    [self mostrarPicker:2];
}

- (IBAction)clicGolesEquipo1:(id)sender {
    self.golesEquipo1Display.text = [NSString stringWithFormat:@"%d", [[NSNumber numberWithFloat:self.golesEquipo1.value] intValue]];
}

- (IBAction)clicGolesEquipo2:(id)sender {
    self.golesEquipo2Display.text = [NSString stringWithFormat:@"%d", [[NSNumber numberWithFloat:self.golesEquipo2.value] intValue]];
}

- (IBAction)clicAgregar:(id)sender {
    if(![self.nombrePartido.text isEqualToString:@""] && self.rowEquipo1Selected != -1 && self.rowEquipo2Selected != -1){
        FIRDataSnapshot *snapshot1 = _equipos[self.rowEquipo1Selected];
        NSDictionary *equipo1 = snapshot1.value;
        FIRDataSnapshot *snapshot2 = _equipos[self.rowEquipo2Selected];
        NSDictionary *equipo2 = snapshot2.value;
        
        // Id automático
        NSString *key = [[_ref child:@"partidos"] childByAutoId].key;
        NSDictionary *post = @{@"nombre": self.nombrePartido.text, @"nombreEquipo1": equipo1[@"nombre"], @"colorEquipo1": equipo1[@"color"], @"golesEquipo1": self.golesEquipo1Display.text,@"nombreEquipo2": equipo2[@"nombre"], @"colorEquipo2": equipo2[@"color"], @"golesEquipo2": self.golesEquipo2Display.text,};
        NSDictionary *childUpdates = @{[@"/partidos/" stringByAppendingString:key]: post,
                                       };
        [_ref updateChildValues:childUpdates];
        
        // Mostramos mensaje de exito
        UIAlertAction *btnAceptar = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self.navigationController popViewControllerAnimated:true];
        }];
        
        NSArray *actions = [[NSArray alloc] initWithObjects:btnAceptar, nil];
        
        UIAlertController *alert = [Functions getAlert:@"Exito" withMessage:@"Se ha agregado el partido exitosamente." withActions:actions];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        if([self.nombrePartido.text isEqualToString:@""]){
            UIAlertController *alert = [Functions getAlert:@"Error" withMessage:@"Debes indicar un nombre al partido"];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            UIAlertController *alert = [Functions getAlert:@"Error" withMessage:@"Debes seleccionar dos equipos"];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

- (void) mostrarPicker:(int) equipoBoton{
    RMActionControllerStyle style = RMActionControllerStyleWhite;
    
    RMAction<UIPickerView *> *selectAction = [RMAction<UIPickerView *> actionWithTitle:@"Seleccionar" style:RMActionStyleDone andHandler:^(RMActionController<UIPickerView *> *controller) {
        
        // Selecciono un equipo exitosamente
        FIRDataSnapshot *snapshot = _equipos[[controller.contentView selectedRowInComponent:0]];
        NSDictionary *equipo = snapshot.value;
        
        if(equipoBoton == 1){
            self.rowEquipo1Selected = [controller.contentView selectedRowInComponent:0];
            if(self.rowEquipo1Selected == self.rowEquipo2Selected){
                UIAlertController *alert = [Functions getAlert:@"Error" withMessage:@"No puedes seleccionar el mismo equipo casa que el de visita"];
                [self presentViewController:alert animated:YES completion:nil];
            } else {
                [self.botonEquipo1 setTitle:equipo[@"nombre"] forState:UIControlStateNormal];
                [self.botonEquipo1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        } else {
            self.rowEquipo2Selected = [controller.contentView selectedRowInComponent:0];
            
            if(self.rowEquipo1Selected == self.rowEquipo2Selected){
                UIAlertController *alert = [Functions getAlert:@"Error" withMessage:@"No puedes seleccionar el mismo equipo visita que el de casa"];
                [self presentViewController:alert animated:YES completion:nil];
            } else {
                [self.botonEquipo2 setTitle:equipo[@"nombre"] forState:UIControlStateNormal];
                [self.botonEquipo2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
    }];
    
    RMAction<UIPickerView *> *cancelAction = [RMAction<UIPickerView *> actionWithTitle:@"Cancelar" style:RMActionStyleCancel andHandler:^(RMActionController<UIPickerView *> *controller) {
        NSLog(@"Row selection was canceled");
    }];
    
    RMPickerViewController *pickerController = [RMPickerViewController actionControllerWithStyle:style];
    pickerController.picker.dataSource = self;
    pickerController.picker.delegate = self;
    
    [pickerController addAction:selectAction];
    [pickerController addAction:cancelAction];
    
    // Default
    if(equipoBoton == 1){
        pickerController.message = @"Seleccione el equipo casa del partido";
        [pickerController.picker selectRow:self.rowEquipo1Selected inComponent:0 animated:NO];
    } else {
        pickerController.message = @"Seleccione el equipo visita del partido";
        [pickerController.picker selectRow:self.rowEquipo2Selected inComponent:0 animated:NO];
    }
    
    //You can enable or disable blur, bouncing and motion effects
    pickerController.disableBouncingEffects = NO;
    pickerController.disableMotionEffects = NO;
    pickerController.disableBlurEffects =  NO;
    
    //Now just present the picker view controller using the standard iOS presentation method
    [self presentViewController:pickerController animated:YES completion:nil];
}

@end
