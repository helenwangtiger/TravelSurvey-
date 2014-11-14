//
//  SecondViewController.m
//  TxDOT
//
//  Created by Qian on 6/14/13.
//  Copyright (c) 2013 Qian. All rights reserved.
//

#import "SecondViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "HttpSyncCommunication.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

@synthesize questionTitleUsed, questionDescUsed, answerUsed, questionDescHousehold, questionTitleHousehold, answerHousehold, questionDescPerson, questionTitlePerson, answerPerson, questionTitleVehicle, questionDescVehicle, answerVehicle, answerTrip, pickerChoices, questionNumber, totalQuestions, questionTitleLabel, questionDescLabel, answerView, prev, next, text, picker, categoryView, overlayView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Profile", @"Second");
        self.tabBarItem.image = [UIImage imageNamed:@"tabbar_view.png"];
    }
    return self;
}

-(IBAction)hideOverlay {
    overlayView.alpha = 0;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    startPosition = [touch locationInView:self.view];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint endPosition = [touch locationInView:self.view];
    if (startPosition.x < endPosition.x &&  endPosition.x - startPosition.x > 75) {
        [self hideKeyboard];
        [self.view addSubview:categoryView];
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.3];
        [animation setType:kCATransitionReveal];
        [animation setSubtype:kCATransitionFromLeft];
        [[self.view layer] addAnimation:animation forKey:nil];
        [UIView commitAnimations];
    }
}

-(IBAction)closeCategory {
    [self closeMethod];
}

-(void)closeMethod {
    [categoryView removeFromSuperview];
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.3];
    [animation setType:kCATransitionReveal];
    [animation setSubtype:kCATransitionFromRight];
    [[self.view layer] addAnimation:animation forKey:nil];
    [UIView commitAnimations];
}

-(void)saveToDictionary {
    NSString *value = [[NSString alloc] init];
    NSString *key = [[NSString alloc] init];
    NSString *rowKey = [[NSString alloc] init];
    key = answerUsed[questionInt][2];
    NSInteger row;
    if([answerUsed[questionInt][0] isEqualToString:@"1"] || [answerUsed[questionInt][0] isEqualToString:@"3"]) {
        if(text.text==NULL) {
            value = @"";
        }
        else {
            value = text.text;
        }
        rowKey = nil;
    }
    else if([answerUsed[questionInt][0] isEqualToString:@"2"]) {
        row = [picker selectedRowInComponent:0];
        value = [pickerChoices objectAtIndex:row];
        rowKey = [NSString stringWithFormat:@"%@%@",answerUsed[questionInt][2],@"rowKey"];
        NSLog(@"%ld",(long)row);
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"data.plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    [data setObject:value forKey:key];
    if(rowKey != nil) {
        [data setObject:[NSNumber numberWithInteger:row] forKey:rowKey];
    }
    [data writeToFile:path atomically:YES];
    value = nil;
    key = nil;
    rowKey = nil;
}

-(void)readFromDictionary {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"data.plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    if([answerUsed[questionInt][0] isEqualToString:@"1"] || [answerUsed[questionInt][0] isEqualToString:@"3"]) {
        NSString *value = [[NSString alloc] init];
        value = [data objectForKey:answerUsed[questionInt][2]];
        if(value==NULL) {
            value = @"";
        }
        text.text = value;
    }
    else if([answerUsed[questionInt][0] isEqualToString:@"2"]) {
        NSString *value = [[NSString alloc] init];
        NSString *rowKey = [[NSString alloc] initWithFormat:@"%@%@",answerUsed[questionInt][2],@"rowKey"];
        value = [data objectForKey:rowKey];
        NSLog(@"value:%@",value);
        [picker selectRow:[value intValue] inComponent:0 animated:YES];
    }
}

-(IBAction)clickedPrev {
    [self saveToDictionary];
    questionInt--;
    [self questionIntChanged];
    [self checkButtons];
    [self readFromDictionary];
}

-(IBAction)clickedNext {
    [self saveToDictionary];
    questionInt++;
    [self questionIntChanged];
    [self checkButtons];
    [self readFromDictionary];
}

-(IBAction)selectHousehold {
    questionTitleUsed = questionTitleHousehold;
    questionDescUsed = questionDescHousehold;
    answerUsed = answerHousehold;
    [self setTotalText];
    questionInt = 1;
    [self questionIntChanged];
    [self checkButtons];
    [self closeMethod];
    [self readFromDictionary];
}

-(IBAction)selectPerson {
    questionTitleUsed = questionTitlePerson;
    questionDescUsed = questionDescPerson;
    answerUsed = answerPerson;
    [self setTotalText];
    questionInt = 1;
    [self questionIntChanged];
    [self checkButtons];
    [self closeMethod];
    [self readFromDictionary];
}

-(IBAction)selectVehicle {
    questionTitleUsed = questionTitleVehicle;
    questionDescUsed = questionDescVehicle;
    answerUsed = answerVehicle;
    [self setTotalText];
    questionInt = 1;
    [self questionIntChanged];
    [self checkButtons];
    [self closeMethod];
    [self readFromDictionary];
}

