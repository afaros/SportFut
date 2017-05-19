//
//  Partido.h
//  SportFut
//
//  Created by Info Pixlab on 17/5/17.
//  Copyright © 2017 Pixlab. All rights reserved.
//


#import "Partido.h"

@implementation Partido

- (instancetype)init {
    return [self initWithNombre:@"" andEquipo1:@"" andEquipo2:@"" andGolesEquipo1:@"" andGolesEquipo2:@"" andColorEquipo1:@"" andColorEquipo2:@""];
}

- (instancetype)initWithNombre:(NSString *) nombre
                    andEquipo1:(NSString *) equipo1
                    andEquipo2:(NSString *) equipo2
               andGolesEquipo1:(NSString *) golesEquipo1
               andGolesEquipo2:(NSString *) golesEquipo2
               andColorEquipo1:(NSString *) colorEquipo1
               andColorEquipo2:(NSString *) colorEquipo2{
    self = [super init];
    if (self) {
        self.pNombre = nombre;
        self.pEquipo1 = equipo1;
        self.pEquipo2 = equipo2;
        self.pGolesEquipo1 = golesEquipo1;
        self.pGolesEquipo2 = golesEquipo2;
        self.pColorEquipo1 = colorEquipo1;
        self.pColorEquipo2 = colorEquipo2;
    }
    return self;
}
@end
