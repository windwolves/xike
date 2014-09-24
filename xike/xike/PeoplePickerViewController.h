//
//  PeoplePickerViewController.h
//  xike
//
//  Created by Leading Chen on 14-9-11.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <AddressBookUI/AddressBookUI.h>
#import "CRJContactPickerView.h"
#import "XikeDatabase.h"
#import "EventInfo.h"

@protocol PeoplePickerViewControllerDelegate <NSObject>

- (void)DidSendEvent:(EventInfo *)event;

@end

@interface PeoplePickerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CRJContactPickerViewDelegate, ABPersonViewControllerDelegate,MFMessageComposeViewControllerDelegate>
@property (nonatomic, strong) CRJContactPickerView *contactPickerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listContacts;
@property (nonatomic, strong) NSArray *contacts;
@property (nonatomic, strong) NSMutableArray *selectedContacts;
@property (nonatomic, strong) NSArray *filteredContacts;
@property (nonatomic, strong) NSString *sendOutContent;
@property (nonatomic, strong) XikeDatabase *database;
@property (nonatomic, strong) EventInfo *event;
@property (nonatomic, strong) id <PeoplePickerViewControllerDelegate> delegate;
@end