-(IBAction)submit {
    [self saveToDictionary];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"data.plist"];
    NSMutableDictionary *dataSubmit = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    NSLog(@"count: %lu",(unsigned long)[dataSubmit count]);
    NSString *sample_number = [[NSUserDefaults standardUserDefaults]stringForKey:@"sample_number"];
    NSString *address = [[NSUserDefaults standardUserDefaults] stringForKey:@"address"];
    NSLog(@"sample_number and home address is %@,%@,",sample_number,address);
    [dataSubmit setObject:sample_number forKey:@"sample_number"];
    [dataSubmit setObject:address forKey:@"address"];
    [dataSubmit setObject:@"insertGeneral" forKey:@"actionType"];
    HttpSyncCommunication* singleHttp = [HttpSyncCommunication singleHttpSync];
    [singleHttp sendHTTPRequest:dataSubmit];
    
    
    


}

-(void)checkButtons {
    if(questionInt==1) {
        [prev setUserInteractionEnabled:NO];
        [next setUserInteractionEnabled:YES];
        
    }
    //the last question
    else if(questionInt==questionTitleUsed.count-1) {
        [prev setUserInteractionEnabled:YES];
        [next setUserInteractionEnabled:NO];
    }
    else {
        [prev setUserInteractionEnabled:YES];
        [next setUserInteractionEnabled:YES];
    }
    
}

-(void)setTotalText {
    totalQuestions.text = [NSString stringWithFormat:@"%u",[questionTitleUsed count]-1];
}

-(void)questionIntChanged {
    questionNumber.text = [NSString stringWithFormat:@"%d",questionInt];
    totalQuestions.text = [NSString stringWithFormat:@"%u",[questionTitleUsed count]-1];
    questionTitleLabel.text = questionTitleUsed[questionInt];
    questionDescLabel.text = questionDescUsed[questionInt];
    [self generateAnswers];
}

-(void)generateAnswers {
    NSArray *viewsToRemove = [answerView subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    text = nil;
    picker = nil;
    //if it is a text field
    if([answerUsed[questionInt][0] isEqualToString:@"1"]) {
        
        text = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, 250, 35)];
        text.borderStyle = UITextBorderStyleRoundedRect;
        text.font = [UIFont systemFontOfSize:18];
        text.placeholder = @"enter text";
        text.autocorrectionType = UITextAutocorrectionTypeNo;
        text.keyboardType = UIKeyboardTypeDefault;
        text.returnKeyType = UIReturnKeyDone;
        [text addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
        text.clearButtonMode = UITextFieldViewModeWhileEditing;
        text.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [answerView addSubview:text];
    }
    //if it is a picker
    else if([answerUsed[questionInt][0] isEqualToString:@"2"]) {
        int numberElements = (int)[answerUsed[questionInt][1] count];
        pickerChoices = nil;
        pickerChoices = [[NSMutableArray alloc] init];
        for(int i=0;i<numberElements;i++) {
            [pickerChoices addObject:answerUsed[questionInt][1][i]];
        }
        [answerView setFrame:CGRectMake(10, 190, 300, 200)];
        picker = [[UIPickerView alloc] initWithFrame:CGRectMake(10,10,280,140)];
        picker.delegate = self;
        picker.dataSource = self;
        picker.showsSelectionIndicator = YES;
        picker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [answerView addSubview:picker];
        
       // [picker selectRow:2 inComponent:0 animated:YES];
    }

    else if([answerUsed[questionInt][0] isEqualToString:@"3"]) {
        text = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, 250, 35)];
        text.borderStyle = UITextBorderStyleRoundedRect;
        text.font = [UIFont systemFontOfSize:18];
        text.placeholder = @"enter text";
        text.autocorrectionType = UITextAutocorrectionTypeNo;
        text.keyboardType = UIKeyboardTypeNumberPad;
        text.returnKeyType = UIReturnKeyDone;
        [text addTarget:self action:@selector(textFieldFinished:)forControlEvents:UIControlEventEditingDidEndOnExit];
        text.clearButtonMode = UITextFieldViewModeWhileEditing;
        text.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [answerView addSubview:text];
    }

}

- (IBAction)textFieldFinished:(id)sender
{
    [sender resignFirstResponder];
}

-(void) hideKeyboard {
    [text resignFirstResponder];
    [self saveToDictionary];
}
-(void)viewDidAppear:(BOOL)animated{
    CGSize screensize= [[UIScreen mainScreen]bounds].size;
    if (screensize.height<500) {
        [answerView setFrame:CGRectMake(10, 180, 300, 200)];
        [prev setFrame:CGRectMake(20, 375, 89, 30)];
        [next setFrame:CGRectMake(210, 375, 89, 30)];
       
    }
    if (screensize.height >500) {
        [prev setFrame:CGRectMake(20, 443, 89, 40)];
        [next setFrame:CGRectMake(210, 443, 89, 40)];
    }
}

