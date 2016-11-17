//
//  SurveyObject.h
//  Surveys
//
//  Created by Apple on 17/11/16.
//  Copyright © 2016 Nimbl3. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  Model Class to store surveys data
 */
@interface SurveyObject : NSObject
@property (strong, nonatomic) NSString* surveyTitle;
@property (strong, nonatomic) NSString* surveyDescription;
@property (strong, nonatomic) NSString* surveyCoverImageUrl;
-(id)initWithSurveyObject:(NSDictionary*)surveyDictionary;
@end
