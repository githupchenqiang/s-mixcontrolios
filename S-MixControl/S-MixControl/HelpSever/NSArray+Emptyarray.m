//
//  NSArray+Emptyarray.m
//  S-MixControl
//
//  Created by chenq@kensence.com on 15/12/17.
//  Copyright © 2015年 KaiXingChuangDa. All rights reserved.
//

#import "NSArray+Emptyarray.h"
#import "SignalViewController.h"

@implementation NSArray (Emptyarray)
- (id)ObjectIndex:(NSUInteger)index
{
    if (index >= [self count]) {
        return nil;
        
    }
    id value = [self objectAtIndex:index];
    if (value == [NSNull null]) {
        return nil;
    }
    return value;
 
}

@end
