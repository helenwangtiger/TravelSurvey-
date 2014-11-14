//
//  NavigationTripViewController.h
//  TxDOT
//
//  Created by Qian on 10/19/13.
//  Copyright (c) 2013 Qian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationTripViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
    NSArray *questionTitleTrip;
    NSArray *questionDescTrip;
    NSMutableArray *answerTrip;
    NSMutableArray *pickerChoices;
    int questionInt;
    int totalInt;
    IBOutlet UILabel *questionNum;
    IBOutlet UILabel *questionTotalNum;
    IBOutlet UILabel *recordType;
    IBOutlet UITextView *questionDes;
    IBOutlet UIView *answerView;
    IBOutlet UIButton *preButton;
    IBOutlet UIButton *nextButton;
    UITextField *text;
    UIPickerView *picker;








}
@property (retain, nonatomic) NSArray *questionTitleTrip;
@property (retain, nonatomic) NSArray *questionDescTrip;
@property (retain, nonatomic) NSMutableArray *answerTrip;
@property (retain, nonatomic) NSMutableArray *pickerChoices;
@property (retain, nonatomic) IBOutlet UILabel *questionNum;
@property (retain, nonatomic) IBOutlet UILabel *questionTotalNum;
@property (retain, nonatomic) IBOutlet UILabel *recordType;
@property (retain, nonatomic) IBOutlet UITextView *questionDes;
@property (retain, nonatomic) IBOutlet UIView *answerView;
@property (retain, nonatomic) IBOutlet UIButton *preButton;
@property (retain, nonatomic) IBOutlet UIButton *nextButton;
@property (retain, nonatomic) UITextField *text;
@property (retain, nonatomic) UIPickerView *picker;
-(IBAction)clickPre;
-(IBAction)clickNext;
-(IBAction)changeButtonTitleDone;
-(IBAction)changeButtonTitleNext;
@end
