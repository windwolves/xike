//
//  PeoplePickerViewController.m
//  xike
//
//  Created by Leading Chen on 14-9-11.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "PeoplePickerViewController.h"
#import <MessageUI/MessageUI.h>
#import "CRJContactPickerView.h"
#import "CRJContact.h"
#import "CRJContactTableViewCell.h"
#import "PeopleInfo.h"
#import "ColorHandler.h"

@interface PeoplePickerViewController () {
    UIBarButtonItem *barButton;
    NSMutableArray *recipients;
    UIPanGestureRecognizer *tapGesture;
}
@property (nonatomic, assign) ABAddressBookRef addressBookRef;

@end

@implementation PeoplePickerViewController
#define kKeyboardHeight 0.0
#define MESSAGE_SENT @"Result: SMS sent"
#define PersonPhoneWorkLabel @"_$!<Work>!$_"

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"选择好友"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.view.backgroundColor = [ColorHandler colorWithHexString:@"#f6f6f6"];
    CFErrorRef error;
    _addressBookRef = ABAddressBookCreateWithOptions(NULL, &error);
    barButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
    barButton.enabled = FALSE;
    [self.navigationItem setRightBarButtonItem:barButton];
    //Initialize and add Contact Picker View
    self.contactPickerView = [[CRJContactPickerView alloc] initWithFrame:CGRectMake(15, 69, self.view.frame.size.width-30, 20)];
    self.contactPickerView.delegate = self;
    [self.contactPickerView setPlaceholderString:@"Type contact name"];
    [self.view addSubview:self.contactPickerView];
    
    // Fill the rest of the view with the table view
    tapGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(removeKeyborad)];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.contactPickerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.contactPickerView.frame.size.height - kKeyboardHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [ColorHandler colorWithHexString:@"#f6f6f6"];
    //self.tableView.layer.contents = (id)[UIImage imageNamed:@"bg_blur.png"].CGImage;
    self.tableView.sectionIndexColor = [UIColor blackColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexTrackingBackgroundColor = [ColorHandler colorWithHexString:@"1de9b6"];
    //Initial Array
    _listContacts = [NSMutableArray new];
    
    [self.view insertSubview:self.tableView belowSubview:self.contactPickerView];
    
    ABAddressBookRequestAccessWithCompletion(self.addressBookRef, ^(bool granted, CFErrorRef error) {
        if (granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self getContactsFromAddressBook];
            });
        } else {
            // TODO: Show alert
            [self showAlertView:@"不能取得通讯录"];
        }
    });

}


- (void)removeKeyborad {
    [self.contactPickerView resignKeyboard];
    [self.tableView removeGestureRecognizer:tapGesture];
}

-(void)getContactsFromAddressBook
{
    CFErrorRef error = NULL;
    self.contacts = [[NSMutableArray alloc]init];
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    if (addressBook) {
        NSArray *allContacts = (__bridge_transfer NSArray*)ABAddressBookCopyArrayOfAllPeople(addressBook);
        NSMutableArray *mutableContacts = [NSMutableArray arrayWithCapacity:allContacts.count];
        
        NSUInteger i = 0;
        for (i = 0; i<[allContacts count]; i++)
        {
            CRJContact *contact = [[CRJContact alloc] init];
            ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];
            contact.recordId = ABRecordGetRecordID(contactPerson);
            
            // Get first and last names
            NSString *firstName = (__bridge_transfer NSString*)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
            NSString *lastName = (__bridge_transfer NSString*)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
            // Set Contact properties
            contact.firstName = firstName;
            contact.lastName = lastName;
            contact.sortedName = [contact sortedName];
            
            // Get mobile number
            ABMultiValueRef phonesRef = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
            contact.phone = [self getMobilePhoneProperty:phonesRef];
            if(phonesRef) {
                CFRelease(phonesRef);
            }
            
            // Get image if it exists
            NSData  *imgData = (__bridge_transfer NSData *)ABPersonCopyImageData(contactPerson);
            contact.image = [UIImage imageWithData:imgData];
            if (!contact.image) {
                //contact.image = [UIImage imageNamed:@"icon-avatar-60x60"];
            }
            
            [mutableContacts addObject:contact];
        }
        
        if(addressBook) {
            CFRelease(addressBook);
        }
        
        //sort data
        UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
        for (CRJContact *contact in mutableContacts) {
            NSInteger sect = [theCollation sectionForObject:contact collationStringSelector:@selector(sortedName)];
            contact.sectionNumber = sect;
        }
        NSInteger highSection = [[theCollation sectionTitles] count];
        NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
        for (int i = 0; i<=highSection; i++) {
            NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
            [sectionArrays addObject:sectionArray];
        }
        for (CRJContact *contact in mutableContacts) {
            [(NSMutableArray *)[sectionArrays objectAtIndex:contact.sectionNumber] addObject:contact];
        }
        for (NSMutableArray *sectionArray in sectionArrays) {
            NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(sortedName)];
            [_listContacts addObject:sortedSection];
        }
        
        
        self.contacts = [NSArray arrayWithArray:_listContacts];
        self.selectedContacts = [NSMutableArray array];
        self.filteredContacts = self.contacts;
        
        [self.tableView reloadData];
    }
    else
    {
        NSLog(@"Error");
        
    }
}


