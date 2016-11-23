//
//  SurveysViewController.h
//  Surveys
//
//  Created by Apple on 16/11/16.
//  Copyright © 2016 Nimbl3. All rights reserved.
//

#import "SurveysViewController.h"
#import "TakeTheSurveyViewController.h"
#import "UIScrollView+ScrollIndicator.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SurveyObject.h"
#import "UtilityClass.h"
#import "Constants.h"
#import "APIRequestManager.h"
#import "SurveysViewModel.h"

@interface SurveysViewController () <UIScrollViewDelegate>

/*!
 *  Surveys array - To store surveys json response
 */
@property (nonatomic, strong) NSMutableArray *surveysArray;

@property (nonatomic, strong) UIActivityIndicatorView *spinner;

/*!
 *  currentPageNumber - To maintain the state of the current page
 */
@property (nonatomic, strong) NSNumber *currentPageNumber;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *surveyImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *noInternetLabel;
@property (weak, nonatomic) IBOutlet UIButton *takeTheSurveyButton;

-(IBAction)takeTheSurveyButtonTapped:(id)sender;

@end

@implementation SurveysViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /*!
     *  Setup initial frames and font sizes for UIControls
     */
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:KSURVEYCOUNT];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    /*!
     *  Whenever user swipes up or down get notification with page number
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageIndicatorChanged:) name:@"PageIndicatorChanged" object:nil];
    
    /*!
     *  Setup initial frames and font sizes for UIControls
     */
    [self setupInitialUIControls];
    
    /*!
     *  Call webservice to get surveys data
     */
    [self getSurveysData];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.title = @"SURVEYS";
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.spinner.center = self.view.center;
    
    /*!
     *  Update ImageView and ScrollView frame dynamically
     */
    self.surveyImageView.frame = CGRectMake(0, self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - (self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height));
    self.scrollView.frame = CGRectMake(0, self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - (self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height));
    
    /*!
     *  Update page indicator view frame dynamically
     */
    [self.scrollView refreshCustomScrollIndicatorsWithAlpha:0.0];
    [self.scrollView enableCustomScrollIndicatorsWithScrollIndicatorType:JMOScrollIndicatorTypePageControl positions:JMOVerticalScrollIndicatorPositionRight color:[UIColor whiteColor]];
    [self changeCurrentPage:[self.currentPageNumber intValue]];
    [self.scrollView refreshCustomScrollIndicatorsWithAlpha:1.0];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Handling UI

- (void)setupInitialUIControls
{
    self.navigationItem.leftBarButtonItem = [UtilityClass barbuttonItemWithImage:@"Refresh" Target:self action:@selector(leftBarButtonTapped)];
    self.navigationItem.rightBarButtonItem = [UtilityClass barbuttonItemWithImage:@"Hamburger" Target:self action:@selector(rightBarButtonTapped)];

    self.scrollView.delegate = self;
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height*3)];
    
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinner.center = self.view.center;
    [self.view addSubview:self.spinner];

    /*!
     *  Update font size dynamically based on screen hight
     */
    self.takeTheSurveyButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:[UIScreen mainScreen].bounds.size.height * 0.02992957746];
    self.takeTheSurveyButton.layer.cornerRadius = self.takeTheSurveyButton.frame.size.height/2;
    self.takeTheSurveyButton.layer.masksToBounds = YES;
    self.nameLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:[UIScreen mainScreen].bounds.size.height * 0.03169014085];
    self.descriptionLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:[UIScreen mainScreen].bounds.size.height * 0.0264084507];

}

-(void)hideCurrentViewControls
{
    self.surveyImageView.hidden = YES;
    self.scrollView.hidden = YES;
    self.nameLabel.hidden = YES;
    self.descriptionLabel.hidden = YES;
    self.takeTheSurveyButton.enabled = NO;
    
}

-(void)unHideCurrentViewControls
{
    self.surveyImageView.hidden = NO;
    self.scrollView.hidden = NO;
    self.nameLabel.hidden = NO;
    self.descriptionLabel.hidden = NO;
    self.takeTheSurveyButton.enabled = YES;
    
}

