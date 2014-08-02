//
//  TSStressViewController.h
//  Test Search Index
//
//  Created by Maksim Piriyev on 8/1/14.
//  Copyright (c) 2014 Maksim Industries. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSStressViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *txtSearch;
- (IBAction)btnSearch:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblSearch;

@end
