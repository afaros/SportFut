//
//  AppDelegate.h
//  SportFut
//
//  Created by Info Pixlab on 17/5/17.
//  Copyright © 2017 Pixlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Functions : NSObject

+ (void) redondearView:(UIView* ) view Color:(NSString *) colorBorde Borde:(CGFloat) anchoBorde Radius:(CGFloat) radius;
+ (UIColor*) colorWithHexString:(NSString*)hex;
+ (UIAlertController *) getAlert:(NSString *)nib withTitle:(NSString *)title withMessage:(NSString *)message withActions:(NSArray *)actions;
+ (UIAlertController *) getAlert:(NSString *)title withMessage:(NSString *)message withActions:(NSArray *)actions;
+ (UIAlertController *) getAlert:(NSString *)title withMessage:(NSString *)message;

@end