- (void)viewDidLoad
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"data.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:path]) {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath:path error:nil];
    }
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    
    questionInt = 1;
    
    questionTitleHousehold = [[NSArray alloc] initWithObjects:
                              @"",
                              @"Record TYPE 1- Household Information",
                              @"Record TYPE 1- Household Information",
                              @"Record TYPE 1- Household Information",///////////// 5
                              @"Record TYPE 1- Household Information",
                              @"Record TYPE 1- Household Information",
                              @"Record TYPE 1- Household Information",
                              @"Record TYPE 1- Household Information",
                              @"Record TYPE 1- Household Information",//////10
                              @"Record TYPE 1- Household Information",
                              @"Record TYPE 1- Household Information",
                              @"Record TYPE 1- Household Information",
                              @"Record TYPE 1- Household Information",
                              @"Record TYPE 1- Household Information",//////////////  15
                              @"Record TYPE 1- Household Information",
                              @"Record TYPE 1- Household Information",
                              @"Record TYPE 1- Household Information",
                              @"Record TYPE 1- Household Information",
                              @"Record TYPE 1- Household Information",////// 20
                              @"Record TYPE 1- Household Information",
                              @"Record TYPE 1- Household Information",
                              @"Record TYPE 1- Household Information",
                              @"Record TYPE 1- Household Information",
                              @"Record TYPE 1- Household Information", ////25 TYPE1
                 
    nil];
    questionTitlePerson = [[NSArray alloc] initWithObjects:
                           @"",
                           @"Record TYPE 2- Person Information",////////// Type 2 26
                           @"Record TYPE 2- Person Information",
                           @"Record TYPE 2- Person Information",
                           @"Record TYPE 2- Person Information",
                           @"Record TYPE 2- Person Information",///30
                           @"Record TYPE 2- Person Information",
                           @"Record TYPE 2- Person Information",
                           @"Record TYPE 2- Person Information",
                           @"Record TYPE 2- Person Information",
                           @"Record TYPE 2- Person Information",//35
                           @"Record TYPE 2- Person Information",
                           @"Record TYPE 2- Person Information",
                           @"Record TYPE 2- Person Information",
                           @"Record TYPE 2- Person Information",
                           @"Record TYPE 2- Person Information",///40
                           @"Record TYPE 2- Person Information",
                           @"Record TYPE 2- Person Information",
                           @"Record TYPE 2- Person Information",
                           @"Record TYPE 2- Person Information",
                           @"Record TYPE 2- Person Information",//////45
                           @"Record TYPE 2- Person Information",
                           @"Record TYPE 2- Person Information",
                           @"Record TYPE 2- Person Information",
                           @"Record TYPE 2- Person Information",
                           @"Record TYPE 2- Person Information",//50
                           @"Record TYPE 2- Person Information",
                           @"Record TYPE 2- Person Information",
                           @"Record TYPE 2- Person Information",
                           @"Record TYPE 2- Person Information",
                           @"Record TYPE 2- Person Information",////55
                           @"Record TYPE 2- Person Information",
                           @"Record TYPE 2- Person Information",
                           @"Record TYPE 2- Person Information",
                           @"Record TYPE 2- Person Information",
                           @"Record TYPE 2- Person Information",////60
                           @"Record TYPE 2- Person Information",
                           @"Record TYPE 2- Person Information",
                           @"Record TYPE 2- Person Information",
                           @"Record TYPE 2- Person Information",
                           @"Record TYPE 2- Person Information",
                           @"Record TYPE 2- Person Information",////66 End  //////////////////Record Type 2
    nil];
    questionTitleVehicle = [[NSArray alloc] initWithObjects:
                            @"",
                            @"Record TYPE 3- Vehicle Information", ////67
                            @"Record TYPE 3- Vehicle Information",
                            @"Record TYPE 3- Vehicle Information",
                            @"Record TYPE 3- Vehicle Information",///70
                            @"Record TYPE 3- Vehicle Information",
                            @"Record TYPE 3- Vehicle Information",
                            @"Record TYPE 3- Vehicle Information",
                            @"Record TYPE 3- Vehicle Information",
                            @"Record TYPE 3- Vehicle Information",///75
                            @"Record TYPE 3- Vehicle Information",
                            @"Record TYPE 3- Vehicle Information",
                            @"Record TYPE 3- Vehicle Information",
                            @"Record TYPE 3- Vehicle Information",
                            @"Record TYPE 3- Vehicle Information",///80
                            @"Record TYPE 3- Vehicle Information",// 81///////////Record Type 3

    nil];
      questionDescHousehold = [[NSArray alloc] initWithObjects:
                               @"",
                               @"What is your phone number?",
                               @"Do you receive an advance letter?",
                               @"How many persons are living in the household?", /////5
                               @"How many persons who are living in the household are employed?",
                               @"How many vehicles does your household own? (If you don't know, please enter 98. If you prefer not to answer,please enter 99)",
                               @"How many vehicles are Owned/Leased? (If you don't know, please enter 98. If you prefer not to answer,please enter 99)",
                               @"How many bikes does your household own? (If you don't know, please enter 98. If you prefer not to answer,please enter 99)",
                               @"What is your residence type?",////10
                               @"If your resident type was not in the previous list, please type it here.",
                               @"How many years have you been living at your current residence?",
                               @"If you currently live here less than five years, what is your previous residence address? If none, please indicate so.",
                               @"Which of the factors below influenced your decisions to currently live here?",
                               @"Please list any other factors that were not on the list in question 14.", ///15
                               @"What is your household income?",
                               @"How many people visited your residence on the travel day? (If you don't know, please enter 98.  If you prefer not to answer,please enter 99)",
                               @"How many overnight visitors were in your household during the travel day? (If you don't know, please enter 98. If you prefer not to answer,please enter 99)",
                               @"Is there someone at your residence driving a form of delivery vehicle?",
                               @"How many persons in your household are delivery drivers as part of their work?",////20
                               @"How many times has your household lacked phone service within past 12 months?",
                               @"What is the average length of time your household has been without phone service?",
                               @"Is there one or more of household vehicles that were used by a non-household member on the travel day?",
                               @"How many households share a phone line with yours?",
                               @"How many household members used smartphones on the travel day?", ///25
                    
            nil];
    questionDescPerson = [[NSArray alloc] initWithObjects:
                          @"",
                          @"What is your relationship to the head of household?",////////1Type 2
                          @"What is your gender?",
                          @"What is your ethnicity?",
                          @"If your ethnicity was not listed in question 3, please type it here.",//////????????????
                          @"What is your age? (If you don't know, please enter 998. If you prefer not to answer,please enter 999)", ////5
                          @"Are you a Licensed Driver?",
                          @"Are you an employed person with a paying or volunteer job?",
                          @"What is your employment status?",
                          @"How many hours do you work per week on average?（If you don't know,please enter 998.If varies from week to week, please enter 999.)",
                          @"What is your reason for unemployment (if so)?",     ////10
                          @"If your reason for unemployment was not listed in question 10, please type it here.",
                          @"Are you a delivery driver?",
                          @"Does your employer allow you to work with flexible hours?",
                          @"Do you have more than one paying job?",
                          @"What is the name of your primary employer?",    ////15 40
                          @"What is your workplace type?",
                          @"If your workplace type was not listed in question 16, please type it here.",
                          @"Is your workplace a home office or business operated out of the home?",
                          @"If you are employed 30 or more hours per week, do you work from home by telecommute on a regular basis?",
                          @"What is your workplace Address?",   /////45
                          @"How many days do you typically work per week? (If you don't know, please enter 98. If you prefer not to answer, please enter 99) ",
                          @"In the last 7 days, how many days did you work at home instead of going to work? (If you don't know, please enter 98. If you prefer not to answer, please enter 99)",
                          @"What is you second job type?",
                          @"If your second job type was not listed in question 23, please type it here",
                          @"What is your second job employment status?",   ////50
                          @"How many hours do all the members in a household work at all jobs? (If you don't know, please enter 888. If you prefer not to answer, please enter 999)",///'][]pp]]p]
                          @"What is your primary occupation?",
                          @"What is your primary job industry?",
                          @"What is your secondary occupation?",
                          @"What is your secondary job industry?",    ////55
                          @"Have you enrolled in any type of school?",
                          @"What is your school Type?",
                          @"If your school type was not listed in question 32, please type it here.",
                          @"Have you enrolled for 12 credit hours or more?",
                          @"How many days did you ride bike in the last 7 days? (If you don't know, please enter 98. If you prefer not to answer, please enter 99)",   ///60
                          @"What is your most common purpose for riding a bike?",
                          @"Do you have a transportation disability?",
                          @"Did you travel on designated travel day?",
                          @"If you didn't make trips on the travel day, why?",
                          @"Did you use a diary to record trip information?",  ///65
                          @"What is your proxy ID? (If you don't know, please enter 98. If you prefer not to answer, please enter 99)",////// 66 Record Type 2 end
    nil];
    questionDescVehicle = [[NSArray alloc] initWithObjects:
                           @"",
                           @"What is your assigned vehicle number?", /// 67 Record Type 3
                           @"What is your vehicle type?",
                           @"If your vehicle type was not listed in question 2, please type it here.",
                           @"Please list the year of your vehicle.", ///70
                           @"Please list your vehicle's make.",
                           @"If your vehicle's make was not listed in question 5, please type it here.",
                           @"Please list your vehicle model.",
                           @"What type of fuel do you use?",
                           @"If your fuel type was not listed in question 8, please type it here.", ///75
                           @"Do you use your vehicles for commercial purposes?",
                           @"What is the ownership status of your vehicle?",
                           @"How many of your household vehicles are used by non-household members?",
                           @"Was your vehicle used by a non-household member on travel day?", ///80
                           @"Is your car's lighter (power outlet) working?",
                           @"What is your odometer at the beginning the travel day? (If you don't know, please enter 999998. If you prefer not to answer, please enter 999999.)",  //81 the end
    nil];
        
    answerHousehold = [[NSMutableArray alloc] init];
    answerPerson = [[NSMutableArray alloc] init];
    answerVehicle = [[NSMutableArray alloc] init];
    
    NSMutableArray *answerContent = nil;
    NSMutableArray *answerChoices = nil;
    
    //Question 0, just a placeholder
    [answerHousehold addObject:@""];
    //Q1
    
    
    //Q2
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"3"];
    [answerContent addObject:@""];
    [answerContent addObject:@"phone_number"];
    [answerHousehold addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    
    
    //Q3
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Yes"];
    [answerChoices addObject:@"No"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"advance_letter"];
    [answerHousehold addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    
    
    
    //Q5
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"3"];
    [answerContent addObject:@""];
    [answerContent addObject:@"number_persons"];
    [answerHousehold addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q6
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"3"];
    [answerContent addObject:@""];
    [answerContent addObject:@"number_employed"];
    [answerHousehold addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q7
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"3"];
    [answerContent addObject:@""];
    [answerContent addObject:@"vehicles_available"];
    [answerHousehold addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q8
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"3"];
    [answerContent addObject:@""];
    [answerContent addObject:@"vehicles_ownership"];
    [answerHousehold addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q9
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"3"];
    [answerContent addObject:@""];
    [answerContent addObject:@"bikes"];
    [answerHousehold addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q10
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Unattached Single Family Home"];
    [answerChoices addObject:@"Condo"];
    [answerChoices addObject:@"Duplex"];
    [answerChoices addObject:@"Apartment"];
    [answerChoices addObject:@"Mobile Home"];
    [answerChoices addObject:@"Other"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"residence"];
    [answerHousehold addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q11
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"1"];
    [answerContent addObject:@""];
    [answerContent addObject:@"other_residence"];
    [answerHousehold addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q12
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Less than one year"];
    [answerChoices addObject:@"One year"];
    [answerChoices addObject:@"Two years"];
    [answerChoices addObject:@"Three years"];
    [answerChoices addObject:@"Four years"];
    [answerChoices addObject:@"More than five years"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"tenure"];
    [answerHousehold addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q13
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"1"];
    [answerContent addObject:@""];
    [answerContent addObject:@"previous_residence"];
    [answerHousehold addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    
    //Q14
    
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Price of Property"];
    [answerChoices addObject:@"Taxes"];
    [answerChoices addObject:@"Proximity to Work"];
    [answerChoices addObject:@"School District"];
    [answerChoices addObject:@"Proximity to School"];
    [answerChoices addObject:@"Character of Neighborhood or Area"];
    [answerChoices addObject:@"Access to Public Transportation"];
    [answerChoices addObject:@"Security/Safety"];
    [answerChoices addObject:@"Other"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"hh_factors"];
    [answerHousehold addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q15
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"1"];
    [answerContent addObject:@""];
    [answerContent addObject:@"other_factors"];
    [answerHousehold addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q16
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Less than $5,000"];
    [answerChoices addObject:@"$,5000 to $9,999"];
    [answerChoices addObject:@"$10,000 to $14,999"];
    [answerChoices addObject:@"$15,000 to $19,999"];
    [answerChoices addObject:@"$20,000 to $24,999"];
    [answerChoices addObject:@"$25,000 to $29,999"];
    [answerChoices addObject:@"$30,000 to $34,999"];
    [answerChoices addObject:@"$35,000 to $39,999"];
    [answerChoices addObject:@"$40,000 to $49,999"];
    [answerChoices addObject:@"$50,000 to $59,999"];
    [answerChoices addObject:@"$60,000 to $74,999"];
    [answerChoices addObject:@"$75,000 to $99,999"];
    [answerChoices addObject:@"$100,000 to $124,999"];
    [answerChoices addObject:@"$125,000 to $149,999"];
    [answerChoices addObject:@"$150,000 or more"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"income"];
    [answerHousehold addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q17
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"3"];
    [answerContent addObject:@""];
    [answerContent addObject:@"day_visitors"];
    [answerHousehold addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q18
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"3"];
    [answerContent addObject:@""];
    [answerContent addObject:@"overnight_visitors"];
    [answerHousehold addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q19
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Yes"];
    [answerChoices addObject:@"No"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"delivery_vehicle"];
    [answerHousehold addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q20
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"3"];
    [answerContent addObject:@""];
    [answerContent addObject:@"number_delivery_driver"];
    [answerHousehold addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q21
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"3"];
    [answerContent addObject:@""];
    [answerContent addObject:@"phone_service"];
    [answerHousehold addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q22
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Less than one week"];
    [answerChoices addObject:@"One week to less than two weeks"];
    [answerChoices addObject:@"Two weeks to less than three weeks"];
    [answerChoices addObject:@"One month to less than four months"];
    [answerChoices addObject:@"Three months to less than six months"];
    [answerChoices addObject:@"Six months to less than one year"];
    [answerChoices addObject:@"One year or more"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"time_without"];
    [answerHousehold addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q23
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Yes"];
    [answerChoices addObject:@"No"];
    [answerChoices addObject:@"Zero"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"hh_vehicle_use_by_nonnumber"];
    [answerHousehold addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q24
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"3"];
    [answerContent addObject:@""];
    [answerContent addObject:@"share_phone"];
    [answerHousehold addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q25
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"3"];
    [answerContent addObject:@""];
    [answerContent addObject:@"smartphone_house"];
    [answerHousehold addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    
    
    
    [answerPerson addObject:@""];
    
    
    //Q26
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Husband/Wife/Unmarried Partner"];
    [answerChoices addObject:@"Mother/Father/In-law"];
    [answerChoices addObject:@"Brother/Sister/In-law"];
    [answerChoices addObject:@"Grandfather/Grandmother"];
    [answerChoices addObject:@"Grandson/Granddaughter"];
    [answerChoices addObject:@"Son/Daughter/In-law"];
    [answerChoices addObject:@"Aunt/Uncle"];
    [answerChoices addObject:@"Other Relative"];
    [answerChoices addObject:@"Other Non-Relative"];
    [answerChoices addObject:@"Household Help"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"relationship"];
    [answerPerson addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q27
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Male"];
    [answerChoices addObject:@"Female"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"sex"];
    [answerPerson addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q28
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Black/African American"];
    [answerChoices addObject:@"Hispanic/Mexican American"];
    [answerChoices addObject:@"Asian/Pacific Islander"];
    [answerChoices addObject:@"Native American"];
    [answerChoices addObject:@"White/Caucasian"];
    [answerChoices addObject:@"Other Group"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"ethnicity"];
    [answerPerson addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q29
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"1"];
    [answerContent addObject:@""];
    [answerContent addObject:@"other_ethnicity"];
    [answerPerson addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q30
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"3"];
    [answerContent addObject:@""];
    [answerContent addObject:@"age"];
    [answerPerson addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q31
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Yes"];
    [answerChoices addObject:@"No"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"licensed_driver"];
    [answerPerson addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q32
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Yes"];
    [answerChoices addObject:@"No"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"employment"];
    [answerPerson addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q33
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Employment full time 30hrs or more"];
    [answerChoices addObject:@"Employment part time less than 30hrs"];
    [answerChoices addObject:@"Self Employment full time 30hrs or more"];
    [answerChoices addObject:@"Self Employment part time less than 30hrs"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"employment_status"];
    [answerPerson addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q34
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"3"];
    [answerContent addObject:@""];
    [answerContent addObject:@"hours"];
    [answerPerson addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q35
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Retired"];
    [answerChoices addObject:@"Disability Status"];
    [answerChoices addObject:@"Homemaker"];
    [answerChoices addObject:@"Looking for Work"];
    [answerChoices addObject:@"Not Looking for Work"];
    [answerChoices addObject:@"Student"];
    [answerChoices addObject:@"Other"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"not_employed"];
    [answerPerson addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q36
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"1"];
    [answerContent addObject:@""];
    [answerContent addObject:@"not_employed_other"];
    [answerPerson addObject:answerContent];
    answerChoices = nil;
    
    //Q37
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Yes"];
    [answerChoices addObject:@"No"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"delivery"];
    [answerPerson addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q38
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Flexible/Variable"];
    [answerChoices addObject:@"Fixed/Unchanging"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"flex_time"];
    [answerPerson addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q39
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Yes"];
    [answerChoices addObject:@"No"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"job"];
    [answerPerson addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q40
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"1"];
    [answerContent addObject:@""];
    [answerContent addObject:@"primary_employer_name"];
    [answerPerson addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q41
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Office (Non-Government)"];
    [answerChoices addObject:@"Office (Government)"];
    [answerChoices addObject:@"Retail/Shopping/Gas"];
    [answerChoices addObject:@"Industrial/Manufacturing/Warehouse"];
    [answerChoices addObject:@"Medical"];
    [answerChoices addObject:@"Education-Day Car/k-12"];
    [answerChoices addObject:@"Education-College,Trade School,other"];
    [answerChoices addObject:@"Residential"];
    [answerChoices addObject:@"Airport"];
    [answerChoices addObject:@"Eating Establishment"];
    [answerChoices addObject:@"Other"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"workplace_type"];
    [answerPerson addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q42
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"1"];
    [answerContent addObject:@""];
    [answerContent addObject:@"other_workplace"];
    [answerPerson addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q43
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Yes"];
    [answerChoices addObject:@"No"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"home_office"];
    [answerPerson addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q44
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Yes"];
    [answerChoices addObject:@"No"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"telecommute"];
    [answerPerson addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q45
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"1"];
    [answerContent addObject:@""];
    [answerContent addObject:@"workplace_address"];
    [answerPerson addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    
    //Q46
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"3"];
    [answerContent addObject:@""];
    [answerContent addObject:@"days_worked"];
    [answerPerson addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q47
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"3"];
    [answerContent addObject:@""];
    [answerContent addObject:@"work_at_home"];
    [answerPerson addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q48
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Office (Non-Government)"];
    [answerChoices addObject:@"Office (Government)"];
    [answerChoices addObject:@"Retail/Shopping/Gas"];
    [answerChoices addObject:@"Industrial/Manufacturing/Warehouse"];
    [answerChoices addObject:@"Medical"];
    [answerChoices addObject:@"Education-Day Car/k-12"];
    [answerChoices addObject:@"Education-College,Trade School,other"];
    [answerChoices addObject:@"Residential"];
    [answerChoices addObject:@"Airport"];
    [answerChoices addObject:@"Eating Establishment"];
    [answerChoices addObject:@"Other"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"second_job_type"];
    [answerPerson addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q49
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"1"];
    [answerContent addObject:@""];
    [answerContent addObject:@"second_job_other"];
    [answerPerson addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q50
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Employment full time 30hrs or more"];
    [answerChoices addObject:@"Employment part time less than 30hrs"];
    [answerChoices addObject:@"Self Employment full time 30hrs or more"];
    [answerChoices addObject:@"Self Employment part time less than 30hrs"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"second_job_employment_status"];
    [answerPerson addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q51
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"3"];
    [answerContent addObject:@""];
    [answerContent addObject:@"total_hours"];
    [answerPerson addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q52
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Management,Professional,and Related Occupation"];
    [answerChoices addObject:@"Service Occupations"];
    [answerChoices addObject:@"Sales and Office Occupations"];
    [answerChoices addObject:@"Farming,Fishing, and Forestry Occupations"];
    [answerChoices addObject:@"Construction,Extraction,and Maintenance Occupations"];
    [answerChoices addObject:@"Production, Transportation,and Material Moving Occupations"];
    [answerChoices addObject:@"Education-College, Trade School, other"];
    [answerChoices addObject:@"Not Applicable (unemployed/student/retired)"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"primary_occupation"];
    [answerPerson addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q53
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Agriculture,Forestry,Fishing,and Hunting,Mining"];
    [answerChoices addObject:@"Construction"];
    [answerChoices addObject:@"Manufacturing"];
    [answerChoices addObject:@"Wholesale Trade"];
    [answerChoices addObject:@"Retail Trade"];
    [answerChoices addObject:@"Transportation,Warehousing,Utilities"];
    [answerChoices addObject:@"Information"];
    [answerChoices addObject:@"Finance,Insurance,Real Estate,Rental and Leasing"];
    [answerChoices addObject:@"Professional,Scientific,Management,Administrative,and Waste Management Service"];
    [answerChoices addObject:@"Education,Health,and Social Services"];
    [answerChoices addObject:@"Arts,Entertainment, Recreation,Accommodation,and Food Service"];
    [answerChoices addObject:@"Other Service"];
    [answerChoices addObject:@"Public Administration"];
    [answerChoices addObject:@"Not Applicable"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"primary_industry"];
    [answerPerson addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q54
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Management,Professional, and Related Occupation"];
    [answerChoices addObject:@"Service Occupations"];
    [answerChoices addObject:@"Sales and Office Occupations"];
    [answerChoices addObject:@"Farming,Fishing,and Forestry Occupations"];
    [answerChoices addObject:@"Construction,Extraction,and Maintenance Occupations"];
    [answerChoices addObject:@"Production,Transportation,and Material Moving Occupations"];
    [answerChoices addObject:@"Education-College,Trade School,other"];
    [answerChoices addObject:@"Not Applicable(unemployed/student/retired"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"secondary_occupation"];
    [answerPerson addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q55
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Agriculture,Forestry,Fishing,and Hunting,Mining"];
    [answerChoices addObject:@"Construction"];
    [answerChoices addObject:@"Manufacturing"];
    [answerChoices addObject:@"Wholesale Trade"];
    [answerChoices addObject:@"Retail Trade"];
    [answerChoices addObject:@"Transportation,Warehousing,Utilities"];
    [answerChoices addObject:@"Information"];
    [answerChoices addObject:@"Finance,Insurance,Real Estate,Rental and Leasing"];
    [answerChoices addObject:@"Professional,Scientific,Management,Administrative,and Waste Management Service"];
    [answerChoices addObject:@"Education,Health,and Social Services"];
    [answerChoices addObject:@"Arts,Entertainment, Recreation,Accommodation,and Food Service"];
    [answerChoices addObject:@"Other Service"];
    [answerChoices addObject:@"Publice Administration"];
    [answerChoices addObject:@"Not Applicable"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"secondary_industry"];
    [answerPerson addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q56
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Yes"];
    [answerChoices addObject:@"No"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"students_status"];
    [answerPerson addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q57
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"DayCare/Pre-School"];
    [answerChoices addObject:@"K12th"];
    [answerChoices addObject:@"Post Secondary,College,Trade"];
    [answerChoices addObject:@"Other"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"school_type"];
    [answerPerson addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q58
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"1"];
    [answerContent addObject:@""];
    [answerContent addObject:@"school_type_other"];
    [answerPerson addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q59
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Yes"];
    [answerChoices addObject:@"No"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"hours_enrolled"];
    [answerPerson addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q60
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"3"];
    [answerContent addObject:@""];
    [answerContent addObject:@"bike_use"];
    [answerPerson addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q61
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Work"];
    [answerChoices addObject:@"School"];
    [answerChoices addObject:@"Shopping"];
    [answerChoices addObject:@"Visiting"];
    [answerChoices addObject:@"Recreation/Exercise"];
    [answerChoices addObject:@"Other"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"bike_purpose"];
    [answerPerson addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q62
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Yes"];
    [answerChoices addObject:@"No"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"disability"];
    [answerPerson addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q63
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Yes"];
    [answerChoices addObject:@"No"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"travel"];
    [answerPerson addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    
    
    //Q64
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"1"];
    [answerContent addObject:@""];
    [answerContent addObject:@"why_no_travel"];
    [answerPerson addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q65
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Yes, use diary"];
    [answerChoices addObject:@"No, did not use diary"];
    [answerChoices addObject:@"Did not receive diary"];
    [answerChoices addObject:@"Based on memory"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"diary_use"];
    [answerPerson addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    
    
    //Q66
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"3"];
    [answerContent addObject:@""];
    [answerContent addObject:@"proxy_id"];
    [answerPerson addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    
    
    [answerVehicle addObject:@""];
    //Q67
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"3"];
    [answerContent addObject:@""];
    [answerContent addObject:@"vehicle_number"];
    [answerVehicle addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q68
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Motorcycle (includes mopeds)"];
    [answerChoices addObject:@"Car (includes station wagons)"];
    [answerChoices addObject:@"Van (mini and passenger)"];
    [answerChoices addObject:@"Sport Utility Vehicle"];
    [answerChoices addObject:@"Pickup Truck"];
    [answerChoices addObject:@"Cargo Van"];
    [answerChoices addObject:@"Commercial Cargo Transport Vehicle"];
    [answerChoices addObject:@"Commercial Service Vehicle"];
    [answerChoices addObject:@"Other"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"type_of_vehicle"];
    [answerVehicle addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q69
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"1"];
    [answerContent addObject:@""];
    [answerContent addObject:@"other_vehicle_type"];
    [answerVehicle addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    
    //Q70
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"3"];
    [answerContent addObject:@""];
    [answerContent addObject:@"year"];
    [answerVehicle addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q71
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Acura"];
    [answerChoices addObject:@"Audi"];
    [answerChoices addObject:@"BMW"];
    [answerChoices addObject:@"Buick"];
    [answerChoices addObject:@"Cadillac"];
    [answerChoices addObject:@"Chevrolet"];
    [answerChoices addObject:@"Chrysler"];
    [answerChoices addObject:@"Dodge"];
    [answerChoices addObject:@"Ford"];
    [answerChoices addObject:@"Geo"];
    [answerChoices addObject:@"GMC"];
    [answerChoices addObject:@"Harley Davidson"];
    [answerChoices addObject:@"Honda"];
    [answerChoices addObject:@"Hyundai"];
    [answerChoices addObject:@"Infiniti"];
    [answerChoices addObject:@"Isuzu"];
    [answerChoices addObject:@"Jaguar"];
    [answerChoices addObject:@"Jeep"];
    [answerChoices addObject:@"Kawasaki"];
    [answerChoices addObject:@"KIA"];
    [answerChoices addObject:@"Lexus"];
    [answerChoices addObject:@"Lincoln"];
    [answerChoices addObject:@"Mazda"];
    [answerChoices addObject:@"Mercury"];
    [answerChoices addObject:@"Mercedes-Benz"];
    [answerChoices addObject:@"Mitsubishi"];
    [answerChoices addObject:@"Nissan/Datsun"];
    [answerChoices addObject:@"Oldsmobile"];
    [answerChoices addObject:@"Plymouth"];
    [answerChoices addObject:@"Pontiac"];
    [answerChoices addObject:@"Porsche"];
    [answerChoices addObject:@"Range/Land Rover"];
    [answerChoices addObject:@"Saab"];
    [answerChoices addObject:@"Saturn"];
    [answerChoices addObject:@"Subaru"];
    [answerChoices addObject:@"Suzuki"];
    [answerChoices addObject:@"Toyota"];
    [answerChoices addObject:@"Volkswagen"];
    [answerChoices addObject:@"Volvo"];
    [answerChoices addObject:@"Yamaha"];
    [answerChoices addObject:@"Daewoo"];
    [answerChoices addObject:@"Alfa Romeo"];
    [answerChoices addObject:@"AM General"];
    [answerChoices addObject:@"AMC"];
    [answerChoices addObject:@"Austin/Austin Healey"];
    [answerChoices addObject:@"Bluebird"];
    [answerChoices addObject:@"Brockway"];
    [answerChoices addObject:@"BSA"];
    [answerChoices addObject:@"Daihatsu"];
    [answerChoices addObject:@"Diamond Reo/Reo"];
    [answerChoices addObject:@"Ducati"];
    [answerChoices addObject:@"Eagle"];
    [answerChoices addObject:@"Eagle Coach"];
    [answerChoices addObject:@"Fiat"];
    [answerChoices addObject:@"Freightliner"];
    [answerChoices addObject:@"FWD"];
    [answerChoices addObject:@"Gillig"];
    [answerChoices addObject:@"Grumman"];
    [answerChoices addObject:@"Imperial"];
    [answerChoices addObject:@"International Harvester/Navistar"];
    [answerChoices addObject:@"Iveco/Magirus"];
    [answerChoices addObject:@"Kenworth"];
    [answerChoices addObject:@"Lancia"];
    [answerChoices addObject:@"Mack"];
    [answerChoices addObject:@"MCI"];
    [answerChoices addObject:@"Merkur"];
    [answerChoices addObject:@"MG"];
    [answerChoices addObject:@"Moto-Guzzi"];
    [answerChoices addObject:@"Norton"];
    [answerChoices addObject:@"Peterbuilt"];
    [answerChoices addObject:@"Peugeot"];
    [answerChoices addObject:@"Renault"];
    [answerChoices addObject:@"Sterling"];
    [answerChoices addObject:@"Thomas Built"];
    [answerChoices addObject:@"Triumph"];
    [answerChoices addObject:@"White/Autocar-White GMC"];
    [answerChoices addObject:@"Yugo"];
    [answerChoices addObject:@"Other Make Moped"];
    [answerChoices addObject:@"Other Make Motorcycle"];
    [answerChoices addObject:@"Other(specify in next question)"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"make"];
    [answerVehicle addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q72
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"1"];
    [answerContent addObject:@""];
    [answerContent addObject:@"other_make"];
    [answerVehicle addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //73
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"1"];
    [answerContent addObject:@""];
    [answerContent addObject:@"model"];
    [answerVehicle addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q74
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Gasoline"];
    [answerChoices addObject:@"Diesel"];
    [answerChoices addObject:@"Propane"];
    [answerChoices addObject:@"Natural Gas"];
    [answerChoices addObject:@"Electricity"];
    [answerChoices addObject:@"Other"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"type_of_fuel"];
    [answerVehicle addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q75
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"1"];
    [answerContent addObject:@""];
    [answerContent addObject:@"other_fuel_type"];
    [answerVehicle addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q76
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Yes"];
    [answerChoices addObject:@"No"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"commercial_use"];
    [answerVehicle addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    
    
    //Q77
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Owned or leased by household or member of household"];
    [answerChoices addObject:@"Owned or leased by another person"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"ownership"];
    [answerVehicle addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q78
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"3"];
    [answerContent addObject:@""];
    [answerContent addObject:@"non_hh_vehicle_number"];
    [answerVehicle addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q79
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Yes"];
    [answerChoices addObject:@"No"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"non_hh_use"];
    [answerVehicle addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //80
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Yes"];
    [answerChoices addObject:@"No"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"lighter"];
    [answerVehicle addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q81
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"3"];
    [answerContent addObject:@""];
    [answerContent addObject:@"odometer"];
    [answerVehicle addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    
    questionTitleUsed = questionTitleHousehold;
    questionDescUsed = questionDescHousehold;
    answerUsed = answerHousehold;
    [self setTotalText];
    
    [prev setUserInteractionEnabled:NO];
    
    [self questionIntChanged];
    [self readFromDictionary];
    
    [super viewDidLoad];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
	return [pickerChoices count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
	return [pickerChoices objectAtIndex:row];
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:13]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
