//
//  SurveysViewModel.m
//  Surveys
//
//  Created by Apple on 23/11/16.
//  Copyright © 2016 Nimbl3. All rights reserved.
//

#import "SurveysViewModel.h"
#import "SurveyObject.h"

@implementation SurveysViewModel

+ (NSMutableArray*)getSurveysViewModelData:(NSArray*)surveysJsonResponse
{
    NSMutableArray* surveysMutableArray = [NSMutableArray new];

    for(int i = 0; i < surveysJsonResponse.count; i++)
    {
        if (surveysJsonResponse[i] != (id)[NSNull null])
        {
            SurveyObject *surveyObj = [[SurveyObject alloc] initWithSurveyObject:surveysJsonResponse[i]];
            [surveysMutableArray addObject:surveyObj];
        }
    }
    
    return surveysMutableArray;
    
}
@end
