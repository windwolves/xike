//
//  NotificationViewController.m
//  xike
//
//  Created by Leading Chen on 14/11/13.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "NotificationViewController.h"
#import "ColorHandler.h"
#import "NotificationTableViewCell.h"
#import "PreViewController.h"
#import "EventInfo.h"

@interface NotificationViewController ()

@end

@implementation NotificationViewController {
    UITableView *notificationsTable;
    NSMutableArray *messagesArray;
}

- (void)viewWillAppear:(BOOL)animated {
    messagesArray = [_database getAllNotificationMessage:_user.userID];
    if (notificationsTable) {
        [notificationsTable removeFromSuperview];
    }
    if ([messagesArray count] != 0) {
        [self.view addSubview:notificationsTable];
        [notificationsTable reloadData];
    } else {
        //TODO
    }
    //TestUse
    //[self testMessage];
    //[self.view addSubview:notificationsTable];
    //[notificationsTable reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    for (NotificationMessage *notification in messagesArray) {
        notification.isRead = 1;
        [_database updateNotification:notification];
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //TestUse
    [self testMessage];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"预览"];
    self.view.backgroundColor = [ColorHandler colorWithHexString:@"#ffffff"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UIBarButtonItem *returnBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(returnToPreviousView)];
    [self.navigationItem setLeftBarButtonItem:returnBtn];
    
    notificationsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    notificationsTable.delegate = self;
    notificationsTable.dataSource = self;
    notificationsTable.rowHeight = 82;
    [notificationsTable registerClass:[NotificationTableViewCell class] forCellReuseIdentifier:@"NotificationCell"];
}

- (void)returnToPreviousView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)testMessage {
    NotificationMessage *testMessage = [NotificationMessage new];
    testMessage.ID = 0;
    testMessage.content = @"小鹿 加入了您的活动";
    testMessage.pic = UIImagePNGRepresentation([UIImage imageNamed:@"y001"]);
    testMessage.eventUUID = @"ec1e6277-84d3-4246-a817-e4e9f56cd194";
    testMessage.user = @"7163dd98-cea8-4520-bb55-2e4786770a70";
    
    [messagesArray addObject:testMessage];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark UITableView DataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [messagesArray count];
}

- (NotificationTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationCell" forIndexPath:indexPath];
    [cell setNotification:[messagesArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //Delete the event
        NotificationMessage *notificationToDelete = [messagesArray objectAtIndex:indexPath.row];
        [_database deleteNotification:notificationToDelete];
        messagesArray = [_database getAllNotificationMessage:_user.userID];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [notificationsTable reloadData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NotificationMessage *notification = [messagesArray objectAtIndex:indexPath.row];
    EventInfo *event = [EventInfo new];
    event.uuid = notification.eventUUID;
    PreViewController *previewController = [PreViewController new];
    previewController.database = _database;
    previewController.event = event;
    
    [self.navigationController pushViewController:previewController animated:YES];
    
    
}

@end
