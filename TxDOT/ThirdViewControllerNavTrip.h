//
//  ThirdViewControllerNavTrip.h
//  TxDOT
//
//  Created by Qian on 10/22/13.
//  Copyright (c) 2013 Qian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThirdViewControllerNavTrip : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
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
    IBOutlet UINavigationBar *topBar;
    UIAlertView *sampleNumAlert;
    NSString *startTime;
    NSString *endTime;
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
@property (retain, nonatomic) IBOutlet UINavigationBar *topBar;
@property (retain, nonatomic) UIPickerView *picker;
@property (nonatomic) NSString *tripName;
@property (retain,  nonatomic) UIAlertView *sampleNumAlert;
@property(nonatomic,retain) NSString *startTime;
@property(nonatomic,retain) NSString *endTime;

-(IBAction)clickPre;
-(IBAction)clickNext;

@end