- (NSString *)getMobilePhoneProperty:(ABMultiValueRef)phonesRef
{
    for (int i=0; i < ABMultiValueGetCount(phonesRef); i++) {
        CFStringRef currentPhoneLabel = ABMultiValueCopyLabelAtIndex(phonesRef, i);
        CFStringRef currentPhoneValue = ABMultiValueCopyValueAtIndex(phonesRef, i);
        if(currentPhoneLabel) {
            if (CFStringCompare(currentPhoneLabel, kABPersonPhoneMobileLabel, 0) == kCFCompareEqualTo) {
                return ((__bridge NSString *)currentPhoneValue);
            }
            
            if (CFStringCompare(currentPhoneLabel, kABHomeLabel, 0) == kCFCompareEqualTo) {
                return ((__bridge NSString *)currentPhoneValue);
            }
            if (CFStringCompare(currentPhoneLabel, kABPersonPhoneIPhoneLabel, 0) == kCFCompareEqualTo) {
                return ((__bridge NSString *)currentPhoneValue);
            }
            if (CFStringCompare(currentPhoneLabel, kABPersonPhoneMainLabel, 0) == kCFCompareEqualTo) {
                return ((__bridge NSString *)currentPhoneValue);
            }
            if ([(__bridge NSString *)currentPhoneLabel isEqualToString:PersonPhoneWorkLabel]) {
                return ((__bridge NSString *)currentPhoneValue);
            }
            else {
                return ((__bridge NSString *)currentPhoneValue);
            }
        }
        if(currentPhoneLabel) {
            CFRelease(currentPhoneLabel);
        }
        if(currentPhoneValue) {
            CFRelease(currentPhoneValue);
        }
    }
    
    return nil;
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat topOffset = 6;
    if ([self respondsToSelector:@selector(topLayoutGuide)]){
        topOffset = self.topLayoutGuide.length+6;
    }
    CGRect frame = self.contactPickerView.frame;
    frame.origin.y = topOffset;
    self.contactPickerView.frame = frame;
    [self adjustTableViewFrame:NO];
}

- (void)adjustTableViewFrame:(BOOL)animated {
    CGRect frame = self.tableView.frame;
    // This places the table view right under the text field
    frame.origin.y = self.contactPickerView.frame.size.height+12;
    // Calculate the remaining distance
    frame.size.height = self.view.frame.size.height - self.contactPickerView.frame.size.height - kKeyboardHeight;
    
    if(animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelay:0.1];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        self.tableView.frame = frame;
        
        [UIView commitAnimations];
    }
    else{
        self.tableView.frame = frame;
    }
}

#pragma mark - UITableView Delegate and Datasource functions
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 0;
    } else {
        if (title == UITableViewIndexSearch) {
            [tableView scrollRectToVisible:self.searchDisplayController.searchBar.frame animated:NO];
            return -1;
        } else {
            return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index-1];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
	} else {
        return [self.filteredContacts count];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        UIView *headerView = [UIView new];
        //headerView.layer.contents = (id)[UIImage imageNamed:@"section_header.png"].CGImage;
        headerView.backgroundColor = [ColorHandler colorWithHexString:@"#1de9b6"];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, 20, 23)];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.text = [[self.filteredContacts objectAtIndex:section] count] ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
        
        [headerView addSubview:titleLabel];
        return headerView;
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        return [[self.filteredContacts objectAtIndex:section] count] ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
        return 0;
    return [[self.filteredContacts objectAtIndex:section] count] ? 23 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.filteredContacts count];
    } else {
        return [[self.filteredContacts objectAtIndex:section] count];
    }
}

