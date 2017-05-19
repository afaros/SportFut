//
//  partidoCell.h
//  SportFut
//
//  Created by Info Pixlab on 17/5/17.
//  Copyright © 2017 Pixlab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface partidoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *tituloPartido;
@property (weak, nonatomic) IBOutlet UILabel *nombreEquipo1;
@property (weak, nonatomic) IBOutlet UILabel *golesEquipo1;
@property (weak, nonatomic) IBOutlet UILabel *nombreEquipo2;
@property (weak, nonatomic) IBOutlet UILabel *golesEquipo2;
@property (weak, nonatomic) IBOutlet UIView *viewEquipo1;
@property (weak, nonatomic) IBOutlet UIView *viewEquipo2;

@end
