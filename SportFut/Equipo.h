//
//  Equipo.h
//  SportFut
//
//  Created by Info Pixlab on 17/5/17.
//  Copyright © 2017 Pixlab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Equipo : NSObject

@property(strong, nonatomic) NSString *eId;
@property(strong, nonatomic) NSString *eNombre;
@property(strong, nonatomic) NSString *eColor;

- (instancetype)initWithEid:(NSString *) eid
                  andNombre:(NSString *) nombre andColor:(NSString *) color;

@end
