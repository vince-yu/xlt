//
//  NSArray+GH.m
//  Field
//
//  Created by 赵治玮 on 2017/11/8.
//  Copyright © 2017年 赵治玮. All rights reserved.
//  gitHub:https://github.com/shabake/GHDropMenuDemo

#import "NSArray+Bounds.h"

@implementation NSArray (Bounds)

- (id)by_ObjectAtIndex:(NSUInteger)index {
    if (self.count > index) {
        return [self objectAtIndex:index];
    } else {
        return nil;
    }
}
@end
@implementation NSMutableArray (Bounds)
- (void )by_AddObject:(id )object {
    if (object && [object isKindOfClass:[NSObject class]]) {
        [self addObject:object];
    } else {
        
    }
}
- (void)by_removeObjectAtIndex:(NSUInteger )index{
    if (index < self.count) {
        [self removeObjectAtIndex:index];
    }
}
@end
