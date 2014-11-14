//
//  RegistrationViewController.m
//  TxDOT
//
//  Created by Qian on 6/10/14.
//  Copyright (c) 2014 Qian. All rights reserved.
//

#import "RegistrationViewController.h"

@interface RegistrationViewController ()

@end
@implementation NSString (NSString_Extended)

- (NSString *)urlencode {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    int sourceLen = (int)strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

@end

@implementation RegistrationViewController
@synthesize titleLabel,firstNameLabel,lastNameLabel,emailLabel,addressLabel,textView,firstNameField,lastNameField,emailField,addressField,agree,registrationView,signup,informedView,back;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"view did appear");
    float sysversion= [[[UIDevice currentDevice]systemVersion]floatValue];
    CGSize screensize= [[UIScreen mainScreen]bounds].size;
    if(sysversion >=6.0 &&   sysversion <7.0){
        if(screensize.height <500){
            NSLog(@"fuction call");
            [titleLabel setFrame:CGRectMake(5, 10, 300, 20)];
            [textView setFrame:CGRectMake(5, 45, 310, 325)];
            [agree setFrame:CGRectMake(10, 390, 300, 40)];
            agree.titleLabel.font = [UIFont systemFontOfSize:10.0];
        
        }

        // iphone 4 inch
        if(screensize.height>500){
            [titleLabel setFrame:CGRectMake(5, 10, 300, 20)];
            [textView setFrame:CGRectMake(5, 50, 310, 400)];
            [agree setFrame:CGRectMake(10, 480, 300, 40)];
            agree.titleLabel.font = [UIFont systemFontOfSize:10.0];
        }
    }
    if (sysversion >= 7.0) {
        //3.5 inch
        if (screensize.height < 500) {
             NSLog(@"fuction call");
            [titleLabel setFrame:CGRectMake(5, 25, 300, 20)];
            [textView setFrame:CGRectMake(5, 60, 310, 325)];
            [agree setFrame:CGRectMake(10, 390, 300, 40)];
            agree.titleLabel.font = [UIFont systemFontOfSize:10.0];
            
        }
        //4 inch
        if (screensize.height > 500) {
            [titleLabel setFrame:CGRectMake(5, 25, 300, 20)];
            [textView setFrame:CGRectMake(5, 60, 310, 400)];
            [agree setFrame:CGRectMake(10, 480, 300, 40)];
            agree.titleLabel.font = [UIFont systemFontOfSize:10.0];

        }
        
    }


}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
-(void) frameOfSign {

    NSLog(@"frameofsign");
    float sysversion= [[[UIDevice currentDevice]systemVersion]floatValue];
    CGSize screensize= [[UIScreen mainScreen]bounds].size;
    if(sysversion >=6.0 &&   sysversion <7.0){
        if(screensize.height <500){
             [firstNameLabel setFrame:CGRectMake(15, 10, 120, 25)];
             [firstNameField setFrame:CGRectMake(140, 10, 150, 30)];
             [firstNameField addTarget:self action:@selector(textFieldFinished:)forControlEvents:UIControlEventEditingDidEndOnExit];
             [lastNameLabel setFrame:CGRectMake(15, 45, 120, 25)];
             [lastNameField setFrame:CGRectMake(140, 45, 150, 30)];
             [lastNameField addTarget:self action:@selector(textFieldFinished:)forControlEvents:UIControlEventEditingDidEndOnExit];
             [emailLabel setFrame:CGRectMake(15, 80, 120, 25)];
             [emailField setFrame:CGRectMake(140, 80, 150, 30)];
             [emailField addTarget:self action:@selector(textFieldFinished:)forControlEvents:UIControlEventEditingDidEndOnExit];
             [addressLabel setFrame:CGRectMake(15, 115, 120, 25)];
             [addressField setFrame:CGRectMake(140, 115, 150, 30)];
             [addressField addTarget:self action:@selector(textFieldFinished:)forControlEvents:UIControlEventEditingDidEndOnExit];
             [back setFrame:CGRectMake(15, 170, 80, 40)];
             [signup setFrame:CGRectMake(210, 170, 80, 40)];
            
        }
        
        
        // iphone 4 inch
        if(screensize.height>500){
            [firstNameLabel setFrame:CGRectMake(15, 25, 120, 25)];
            [firstNameField setFrame:CGRectMake(140, 25, 150, 30)];
            [firstNameField addTarget:self action:@selector(textFieldFinished:)forControlEvents:UIControlEventEditingDidEndOnExit];
            [lastNameLabel setFrame:CGRectMake(15, 60, 120, 25)];
            [lastNameField setFrame:CGRectMake(140, 60, 150, 30)];
            [lastNameField addTarget:self action:@selector(textFieldFinished:)forControlEvents:UIControlEventEditingDidEndOnExit];
            [emailLabel setFrame:CGRectMake(15, 95, 120, 25)];
            [emailField setFrame:CGRectMake(140, 95, 150, 30)];
            [emailField addTarget:self action:@selector(textFieldFinished:)forControlEvents:UIControlEventEditingDidEndOnExit];
            [addressLabel setFrame:CGRectMake(15, 130, 120, 25)];
            [addressField setFrame:CGRectMake(140, 130, 150, 30)];
            [addressField addTarget:self action:@selector(textFieldFinished:)forControlEvents:UIControlEventEditingDidEndOnExit];
            [back setFrame:CGRectMake(15, 200, 80, 40)];
            [signup setFrame:CGRectMake(210, 200, 80, 40)];

            
        }
    }
    if (sysversion >= 7.0) {
        //3.5 inch
        if (screensize.height < 500) {
            [firstNameLabel setFrame:CGRectMake(15, 25, 120, 25)];
            [firstNameField setFrame:CGRectMake(140, 27, 150, 30)];
            [firstNameField addTarget:self action:@selector(textFieldFinished:)forControlEvents:UIControlEventEditingDidEndOnExit];
            [lastNameLabel setFrame:CGRectMake(15, 70, 120, 25)];
            [lastNameField setFrame:CGRectMake(140, 70, 150, 30)];
            [lastNameField addTarget:self action:@selector(textFieldFinished:)forControlEvents:UIControlEventEditingDidEndOnExit];
            [emailLabel setFrame:CGRectMake(15, 113, 120, 25)];
            [emailField setFrame:CGRectMake(140, 113, 150,30)];
            [emailField addTarget:self action:@selector(textFieldFinished:)forControlEvents:UIControlEventEditingDidEndOnExit];
            [addressLabel setFrame:CGRectMake(15, 156, 120, 25)];
            [addressField setFrame:CGRectMake(140, 156, 150, 30)];
            [addressField addTarget:self action:@selector(textFieldFinished:)forControlEvents:UIControlEventEditingDidEndOnExit];
            [back setFrame:CGRectMake(10, 210, 80, 40)];
            [signup setFrame:CGRectMake(210, 210, 80, 40)];
        }
        //4 inch
        if (screensize.height > 500) {
            [firstNameLabel setFrame:CGRectMake(15, 45, 120, 25)];
            [firstNameField setFrame:CGRectMake(140, 47, 150, 30)];
            [firstNameField addTarget:self action:@selector(textFieldFinished:)forControlEvents:UIControlEventEditingDidEndOnExit];
            [lastNameLabel setFrame:CGRectMake(15, 90, 120, 25)];
            [lastNameField setFrame:CGRectMake(140, 90, 150, 30)];
            [lastNameField addTarget:self action:@selector(textFieldFinished:)forControlEvents:UIControlEventEditingDidEndOnExit];
            [emailLabel setFrame:CGRectMake(15, 133, 120, 25)];
            [emailField setFrame:CGRectMake(140, 133, 150,30)];
            [emailField addTarget:self action:@selector(textFieldFinished:)forControlEvents:UIControlEventEditingDidEndOnExit];
            [addressLabel setFrame:CGRectMake(15, 176, 120, 25)];
            [addressField setFrame:CGRectMake(140, 176, 150, 30)];
            [addressField addTarget:self action:@selector(textFieldFinished:)forControlEvents:UIControlEventEditingDidEndOnExit];
            [back setFrame:CGRectMake(10, 230, 80, 40)];
            [signup setFrame:CGRectMake(210, 230, 80, 40)];

            
        }
        
    }
    





}
-(IBAction) backToInformed{

    [self.registrationView removeFromSuperview];

}



