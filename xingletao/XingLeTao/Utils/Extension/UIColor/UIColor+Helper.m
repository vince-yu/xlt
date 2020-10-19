//
//  UIColor+Helper.m
//  Lianbo
//
//  Created by Kai on 2/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIColor+Helper.h"

UIColor *UIColorMakeRGB(CGFloat red, CGFloat green, CGFloat blue)
{
	return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1.0f];
}

UIColor *UIColorMakeRGBA(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha)
{
	return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
}

@implementation UIColor (Helper)

+ (UIColor *)colorWithHex:(int)hex {
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0
                           green:((float)((hex & 0xFF00) >> 8))/255.0
                            blue:((float)(hex & 0xFF))/255.0 alpha:1.0];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString
{
    NSScanner *scanner = [[NSScanner alloc] initWithString:hexString];
    unsigned int hex = 0;
    [scanner scanHexInt:&hex];    
    return [UIColor colorWithHex:hex];
}

@end
