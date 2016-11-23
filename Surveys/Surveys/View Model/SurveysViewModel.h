//
//  SurveysViewModel.h
//  Surveys
//
//  Created by Apple on 23/11/16.
//  Copyright © 2016 Nimbl3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SurveysViewModel : NSObject
+ (NSMutableArray*)getSurveysViewModelData:(NSArray*)surveysJsonResponse;
@end