/**
 *  Change survey's data based on current page
 *
 *  @param pageNumber - index of surveys array
 */
-(void)changeCurrentPage:(int)pageNumber
{
    if(self.surveysArray.count > 0 && self.surveysArray.count > pageNumber)
    {
        SurveyObject *surveyObj = self.surveysArray[pageNumber];
        
        NSURL *url;
        
        //iPad                                                      //iPhone 6 Plus, 6S Plus, 7 Plus
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad || [UIScreen mainScreen].bounds.size.width > 375)
        {
            /**
             *  To get the high resolution image appended “l” to the image url.
             */
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@l",surveyObj.surveyCoverImageUrl]];
        }
        else
        {
            url = [NSURL URLWithString:surveyObj.surveyCoverImageUrl];
        }
        
        /**
         *
         *  SDWebImage - It is a 3rd party library, which helps download images from the url and to store those images in the cache.
         */
        [self.surveyImageView sd_setImageWithURL:url
                                    placeholderImage:[UIImage imageNamed:@""]
                                             options:SDWebImageRefreshCached];
        
        self.nameLabel.text = surveyObj.surveyTitle;
        self.descriptionLabel.text = surveyObj.surveyDescription;
        
        self.currentPageNumber = [NSNumber numberWithInt:pageNumber];
    }
    
    
}

#pragma mark - API Interaction

- (void)getSurveysData
{
    if([UtilityClass isNetworkAvailable])//Check internet connection
    {
        [self.spinner startAnimating];
        self.noInternetLabel.hidden = YES;
        
        
        [APIRequestManager PostWithUrl:[NSString stringWithFormat:@"%@?access_token=%@",KUSAYSERVERENDPOINT,KUSAYSERVERACCESSTOKEN] Parameters:nil success:^(id json)
        {
            if([json isKindOfClass:[NSArray class]])
            {
                
                self.surveysArray = [SurveysViewModel getSurveysViewModelData:json];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    /*!
                     *  KSURVEYCOUNT - Store json respone count, which helps to display page indicators
                     *
                     */
                    [[NSUserDefaults standardUserDefaults] setInteger:self.surveysArray.count forKey:KSURVEYCOUNT];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    //update UI in main thread
                    
                    [self unHideCurrentViewControls];
                    
                    [self.scrollView enableCustomScrollIndicatorsWithScrollIndicatorType:JMOScrollIndicatorTypePageControl positions:JMOVerticalScrollIndicatorPositionRight color:[UIColor whiteColor]];
                    [self changeCurrentPage:0];
                    [self.scrollView refreshCustomScrollIndicatorsWithAlpha:1.0];
                    
                    [self.spinner stopAnimating];
                    
                    
                });
            }
            
        } failure:^(NSError *error)
        {
            
        }];
        
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No internet connection"
                                                        message:@"Please check the internet connection."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.noInternetLabel.hidden = NO;
    [self hideCurrentViewControls];
}

#pragma mark - UIButton Actions

-(void)leftBarButtonTapped
{
    [self.scrollView disableCustomScrollIndicator];
    [self.scrollView refreshCustomScrollIndicatorsWithAlpha:0.0];

    [self hideCurrentViewControls];
    [self getSurveysData];
}

-(void)rightBarButtonTapped
{
    
    
}

-(IBAction)takeTheSurveyButtonTapped:(id)sender
{
    TakeTheSurveyViewController* takeTheSurveyView = [self.storyboard instantiateViewControllerWithIdentifier:@"TakeTheSurveyViewController"];
    [self.navigationController pushViewController:takeTheSurveyView animated:YES];

}


/*!
 *  Received notification from scrollView Category
 *
 *  notification - Contains page number
 */
-(void)pageIndicatorChanged:(NSNotification *)notification
{
    self.currentPageNumber = notification.object;
    
    [self changeCurrentPage:[self.currentPageNumber intValue]];
    
}

@end
