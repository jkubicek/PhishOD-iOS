//
//  RLAristTabViewController.h
//  PhishOD
//
//  Created by Alec Gorge on 6/19/15.
//  Copyright (c) 2015 Alec Gorge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RLSettingsViewController.h"

@interface RLArtistTabViewController : UITabBarController

@property (nonatomic) UIView *edgeView;

@property (nonatomic) NSString *autopresentDisplayDate;

- (void)enableEdgeGesture;
- (void)disableEdgeGesture;

@end
