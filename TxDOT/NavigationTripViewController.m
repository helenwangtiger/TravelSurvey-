//
//  NavigationTripViewController.m
//  TxDOT
//
//  Created by Qian on 10/19/13.
//  Copyright (c) 2013 Qian. All rights reserved.
//

#import "NavigationTripViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface NavigationTripViewController ()

@end

@implementation NavigationTripViewController

@synthesize questionTitleTrip,questionDescTrip,answerTrip,pickerChoices,questionNum,questionTotalNum,recordType,questionDes,answerView,preButton,nextButton,text,picker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)saveToDictionary {
    NSString *value = [[NSString alloc] init];
    NSString *key = [[NSString alloc] init];
    key = answerTrip[questionInt][2];
    NSInteger row;
    if([answerTrip[questionInt][0] isEqualToString:@"1"]) {
        if(text.text==NULL) {
            value = @"";
        }
        else {
            value = text.text;
        }
    }
    else if([answerTrip[questionInt][0] isEqualToString:@"2"]) {
        row = [picker selectedRowInComponent:0];
        value = [pickerChoices objectAtIndex:row];
        
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"data.plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    [data setObject:value forKey:key];
    //NSInteger tempRow = row;
    //[data setObject:[NSNumber numberWithInteger:tempRow] forKey:key];
    [data writeToFile:path atomically:YES];
    value = nil;
    key = nil;
}

-(void)readFromDictionary {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"data.plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    //NSLog(@"Data: %@",data);
    
    if([answerTrip[questionInt][0] isEqualToString:@"1"]) {
        NSString *value = [[NSString alloc] init];
        value = [data objectForKey:answerTrip[questionInt][2]];
        if(value==NULL) {
            value = @"";
        }
        //NSLog(@"value: %@",value);
        text.text = value;
    }
    else if([answerTrip[questionInt][0] isEqualToString:@"2"]) {
        NSString *value = [[NSString alloc] init];
        value = [data objectForKey:answerTrip[questionInt][2]];
        
        
    }
}

-(IBAction)clickPre {
    [self saveToDictionary];
    questionInt--;
    [self questionIntChanged];
    [self checkButtons];
    [self readFromDictionary];
}
-(IBAction)clickNext {
    [self saveToDictionary];
    questionInt++;
    [self questionIntChanged];
    [self checkButtons];
    [self readFromDictionary];
}


-(void)questionIntChanged {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"data.plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    //[data setObject:@"asasdfasdfsdf" forKey:@"Sample Number"];
    //[data writeToFile:path atomically:YES];
    NSLog(@"Data: %@",data);
    questionNum.text = [NSString stringWithFormat:@"%d",questionInt];
    questionTotalNum.text = [NSString stringWithFormat:@"%lu",[questionTitleTrip count]-1];
    recordType.text = questionTitleTrip[questionInt];
    questionDes.text = questionDescTrip[questionInt];
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
    if([answerTrip[questionInt][0] isEqualToString:@"1"]) {
        text = [[UITextField alloc] initWithFrame:CGRectMake(20, 15, 250, 35)];
        text.borderStyle = UITextBorderStyleRoundedRect;
        text.font = [UIFont systemFontOfSize:18];
        text.placeholder = @"enter text";
        text.autocorrectionType = UITextAutocorrectionTypeNo;
        text.keyboardType = UIKeyboardTypeDefault;
        text.returnKeyType = UIReturnKeyDone;
        [text addTarget:self
                 action:@selector(textFieldFinished:)
       forControlEvents:UIControlEventEditingDidEndOnExit];
        text.clearButtonMode = UITextFieldViewModeWhileEditing;
        text.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [answerView addSubview:text];
    }
    //if it is a picker
    else if([answerTrip[questionInt][0] isEqualToString:@"2"]) {
        int numberElements = (int)[answerTrip[questionInt][1] count];
        pickerChoices = nil;
        pickerChoices = [[NSMutableArray alloc] init];
        for(int i=0;i<numberElements;i++) {
            [pickerChoices addObject:answerTrip[questionInt][1][i]];
        }
        picker = [[UIPickerView alloc] initWithFrame:CGRectMake(6,8,280,140)];
        picker.delegate = self;
        picker.dataSource = self;
        picker.showsSelectionIndicator = YES;
        picker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [answerView addSubview:picker];
        
        // [picker selectRow:2 inComponent:0 animated:YES];
    }
    else if([answerTrip[questionInt][0] isEqualToString:@"3"]) {
        text = [[UITextField alloc] initWithFrame:CGRectMake(20, 15, 250, 35)];
        text.borderStyle = UITextBorderStyleRoundedRect;
        text.font = [UIFont systemFontOfSize:18];
        text.placeholder = @"enter text";
        text.autocorrectionType = UITextAutocorrectionTypeNo;
        text.keyboardType = UIKeyboardTypeNumberPad;
        text.returnKeyType = UIReturnKeyDone;
        [text addTarget:self
                 action:@selector(textFieldFinished:)
       forControlEvents:UIControlEventEditingDidEndOnExit];
        text.clearButtonMode = UITextFieldViewModeWhileEditing;
        text.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [answerView addSubview:text];
    }
    
    

}

-(void)checkButtons {
    if(questionInt==1) {
        [preButton setUserInteractionEnabled:NO];
        [self changeButtonTitleNext];
        [nextButton setUserInteractionEnabled:YES];
    }
    else if(questionInt==questionTitleTrip.count-1) {
        [preButton setUserInteractionEnabled:YES];
        [self changeButtonTitleDone];
        [nextButton setUserInteractionEnabled:NO];
    }
    else {
        [preButton setUserInteractionEnabled:YES];
        [self changeButtonTitleNext];
        [nextButton setUserInteractionEnabled:YES];
    }
}
-(IBAction)changeButtonTitleDone {
    
    [nextButton setTitle:@"Done" forState:UIControlStateNormal];
    
}
-(IBAction)changeButtonTitleNext {
    
    [nextButton setTitle:@"Next" forState:UIControlStateNormal];
    
    
}

-(void)setTotalText {
    questionTotalNum.text = [NSString stringWithFormat:@"%lu",[questionTitleTrip count]-1];
}

- (IBAction)textFieldFinished:(id)sender
{
    [sender resignFirstResponder];
}

-(void) hideKeyboard {
    [text resignFirstResponder];
}
- (void)viewDidLoad

{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    questionInt = 1 ;
    questionTitleTrip = [[NSArray alloc] initWithObjects:
                         @"",
                         @"Record TYPE 4- Trip Information",
                         @"Record TYPE 4- Trip Information",
                         @"Record TYPE 4- Trip Information",
                         @"Record TYPE 4- Trip Information",
                         @"Record TYPE 4- Trip Information",/////5
                         @"Record TYPE 4- Trip Information",
                         @"Record TYPE 4- Trip Information",
                         @"Record TYPE 4- Trip Information",
                         @"Record TYPE 4- Trip Information",
                         @"Record TYPE 4- Trip Information",////10
                         @"Record TYPE 4- Trip Information",
                         @"Record TYPE 4- Trip Information",
                         @"Record TYPE 4- Trip Information",
                         @"Record TYPE 4- Trip Information",
                         @"Record TYPE 4- Trip Information",////15
                         @"Record TYPE 4- Trip Information",
                         @"Record TYPE 4- Trip Information",
                         @"Record TYPE 4- Trip Information",
                         @"Record TYPE 4- Trip Information",
                         @"Record TYPE 4- Trip Information",////20
                         @"Record TYPE 4- Trip Information",
                         @"Record TYPE 4- Trip Information",
                         @"Record TYPE 4- Trip Information",
                         @"Record TYPE 4- Trip Information",
                         @"Record TYPE 4- Trip Information",/////25
                         @"Record TYPE 4- Trip Information",
                         @"Record TYPE 4- Trip Information",
                         @"Record TYPE 4- Trip Information",////28
                
    nil];
   
    questionDescTrip = [[NSArray alloc] initWithObjects:
                        
                        @"",
                        @"What is your activity type?",
                        @"Please briefly describe your trip activity.",
                        @"What is your destination address?",
                        @"What is the type of destination for the trip?",
                        @"If the type of destination was not listed in question 4, please type it here.",   //////////5
                        @"What is the purpose for your trip?",
                        @"What method of transportation did you use for your trip?",
                        @"If the method of transportation was not listed in question 7, please type it here.",
                        @"What is the number of people in the vehicle, including the driver?  (If the travel is not by a private vehicle, please enter 96).",
                        @"How may household members were in the vehicle druing the trip?",  /////10
                        @"Which household members travelled with you? (Add commas between multiple members)",
                        @"Is a household vehicle makes this trip?",
                        @"What is the vehicle number used for this trip? If other vehicle is used, please enter 99.",
                        @"What is your vehicle type for the trip?",
                        @"If the vehicle type was not listed in question 14, please type it here. ",   ////15
                        @"What is the year of the vehicle used to make the trip? ",
                        @"What is the make of the vehicle used to make the trip?",
                        @"If the vehicle make was not listed in question 17, please type it here.",
                        @"What is the model of the vehicle used to make the trip?",
                        @"What is the fuel type for the vehicle used to make this trip? ?", ////20
                        @"If your fuel type was not listed in question 20, please type it here.",
                        @"Is the vehicle used to make the trip also used for commercial purposes?",
                        @"Did you walk more than one block to bus stop?",
                        @"Did you park or get off the bus more than one block away from your destination location?",
                        @"What is the address that you got off the bus? Ignore this question if you did not ride a bus.", ////25
                        @"What is the address that you parked for vehicle? Ignore this question if you did not drive a vehicle to your destination. ",
                        @"How is your parking fee charged?",
                        @"How much were you charged for parking?", ////28
    nil];
    
    answerTrip = [[NSMutableArray alloc] init];
    
    NSMutableArray *answerContent = nil;
    NSMutableArray *answerChoices = nil;
    [answerTrip addObject:@""];
    
  
    //Q1
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"At home;primary job related"];
    [answerChoices addObject:@"At home; other"];
    [answerChoices addObject:@"At home;job and non-job related"];
    [answerChoices addObject:@"Work"];
    [answerChoices addObject:@"Work Related"];
    [answerChoices addObject:@"School;post secondary,college,trade"];
    [answerChoices addObject:@"School;secondary-day care,kindergarten,elementary,middle, high"];
    [answerChoices addObject:@"Incidental Shopping;gas;groceries,etc"];
    [answerChoices addObject:@"Major Shopping;clothes,appliances,etc."];
    [answerChoices addObject:@"Banking"];
    [answerChoices addObject:@"Personal business,laundry,dry cleaning,barber,medical"];
    [answerChoices addObject:@"Other Services"];
    [answerChoices addObject:@"Socail/Recreational"];
    [answerChoices addObject:@"Eat Out"];
    [answerChoices addObject:@"Civic Activity"];
    [answerChoices addObject:@"Pick-up/Drop-off Person at Work"];
    [answerChoices addObject:@"Pick-up/Drop-off Person at School,/Day Care"];
    [answerChoices addObject:@"Pick-up/Drop-off Person at Other"];
    [answerChoices addObject:@"Change Mode of Travel"];
    [answerChoices addObject:@"Other Activity"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"activity_type"];
    [answerTrip addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q2
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"1"];
    [answerContent addObject:@""];
    [answerContent addObject:@"activity_description"];
    [answerTrip addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    
    
    //Q3
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"1"];
    [answerContent addObject:@""];
    [answerContent addObject:@"activity_address"];
    [answerTrip addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    
    //Q4
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Residential"];
    [answerChoices addObject:@"Residential type Workplace"];
    [answerChoices addObject:@"Construction Site"];
    [answerChoices addObject:@"Transportation stop (bus,train)"];
    [answerChoices addObject:@"Automotive Dealer/Repair"];
    [answerChoices addObject:@"Bank/Financial Institution"];
    [answerChoices addObject:@"Barber/Beauty/Nail Salon"];
    [answerChoices addObject:@"Bookstore/Newsstand"];
    [answerChoices addObject:@"Convenience/Drug Store"];
    [answerChoices addObject:@"Government/City/County/State/Federal Offices"];
    [answerChoices addObject:@"Office(Non-Government)"];
    [answerChoices addObject:@"Grocery"];
    [answerChoices addObject:@"Health Club"];
    [answerChoices addObject:@"Medical Facility/Hospital"];
    [answerChoices addObject:@"Movie Theater/Cinema"];
    [answerChoices addObject:@"Restaurant/Fast Food,Bar&Grill"];
    [answerChoices addObject:@"Educational-12th Grade or lower"];
    [answerChoices addObject:@"Educational-college,trade,etc."];
    [answerChoices addObject:@"Shoping Mall/Department Store"];
    [answerChoices addObject:@"Convience Store/Gas Station"];
    [answerChoices addObject:@"Airport"];
    [answerChoices addObject:@"Other"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"place_type"];
    [answerTrip addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q5
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"1"];
    [answerContent addObject:@""];
    [answerContent addObject:@"other_place"];
    [answerTrip addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q6
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Home"];
    [answerChoices addObject:@"Meal/Eat"];
    [answerChoices addObject:@"Work"];
    [answerChoices addObject:@"Work Related"];
    [answerChoices addObject:@"School; K thru 12"];
    [answerChoices addObject:@"School;Post Secondary"];
    [answerChoices addObject:@"Shopping"];
    [answerChoices addObject:@"Personal"];
    [answerChoices addObject:@"Social/Recreation"];
    [answerChoices addObject:@"Pick-up Drop-off Other"];
    [answerChoices addObject:@"Change Mode"];
    [answerChoices addObject:@"Other"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"trip_purpose"];
    [answerTrip addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q7
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Walk"];
    [answerChoices addObject:@"Auto/Van/Truck Driver"];
    [answerChoices addObject:@"Auto/Van/Truck Passenger"];
    [answerChoices addObject:@"Carpool Driver"];
    [answerChoices addObject:@"Carpool Passenger"];
    [answerChoices addObject:@"Vanpool Driver"];
    [answerChoices addObject:@"Vanpool Passenger"];
    [answerChoices addObject:@"Commercial Cargo Transportation Vehicle Driver"];
    [answerChoices addObject:@"Commercial Cargo Transportation Vehicle Passenger"];
    [answerChoices addObject:@"Commercial Service Vehicle Driver"];
    [answerChoices addObject:@"Commercial Service Vehicle Passenger"];
    [answerChoices addObject:@"Bus"];
    [answerChoices addObject:@"School Bus"];
    [answerChoices addObject:@"Taxi/Paid Limo"];
    [answerChoices addObject:@"Bicycle"];
    [answerChoices addObject:@"Motocycle/Moped"];
    [answerChoices addObject:@"Other"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"travel_mode"];
    [answerTrip addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q8
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"1"];
    [answerContent addObject:@""];
    [answerContent addObject:@"other_mode"];
    [answerTrip addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q9
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"3"];
    [answerContent addObject:@""];
    [answerContent addObject:@"number_of_people"];
    [answerTrip addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q10
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"3"];
    [answerContent addObject:@""];
    [answerContent addObject:@"hh_members"];
    [answerTrip addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q11
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"1"];
    [answerContent addObject:@""];
    [answerContent addObject:@"persons_on_trips"];
    [answerTrip addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    
    
    //Q12
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Yes"];
    [answerChoices addObject:@"No"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"hh_vehicle"];
    [answerTrip addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q13
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"3"];
    [answerContent addObject:@""];
    [answerContent addObject:@"vehicle_used"];
    [answerTrip addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q14
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Motorcycle (includes mopeds)"];
    [answerChoices addObject:@"Car (includes station wagons"];
    [answerChoices addObject:@"Van(mini and passenger"];
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
    [answerContent addObject:@"body_type"];
    [answerTrip addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q15
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"1"];
    [answerContent addObject:@""];
    [answerContent addObject:@"other_body_type"];
    [answerTrip addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q16
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"3"];
    [answerContent addObject:@""];
    [answerContent addObject:@"other_vehicle_year"];
    [answerTrip addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q17
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
    [answerTrip addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q18
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"1"];
    [answerContent addObject:@""];
    [answerContent addObject:@"other_vehicle_make_description"];
    [answerTrip addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q19
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"1"];
    [answerContent addObject:@""];
    [answerContent addObject:@"other_vehicle_model"];
    [answerTrip addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q20
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
    [answerContent addObject:@"other_vehicle_fuel"];
    [answerTrip addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q21
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"1"];
    [answerContent addObject:@""];
    [answerContent addObject:@"other_fuel"];
    [answerTrip addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q22
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Yes"];
    [answerChoices addObject:@"No"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"other_vehicle_commercial_use"];
    [answerTrip addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q23
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Yes"];
    [answerChoices addObject:@"No"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"bus_stop"];
    [answerTrip addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q24
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Yes"];
    [answerChoices addObject:@"No"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"to_activity"];
    [answerTrip addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    
    //Q25
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"1"];
    [answerContent addObject:@""];
    [answerContent addObject:@"off_bus_location"];
    [answerTrip addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q26
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"1"];
    [answerContent addObject:@""];
    [answerContent addObject:@"parking_location"];
    [answerTrip addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q27
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    [answerChoices addObject:@"Hourly"];
    [answerChoices addObject:@"Daily"];
    [answerChoices addObject:@"Weekly"];
    [answerChoices addObject:@"Annually"];
    [answerChoices addObject:@"Electricity"];
    [answerChoices addObject:@"Other"];
    [answerChoices addObject:@"Don't Know"];
    [answerChoices addObject:@"Prefer not to answer"];
    [answerContent addObject:@"2"];
    [answerContent addObject:answerChoices];
    [answerContent addObject:@"payment_method"];
    
    [answerTrip addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;
    
    //Q28
    answerContent = [[NSMutableArray alloc] init];
    answerChoices = [[NSMutableArray alloc] init];
    answerChoices = nil;
    [answerContent addObject:@"1"];
    [answerContent addObject:@""];
    [answerContent addObject:@"parking_cost"];
    [answerTrip addObject:answerContent];
    answerChoices = nil;
    answerContent = nil;

    
    [self setTotalText];
    [preButton setUserInteractionEnabled:NO];
    [self questionIntChanged];
    [self readFromDictionary];
    
    

 

                        
    
    
                        
                        
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
