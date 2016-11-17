//
//  UtilityClass.h
//  Surveys
//
//  Created by Apple on 16/11/16.
//  Copyright © 2016 Nimbl3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UtilityClass : NSObject
+(UIBarButtonItem*)barbuttonItemWithImage:(NSString*)image Target:(id)target action:(SEL)action;
+(UIBarButtonItem*)rightBarbuttonItemWithImage:(NSString*)image Target:(id)target action:(SEL)action;
+(NSString*)getValidString:(NSString*)inputString;
+(bool)isNetworkAvailable;
@end
