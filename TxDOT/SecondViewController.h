//
//  SecondViewController.h
//  TxDOT
//
//  Created by Qian on 6/14/13.
//  Copyright (c) 2013 Qian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
    NSArray *questionTitleUsed;
    NSArray *questionDescUsed;
    NSMutableArray *answerUsed;
    NSArray *questionTitleHousehold;
    NSArray *questionDescHousehold;
    NSMutableArray *answerHousehold;
    NSArray *questionTitlePerson;
    NSArray *questionDescPerson;
    NSMutableArray *answerPerson;
    NSArray *questionTitleVehicle;
    NSArray *questionDescVehicle;
    NSMutableArray *answerVehicle;
    NSMutableArray *answerTrip;
    NSMutableArray *pickerChoices;
    int questionInt;
    int totalInt;
    IBOutlet UILabel *questionNumber;
    IBOutlet UILabel *totalQuestions;
    IBOutlet UILabel *questionTitleLabel;
    IBOutlet UITextView *questionDescLabel;
    IBOutlet UIView *answerView;
    IBOutlet UIView *categoryView;
    IBOutlet UIButton *prev;
    IBOutlet UIButton *next;
    UITextField *text;
    UIPickerView *picker;
    CGPoint startPosition;
    
    IBOutlet UIView *overlayView;
}

@property(nonatomic,retain) IBOutlet UIView *overlayView;

@property (nonatomic,retain) NSArray *questionTitleUsed;
@property (nonatomic,retain) NSArray *questionDescUsed;
@property (nonatomic,retain) NSMutableArray *answerUsed;
@property (nonatomic,retain) NSArray *questionTitleHousehold;
@property (nonatomic,retain) NSArray *questionDescHousehold;
@property (nonatomic,retain) NSMutableArray *answerHousehold;
@property (nonatomic,retain) NSArray *questionTitlePerson;
@property (nonatomic,retain) NSArray *questionDescPerson;
@property (nonatomic,retain) NSMutableArray *answerPerson;
@property (nonatomic,retain) NSArray *questionTitleVehicle;
@property (nonatomic,retain) NSArray *questionDescVehicle;
@property (nonatomic,retain) NSMutableArray *answerVehicle;
@property (nonatomic,retain) NSMutableArray *answerTrip;
@property (nonatomic,retain) NSMutableArray *pickerChoices;
@property (nonatomic,retain) IBOutlet UILabel *questionNumber;
@property (nonatomic,retain) IBOutlet UILabel *totalQuestions;
@property (nonatomic,retain) IBOutlet UILabel *questionTitleLabel;
@property (nonatomic,retain) IBOutlet UITextView *questionDescLabel;
@property (nonatomic,retain) IBOutlet UIView *answerView;
@property (nonatomic,retain) IBOutlet UIView *categoryView;
@property (nonatomic,retain) IBOutlet UIButton *prev;
@property (nonatomic,retain) IBOutlet UIButton *next;
@property (nonatomic,retain) UITextField *text;
@property (nonatomic,retain) UIPickerView *picker;
-(IBAction)clickedPrev;
-(IBAction)clickedNext;
-(IBAction)closeCategory;
@end