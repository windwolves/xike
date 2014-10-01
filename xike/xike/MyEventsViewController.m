//
//  MyEventsViewController.m
//  xike
//
//  Created by Leading Chen on 14-8-31.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "MyEventsViewController.h"
#import "ColorHandler.h"
#import "EventCell.h"
#import "PreViewController.h"


@interface MyEventsViewController ()


@end

@implementation MyEventsViewController {
    NSMutableArray *eventsArray;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    eventsArray = [_database getAllEvents :_user];
    [_eventsTable reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 135)];
    //user_background_imageView
    if (_user.backgroundPic) {
        _backImageView.image = [UIImage imageWithData:_user.backgroundPic];
    } else {
        _backImageView.image = [UIImage imageNamed:@"user_bg_default"];;
    }
    [self.view addSubview:_backImageView];
    
    //user_pic_imageView
    UIImageView *userPicBorderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(160-36, 22, 72, 72)];
    userPicBorderImageView.image = [UIImage imageNamed:@"user_pic_border"];
    _pictureView = [[UIImageView alloc] initWithFrame:CGRectMake(160-36+2, 22+2, 68, 68)];
    _pictureView.layer.cornerRadius = CGRectGetHeight(_pictureView.bounds) / 2;
    _pictureView.clipsToBounds = YES;
    if (_user.photo) {
        _pictureView.image = [UIImage imageWithData:_user.photo];
    } else {
        _pictureView.image = [UIImage imageNamed:@"user_pic_default"];
    }
    
    _nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 12)];
    if (_user.name) {
        _nicknameLabel.text = _user.name;
    } else {
        _nicknameLabel.text = _user.userID;
    }
    _nicknameLabel.textAlignment = NSTextAlignmentCenter;
    _nicknameLabel.textColor = [ColorHandler colorWithHexString:@"#413445"];
    _nicknameLabel.font = [UIFont systemFontOfSize:12];
    
    [_backImageView addSubview:_nicknameLabel];
    [_backImageView addSubview:userPicBorderImageView];
    [_backImageView addSubview:_pictureView];
    [self.view addSubview:_backImageView];
   
    //Events table
    _eventsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 135, self.view.bounds.size.width, self.view.bounds.size.height - 135 - 49-64)];
    _eventsTable.dataSource = self;
    _eventsTable.delegate = self;
    _eventsTable.backgroundColor = [UIColor whiteColor];
    _eventsTable.rowHeight = 85;
    [_eventsTable registerClass:[EventsTableViewCell class] forCellReuseIdentifier:@"EventCell"];
    
    
    [self.view addSubview:_eventsTable];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark UITableView DataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [eventsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier];
    }
    EventInfo *event = [eventsArray objectAtIndex:indexPath.row];

    if ([[cell.contentView subviews] count] > 0) {
        [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    EventCell *eventCell = [[EventCell alloc] initWithFrame:cell.bounds Event:event];
    [cell.contentView addSubview:eventCell];
    */
    EventsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventCell" forIndexPath:indexPath];
    [cell setEvent:[eventsArray objectAtIndex:indexPath.row]];
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
       //Delete the event
        EventInfo *eventToDelete = [eventsArray objectAtIndex:indexPath.row];
        [_database deleteEvent:eventToDelete];
        eventsArray = [_database getAllEvents :_user];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [_eventsTable reloadData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PreViewController *preViewController = [PreViewController new];
    preViewController.database = _database;
    preViewController.event = [eventsArray objectAtIndex:indexPath.row];
    preViewController.fromController = @"eventsTable";
    [self.navigationController pushViewController:preViewController animated:YES];
}

#pragma mark EventsTableViewCellDelegate
- (TemplateInfo *)getTemplateByID:(NSString *)templateID {
    TemplateInfo *template = [_database getTemplate:templateID];
    return template;
}


@end
