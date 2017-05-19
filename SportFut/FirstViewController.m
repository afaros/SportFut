//
//  FirstViewController.m
//  SportFut
//
//  Created by Info Pixlab on 17/5/17.
//  Copyright © 2017 Pixlab. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@property (strong, nonatomic) NSMutableArray<FIRDataSnapshot *> *equipos;
@property (strong, nonatomic) FIRDatabaseQuery *postRef;

@end

@implementation FirstViewController

FIRDatabaseHandle _refHandle;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // [START create_database_reference]
    self.ref = [[FIRDatabase database] reference];
    // [END create_database_reference]
    
    FIRDatabaseReference *ref = [FIRDatabase database].reference;
    self.postRef = [[ref child:@"equipos"] queryOrderedByChild:@"nombre"];
    self.equipos = [[NSMutableArray alloc] init];
    UINib *nib = [UINib nibWithNibName:@"equipoCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"equipo_cell"];
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
    // Listen for deleted club in the Firebase database
    [_postRef
     observeEventType:FIRDataEventTypeChildRemoved
     withBlock:^(FIRDataSnapshot *snapshot) {
         int index = [self indexOfMessage:snapshot];
         [self.equipos removeObjectAtIndex:index];
     }];
    // [END child_event_listener]
    
    // [START post_value_event_listener]
    _refHandle = [_postRef observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        [self.tableView reloadData];
    }];
    // [END post_value_event_listener]
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.postRef removeObserverWithHandle:_refHandle];
    [self.postRef removeAllObservers];
}

- (int) indexOfMessage:(FIRDataSnapshot *)snapshot {
    int index = 0;
    for (FIRDataSnapshot *comment in _equipos) {
        if ([snapshot.key isEqualToString:comment.key]) {
            return index;
        }
        ++index;
    }
    return -1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.equipos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FIRDataSnapshot *snapshot = _equipos[indexPath.row];
    NSDictionary *equipo = snapshot.value;
    NSString *cod = snapshot.key;
    
    Equipo *newEquipo = [[Equipo alloc] initWithEid:cod andNombre:equipo[@"nombre"] andColor:equipo[@"color"]];
    static NSString *simpleTableIdentifier = @"equipo_cell";
    equipoCell *cell = (equipoCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"equipoCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.nombreEquipo.text = newEquipo.eNombre;
    cell.viewEquipo.backgroundColor = [Functions colorWithHexString:newEquipo.eColor];
    [Functions redondearView:cell.viewEquipo Color:newEquipo.eColor Borde:0 Radius:15];

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Implementar eliminar equipo
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"Eliminar";
}
@end
