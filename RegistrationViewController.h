//
//  RegistrationViewController.h
//  TxDOT
//
//  Created by Qian on 6/10/14.
//  Copyright (c) 2014 Qian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistrationViewController : UIViewController {
    IBOutlet  UILabel *titleLabel;
    IBOutlet  UILabel *firstNameLabel;
    IBOutlet  UILabel *lastNameLabel;
    IBOutlet  UILabel *emailLabel;
    IBOutlet  UILabel *addressLabel;
    IBOutlet  UITextView *textView;
    IBOutlet  UITextField *firstNameField;
    IBOutlet  UITextField *lastNameField;
    IBOutlet  UITextField *emailField;
    IBOutlet  UITextField *addressField;
    IBOutlet  UIButton *agree;
    IBOutlet  UIView *registrationView;
    IBOutlet  UIView *informedView;
    IBOutlet  UIButton *signup;
    IBOutlet  UIButton *back;
}
@property (nonatomic, retain)IBOutlet  UILabel *titleLabel;
@property (nonatomic, retain)IBOutlet  UILabel *firstNameLabel;
@property (nonatomic, retain)IBOutlet  UILabel *lastNameLabel;
@property (nonatomic, retain)IBOutlet  UILabel *emailLabel;
@property (nonatomic, retain)IBOutlet  UILabel *addressLabel;

@property (nonatomic, retain)IBOutlet  UITextView *textView;
@property (nonatomic, retain)IBOutlet  UITextField *firstNameField;
@property (nonatomic, retain)IBOutlet  UITextField *lastNameField;
@property (nonatomic, retain)IBOutlet  UITextField *emailField;
@property (nonatomic, retain)IBOutlet  UITextField *addressField;
@property (nonatomic, retain)IBOutlet  UIButton *agree;
@property (nonatomic, retain)IBOutlet  UIView *registrationView;
@property (nonatomic, retain)IBOutlet  UIView *informedView;
@property (nonatomic, retain)IBOutlet  UIButton *signup;
@property (nonatomic, retain)IBOutlet  UIButton *back;
@end
