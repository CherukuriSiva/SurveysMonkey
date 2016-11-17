//
//  UtilityClass.m
//  Surveys
//
//  Created by Apple on 16/11/16.
//  Copyright © 2016 Nimbl3. All rights reserved.
//

#import "UtilityClass.h"
#import <SystemConfiguration/SCNetworkReachability.h>

@implementation UtilityClass

+(UIBarButtonItem*)barbuttonItemWithImage:(NSString*)image Target:(id)target action:(SEL)action
{
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:image]
                                                             style:UIBarButtonItemStylePlain
                                                            target:target
                                                            action:action];
    return item;
}

+(UIBarButtonItem*)rightBarbuttonItemWithImage:(NSString*)image Target:(id)target action:(SEL)action
{
    UIImage *barButtonimage =[UIImage imageNamed:image];
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithImage:barButtonimage
                                                             style:UIBarButtonItemStylePlain
                                                            target:target
                                                            action:action];
    return item;
}

+(NSString*)getValidString:(NSString*)inputString
{
    if ([inputString isKindOfClass:[NSString class]] && [inputString length] > 1) {
        return inputString;
    }else{
        return @"";
    }
}

+(bool)isNetworkAvailable
{
    SCNetworkReachabilityFlags flags;
    SCNetworkReachabilityRef address;
    address = SCNetworkReachabilityCreateWithName(NULL,"www.google.com" );
    Boolean success = SCNetworkReachabilityGetFlags(address, &flags);
    CFRelease(address);
    
    bool canReach = success
    && !(flags & kSCNetworkReachabilityFlagsConnectionRequired)
    && (flags & kSCNetworkReachabilityFlagsReachable);
    
    return canReach;
}
@end
