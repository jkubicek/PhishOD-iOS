//
//  StatsSessionViewController.m
//  Phish Tracks
//
//  Created by Alexander Bird on 11/16/13.
//  Copyright (c) 2013 Alec Gorge. All rights reserved.
//

#import <SVWebViewController.h>
#import "StatsNewSessionViewController.h"
#import "PhishTracksStats.h"

@interface StatsNewSessionViewController ()

@end

@implementation StatsNewSessionViewController {
	UITextField *emailTextField;
	UITextField *passwordTextField;
}

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
		self.title = @"Sign in";
		[self.tableView setAutoresizesSubviews:YES];

		emailTextField = [[UITextField alloc] init];
		emailTextField.adjustsFontSizeToFitWidth = YES;
		emailTextField.placeholder = @"example@email.com";
		emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
		emailTextField.returnKeyType = UIReturnKeyNext;
		emailTextField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
		emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
		emailTextField.delegate = self;
		emailTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth;

		passwordTextField = [[UITextField alloc] init];
		passwordTextField.adjustsFontSizeToFitWidth = YES;
		passwordTextField.placeholder = @"Required";
		passwordTextField.keyboardType = UIKeyboardTypeDefault;
		passwordTextField.returnKeyType = UIReturnKeyDone;
		passwordTextField.secureTextEntry = YES;
		passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
		passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
		passwordTextField.delegate = self;
		passwordTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
		return 2;
	}
	else if (section == 1){
		return 1;
	}
	else {
		return 1;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier;
	UITableViewCell *cell;

	if (indexPath.section == 0 && indexPath.row == 0) {
		CellIdentifier = @"EmailTextFieldCell";
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

		if(!cell) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
										  reuseIdentifier:CellIdentifier];
			cell.textLabel.text = @"Email";
			cell.selectionStyle = UITableViewCellSelectionStyleNone;

			CGRect bounds = CGRectMake(110, cell.bounds.origin.y, cell.bounds.size.width - 110, cell.bounds.size.height);
			emailTextField.frame = bounds;
			[cell.contentView addSubview:emailTextField];
		}
	}
	else if (indexPath.section == 0 && indexPath.row == 1) {
		CellIdentifier = @"PasswordTextFieldCell";
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

		if(!cell) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
										  reuseIdentifier:CellIdentifier];
			cell.textLabel.text = @"Password";
			cell.selectionStyle = UITableViewCellSelectionStyleNone;

			CGRect bounds = CGRectMake(110, cell.bounds.origin.y, cell.bounds.size.width - 110, cell.bounds.size.height);
			passwordTextField.frame = bounds;
			[cell.contentView addSubview:passwordTextField];
		}
	}
	else if (indexPath.section == 1) {
		CellIdentifier = @"Cell";
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

		if(!cell) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
										  reuseIdentifier:CellIdentifier];
		}

		cell.textLabel.textAlignment = NSTextAlignmentCenter;
		cell.textLabel.text = @"Sign in";
	}
	else {
		CellIdentifier = @"Cell";
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

		if(!cell) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
										  reuseIdentifier:CellIdentifier];
		}

		cell.textLabel.textAlignment = NSTextAlignmentCenter;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.textLabel.text = @"Forgot password";
	}

    return cell;
}

- (void)createSessionHelper
{
	[[PhishTracksStats sharedInstance] createSession:emailTextField.text password:passwordTextField.text
		success:^()
		{
			[self.navigationController popViewControllerAnimated:YES];
		}
		failure:^(PhishTracksStatsError *error)
		{
			[FailureHandler showAlertWithStatsError:error];

			if (error.code == kStatsApiKeyRequired)
				[self.navigationController popViewControllerAnimated:YES];
		}];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	if (indexPath.section == 1) {
		[self createSessionHelper];
	}
	else if (indexPath.section == 2) {
		NSString *add = [NSString stringWithFormat:@"https://www.phishtrackstats.com/users/password/new"];
		[self.navigationController pushViewController:[[SVWebViewController alloc] initWithAddress:add] animated:YES];
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == emailTextField) {
        [textField resignFirstResponder];
        [passwordTextField becomeFirstResponder];
    }
	else if (textField == passwordTextField) {
		[self createSessionHelper];
	}

	return YES;
}

@end