- (CGFloat)tableView: (UITableView*)tableView heightForRowAtIndexPath: (NSIndexPath*) indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Get the desired contact from the filteredContacts array
    CRJContact *contact = [CRJContact new];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        contact = [self.filteredContacts objectAtIndex:indexPath.row];
    } else {
        contact = [[self.filteredContacts objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    
    // Initialize the table view cell
    NSString *cellIdentifier = @"ContactCell";
    CRJContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil){
        cell = [[CRJContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // Assign values to to US elements
    cell.backgroundColor = [UIColor clearColor];
    cell.fullNameLabel.text = [contact fullName];
    //cell.fullNameLabel.font = [UIFont systemFontOfSize:12];
    cell.fullNameLabel.textColor = [UIColor blackColor];
    cell.numberLabel.text = contact.phone;
    //cell.numberLabel.font = [UIFont systemFontOfSize:10];
    cell.numberLabel.textColor = [UIColor blackColor];
    if(contact.image) {
        cell.pictureImageView.image = contact.image;
    }
    cell.pictureImageView.clipsToBounds = YES;
    cell.pictureImageView.layer.cornerRadius = CGRectGetHeight(cell.pictureImageView.bounds) / 2;
    
    // Set the checked state for the contact selection checkbox
    UIImage *image;
    
    if ([self.selectedContacts containsObject:contact]){
        //cell.accessoryType = UITableViewCellAccessoryCheckmark;
        image = [UIImage imageNamed:@"icon-checkbox-selected-green-25x25"];
    } else {
        //cell.accessoryType = UITableViewCellAccessoryNone;
        image = [UIImage imageNamed:@"icon-checkbox-unselected-25x25"];
    }
    cell.checkboxImageView.image = image;
    
    // Assign a UIButton to the accessoryView cell property
    //cell.accessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    // Set a target and selector for the accessoryView UIControlEventTouchUpInside
    //[(UIButton *)cell.accessoryView addTarget:self action:@selector(viewContactDetail:) forControlEvents:UIControlEventTouchUpInside];
    //cell.accessoryView.tag = contact.recordId; //so we know which ABRecord in the IBAction method
    
    // // For custom accessory view button use this.
    //    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    //    button.frame = CGRectMake(0.0f, 0.0f, 150.0f, 25.0f);
    //
    //    [button setTitle:@"Expand"
    //            forState:UIControlStateNormal];
    //
    //    [button addTarget:self
    //               action:@selector(viewContactDetail:)
    //     forControlEvents:UIControlEventTouchUpInside];
    //
    //    cell.accessoryView = button;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Hide Keyboard
    [self.contactPickerView resignKeyboard];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    // This uses the custom cellView
    // Set the custom imageView
    CRJContact *user = [[self.filteredContacts objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    UIImageView *checkboxImageView = (UIImageView *)[cell viewWithTag:104];
    UIImage *image;
    if (user.phone) {
        if ([self.selectedContacts containsObject:user]){ // contact is already selected so remove it from ContactPickerView
            //cell.accessoryType = UITableViewCellAccessoryNone;
            [self.selectedContacts removeObject:user];
            [self.contactPickerView removeContact:user];
            // Set checkbox to "unselected"
            image = [UIImage imageNamed:@"icon-checkbox-unselected-25x25"];
        } else {
            // Contact has not been selected, add it to THContactPickerView
            //cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [self.selectedContacts addObject:user];
            [self.contactPickerView addContact:user withName:user.fullName];
            // Set checkbox to "selected"
            image = [UIImage imageNamed:@"icon-checkbox-selected-green-25x25"];
        }
    } else {
        [self showAlertView:@"This contact doesn't contain a phone number!"];
    }
    
    
    // Enable Done button if total selected contacts > 0
    if(self.selectedContacts.count > 0) {
        barButton.enabled = TRUE;
    }
    else
    {
        barButton.enabled = FALSE;
    }
    
    // Set checkbox image
    checkboxImageView.image = image;
    // Reset the filtered contacts
    self.filteredContacts = self.contacts;
    // Refresh the tableview
    [self.tableView reloadData];
}


- (void)done:(id) sender {
    recipients = [NSMutableArray new];
    //set event.guestList
    NSMutableArray *guestList = [NSMutableArray new];
    for (CRJContact *user in self.selectedContacts) {
        [recipients addObject:user.phone];
        
        PeopleInfo *guest = [PeopleInfo new];
        guest.user_id = @""; //how to get this?
        guest.name = [user fullName];
        guest.phone = user.phone;
        guest.photo = UIImageJPEGRepresentation(user.image, 0.0);
        [guestList addObject:guest];
    }
    _event.guestList = guestList;
    //[self.delegate DidSendEvent:_event];//This line is for test use.
    if ([MFMessageComposeViewController canSendText]) {
        [self displaySMSComposerSheet];
    } else {
        [self showAlertView:@"Can not send text message!"];
    }
    
}

#pragma alertView
- (void)showAlertView:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    if ([message  isEqual: MESSAGE_SENT]) {
        alertView.tag = 1;
    } else {
        alertView.tag = 0;
    }
    [alertView show];
}
//AlertView Action
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        [self.delegate DidSendEvent:_event];
    }
}
#pragma SMS Composer
- (void)displaySMSComposerSheet {
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
	picker.messageComposeDelegate = self;
	picker.recipients = recipients;
    picker.body = _sendOutContent;
    
	[self presentViewController:picker animated:YES completion:NULL];
    
}

// -------------------------------------------------------------------------------
//	messageComposeViewController:didFinishWithResult:
//  Dismisses the message composition interface when users tap Cancel or Send.
//  Proceeds to update the feedback message field with the result of the
//  operation.
// -------------------------------------------------------------------------------
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MessageComposeResultCancelled:
            [self showAlertView:@"Result: SMS sending canceled"];
			break;
		case MessageComposeResultSent:
            [self showAlertView:MESSAGE_SENT];
			break;
		case MessageComposeResultFailed:
            [self showAlertView:@"Result: SMS sending failed"];
			break;
		default:
            [self showAlertView:@"Result: SMS not sent"];
			break;
	}
    
	[self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - CRJContactPickerTextViewDelegate
- (void)contactPickerTextViewDidBeginEditing {
    [self.tableView addGestureRecognizer:tapGesture];
}

- (void)contactPickerTextViewDidChange:(NSString *)textViewText {
    if ([textViewText isEqualToString:@""]){
        self.filteredContacts = self.contacts;
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.%@ contains[cd] %@ OR self.%@ contains[cd] %@", @"firstName", textViewText, @"lastName", textViewText];
        self.filteredContacts = [self.contacts filteredArrayUsingPredicate:predicate];
    }
    [self.tableView reloadData];
}

- (void)contactPickerDidResize:(CRJContactPickerView *)contactPickerView {
    [self adjustTableViewFrame:YES];
}

- (void)contactPickerDidRemoveContact:(id)contact {
    [self.selectedContacts removeObject:contact];
    
    NSUInteger index = [self.contacts indexOfObject:contact];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    //cell.accessoryType = UITableViewCellAccessoryNone;
    
    // Enable Done button if total selected contacts > 0
    if(self.selectedContacts.count > 0) {
        barButton.enabled = TRUE;
    }
    else
    {
        barButton.enabled = FALSE;
    }
    
    // Set unchecked image
    UIImageView *checkboxImageView = (UIImageView *)[cell viewWithTag:104];
    UIImage *image;
    image = [UIImage imageNamed:@"icon-checkbox-unselected-25x25"];
    checkboxImageView.image = image;
    
    // Update window title
    //self.title = [NSString stringWithFormat:@"Add Members (%lu)", (unsigned long)self.selectedContacts.count];
}

- (void)removeAllContacts:(id)sender
{
    [self.contactPickerView removeAllContacts];
    [self.selectedContacts removeAllObjects];
    self.filteredContacts = self.contacts;
    [self.tableView reloadData];
}
#pragma mark ABPersonViewControllerDelegate

- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return YES;
}


// This opens the apple contact details view: ABPersonViewController
// make a CRJContactPickerDetailViewController
- (void)viewContactDetail:(UIButton*)sender {
    ABRecordID personId = (ABRecordID)sender.tag;
    ABPersonViewController *view = [[ABPersonViewController alloc] init];
    view.addressBook = self.addressBookRef;
    view.personViewDelegate = self;
    view.displayedPerson = ABAddressBookGetPersonWithRecordID(self.addressBookRef, personId);
    view.allowsActions = false;
    
    [self.navigationController pushViewController:view animated:YES];
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

@end