-(IBAction)singUpReg{
    //send information to database;
    //[self resignFirstResponder];
    NSString *firstName = firstNameField.text;
    NSString *lastName = lastNameField.text;
    NSString *emailAddress = emailField.text;
    NSString *homeAddress = addressField.text;
    if(firstName ==nil || [firstName isEqualToString:@""] || lastName == nil || [lastName isEqualToString:@""] || emailAddress == nil || [emailAddress isEqualToString:@""] || homeAddress == nil || [homeAddress isEqualToString:@""]){
        UIAlertView *empty_alert = [[UIAlertView alloc]initWithTitle: nil message:@"You have blank field of registration, please check your registration information." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [empty_alert show];
    
    
    }
    else{
   
        NSString *stringOfSubmit = [NSString stringWithFormat:@"http://129.120.61.219/txdot_qian/response.php?first_name=%@&last_name=%@&email_address=%@&home_address=%@",[firstName urlencode],[lastName urlencode],[emailAddress urlencode],[homeAddress urlencode]] ;
        NSLog(@"string of sumitb %@",stringOfSubmit);
        NSURL *url_registration = [NSURL URLWithString:stringOfSubmit];
        NSLog(@"url string %@",url_registration);
        NSURLRequest *request_registration= [NSURLRequest requestWithURL:url_registration];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc]init];
        [NSURLConnection sendAsynchronousRequest:request_registration queue:queue  completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(data != nil){
            NSString *sample_number = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"sample_number %@",sample_number);
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success" message:@"You have successfully registered for the Household Travel Survey" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [[NSUserDefaults standardUserDefaults] setObject:sample_number forKey:@"sample_number"];
                [[NSUserDefaults  standardUserDefaults] setObject:homeAddress forKey:@"address"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self dismissViewControllerAnimated:YES completion:nil];
            });
            
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please check your Internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            });
        }
                           
            
        }];

    
    }

}
- (IBAction)textFieldFinished:(id)sender
{
    [sender resignFirstResponder];
}
-(IBAction) agreeRegistration{
    [self.view addSubview:registrationView];
    [self frameOfSign];


}
- (void)viewDidLoad
{

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
