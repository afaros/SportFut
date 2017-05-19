//
//  Equipo.h
//  SportFut
//
//  Created by Info Pixlab on 17/5/17.
//  Copyright © 2017 Pixlab. All rights reserved.
//


#import "Equipo.h"

@implementation Equipo

- (instancetype)init {
    return [self initWithEid:@"" andNombre:@"" andColor:@""];
}

- (instancetype)initWithEid:(NSString *) eid
                  andNombre:(NSString *) nombre
                   andColor:(NSString *) color{
    self = [super init];
    if (self) {
        self.eId = eid;
        self.eNombre = nombre;
        self.eColor = color;
    }
    return self;
}
@end
