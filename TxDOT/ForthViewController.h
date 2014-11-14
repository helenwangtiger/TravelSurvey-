//
//  ForthViewController.h
//  TxDOT
//
//  Created by Qian on 6/14/13.
//  Copyright (c) 2013 Qian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForthViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate> {
    NSArray *listData;
    NSMutableArray *searchResults;
    IBOutlet UITableView *tableview;
    NSString *tripName;
}
@property(nonatomic,retain) NSArray *listData;
@property(nonatomic,retain) IBOutlet UITableView *tableview;
@property(nonatomic,retain) NSMutableArray *searchResults;
@property(nonatomic, copy) NSString *savedSearchTerm;
@property(nonatomic,retain) NSString *tripName;

@end
