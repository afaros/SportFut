//
//  Functions.m
//  SportFut
//
//  Created by Info Pixlab on 17/5/17.
//  Copyright © 2017 Pixlab. All rights reserved.
//

#import "Functions.h"

@implementation Functions

+ (void) redondearView:(UIView* ) view Color:(NSString *) colorBorde Borde:(CGFloat) anchoBorde Radius:(CGFloat) radius
{
    view.layer.cornerRadius = radius;
    view.clipsToBounds = YES;
    view.layer.borderColor = [[Functions colorWithHexString:colorBorde] CGColor];
    view.layer.borderWidth = anchoBorde;
}

+ (UIColor*) colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+ (UIAlertController *) getAlert:(NSString *)nib withTitle:(NSString *)title withMessage:(NSString *)message withActions:(NSArray *)actions {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (actions != nil)
    {
        for (UIAlertAction *action in actions)
        {
            [alert addAction:action];
        }
    }
    
    return alert;
}

+ (UIAlertController *) getAlert:(NSString *)title withMessage:(NSString *)message withActions:(NSArray *)actions {
    return [self getAlert:@"Message" withTitle:title withMessage:message withActions:actions];
}

+ (UIAlertController *) getAlert:(NSString *)title withMessage:(NSString *)message {
    UIAlertAction *btnAceptar = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
    }];
    
    NSArray *actions = [[NSArray alloc] initWithObjects:btnAceptar, nil];
    
    return [self getAlert:title withMessage:message withActions:actions];
}

@end
