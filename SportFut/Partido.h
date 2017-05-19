//
//  Partido.h
//  SportFut
//
//  Created by Info Pixlab on 17/5/17.
//  Copyright © 2017 Pixlab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Partido : NSObject

@property(strong, nonatomic) NSString *pNombre;
@property(strong, nonatomic) NSString *pEquipo1;
@property(strong, nonatomic) NSString *pEquipo2;
@property(strong, nonatomic) NSString *pGolesEquipo1;
@property(strong, nonatomic) NSString *pGolesEquipo2;
@property(strong, nonatomic) NSString *pColorEquipo1;
@property(strong, nonatomic) NSString *pColorEquipo2;

- (instancetype)initWithNombre:(NSString *) nombre
                  andEquipo1:(NSString *) equipo1
                  andEquipo2:(NSString *) equipo2
                  andGolesEquipo1:(NSString *) golesEquipo1
                  andGolesEquipo2:(NSString *) golesEquipo2
                  andColorEquipo1:(NSString *) colorEquipo1
                  andColorEquipo2:(NSString *) colorEquipo2;

@end
