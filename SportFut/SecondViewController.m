//
//  SecondViewController.m
//  SportFut
//
//  Created by Info Pixlab on 17/5/17.
//  Copyright © 2017 Pixlab. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@property (strong, nonatomic) NSMutableArray<FIRDataSnapshot *> *partidos;
@property (strong, nonatomic) FIRDatabaseQuery *postRef;

@end

@implementation SecondViewController

FIRDatabaseHandle _refHandlePartidos;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // [START create_database_reference]
    self.ref = [[FIRDatabase database] reference];
    // [END create_database_reference]
    
    FIRDatabaseReference *ref = [FIRDatabase database].reference;
    _postRef = [ref child:@"partidos"];
    _partidos = [[NSMutableArray alloc] init];
    UINib *nib = [UINib nibWithNibName:@"partidoCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"partido_cell"];
}

- (void)viewWillAppear:(BOOL)animated {
    isSearching = NO;
    [_partidos removeAllObjects];
    // [START child_event_listener]
    // Listen for new club in the Firebase database
    [_postRef
     observeEventType:FIRDataEventTypeChildAdded
     withBlock:^(FIRDataSnapshot *snapshot) {
         [_partidos addObject:snapshot];
     }];
    // Listen for deleted club in the Firebase database
    [_postRef
     observeEventType:FIRDataEventTypeChildRemoved
     withBlock:^(FIRDataSnapshot *snapshot) {
         int index = [self indexOfMessage:snapshot];
         [_partidos removeObjectAtIndex:index];
     }];
    // [END child_event_listener]
    
    // [START post_value_event_listener]
    _refHandlePartidos = [_postRef observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        [self.tableView reloadData];
    }];
    // [END post_value_event_listener]
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.postRef removeObserverWithHandle:_refHandlePartidos];
    [self.postRef removeAllObservers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (int) indexOfMessage:(FIRDataSnapshot *)snapshot {
    int index = 0;
    for (FIRDataSnapshot *comment in _partidos) {
        if ([snapshot.key isEqualToString:comment.key]) {
            return index;
        }
        ++index;
    }
    return -1;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.partidos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FIRDataSnapshot *snapshot = _partidos[indexPath.row];
    NSDictionary *partido = snapshot.value;
    
    Partido *newPartido = [[Partido alloc] initWithNombre:partido[@"nombre"] andEquipo1:partido[@"nombreEquipo1"] andEquipo2:partido[@"nombreEquipo2"] andGolesEquipo1:[NSString stringWithFormat:@"%@", partido[@"golesEquipo1"]] andGolesEquipo2:[NSString stringWithFormat:@"%@", partido[@"golesEquipo2"]] andColorEquipo1:partido[@"colorEquipo1"] andColorEquipo2:partido[@"colorEquipo2"]];
    static NSString *simpleTableIdentifier = @"partido_cell";
    partidoCell *cell = (partidoCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"partidoCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.tituloPartido.text = newPartido.pNombre;
    cell.viewEquipo1.backgroundColor = [Functions colorWithHexString:newPartido.pColorEquipo1];
    [Functions redondearView:cell.viewEquipo1 Color:newPartido.pColorEquipo1 Borde:0 Radius:15];
    cell.viewEquipo2.backgroundColor = [Functions colorWithHexString:newPartido.pColorEquipo2];
    [Functions redondearView:cell.viewEquipo2 Color:newPartido.pColorEquipo2 Borde:0 Radius:15];
    cell.golesEquipo1.text = newPartido.pGolesEquipo1;
    cell.golesEquipo2.text = newPartido.pGolesEquipo2;
    cell.nombreEquipo1.text = newPartido.pEquipo1;
    cell.nombreEquipo2.text = newPartido.pEquipo2;
    
    return cell;
}

#pragma mark - Search Implementation

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    isSearching = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    FIRDatabaseReference *ref = [FIRDatabase database].reference;
    
    if([searchText length] == 0) {
        isSearching = NO;
        _postRef = [ref child:@"partidos"];
        [_partidos removeAllObjects];
    } else {
        isSearching = YES;
        _postRef = [[[ref child:@"partidos"] queryOrderedByChild:@"nombreEquipo1"]queryEqualToValue:searchText];
        
        [_partidos removeAllObjects];
        
        // [START child_event_listener]
        // Listen for new club in the Firebase database
        [_postRef
         observeEventType:FIRDataEventTypeChildAdded
         withBlock:^(FIRDataSnapshot *snapshot) {
             [_partidos addObject:snapshot];
         }];
        
        // [START post_value_event_listener]
        _refHandlePartidos = [_postRef observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            [self.tableView reloadData];
        }];
        
        //_postRef = [[[ref child:@"partidos"] queryOrderedByChild:@"nombreEquipo2"]queryEqualToValue:searchText];
        _postRef = [[[ref child:@"partidos"] queryOrderedByChild:@"nombreEquipo2"]queryEqualToValue:searchText];
    }
    
    // [START child_event_listener]
    // Listen for new club in the Firebase database
    [_postRef
     observeEventType:FIRDataEventTypeChildAdded
     withBlock:^(FIRDataSnapshot *snapshot) {
         [_partidos addObject:snapshot];
     }];
    
    // [START post_value_event_listener]
    _refHandlePartidos = [_postRef observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        [self.tableView reloadData];
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Cancel clicked");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Clicked");
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Antes de ir a agregar limpiamos el buscador
    if ([[segue identifier] isEqualToString:@"agregarPartido"] && isSearching) {
        isSearching = NO;
        _searchTab.text = @"";
        [self searchBar:self.searchTab textDidChange:@""];
    }
}


@end
