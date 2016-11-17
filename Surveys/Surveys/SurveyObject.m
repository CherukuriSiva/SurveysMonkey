//
//  SurveyObject.m
//  Surveys
//
//  Created by Apple on 17/11/16.
//  Copyright © 2016 Nimbl3. All rights reserved.
//

#import "SurveyObject.h"
#import "UtilityClass.h"

@implementation SurveyObject

-(id)initWithSurveyObject:(NSDictionary*)surveyDictionary
{
   
    if (self = [super init])
    {
        self.surveyTitle =  [UtilityClass getValidString:surveyDictionary[@"title"]];
        self.surveyDescription = [UtilityClass getValidString:surveyDictionary[@"description"]];
        self.surveyCoverImageUrl = [UtilityClass getValidString:surveyDictionary[@"cover_image_url"]];
        
    }
    return self;
}

@end
