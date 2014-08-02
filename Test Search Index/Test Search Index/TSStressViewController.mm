//
//  TSStressViewController.m
//  Test Search Index
//
//  Created by Maksim Piriyev on 8/1/14.
//  Copyright (c) 2014 Maksim Industries. All rights reserved.
//

#import "TSStressViewController.h"
#include "F.h"
#include <mach/mach_time.h>
#include <stdint.h>
#include <time.h>
@interface TSStressViewController ()

@end

@implementation TSStressViewController
{
    vector<std::string> list;
    NSMutableArray* olist;//= [NSMutableArray new];
    NSMutableArray* filteredList;//= [NSMutableArray new];
    uint64_t _start;
    uint64_t _stop;
}

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
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];

    olist= [NSMutableArray new];
    filteredList= [NSMutableArray new];
    list=read_file("list");
    //list.push_back("ASDasd");
    for (int i=0; i<list.size(); i++) {
        [olist addObject:[NSString stringWithFormat:@"%s",list[i].c_str()]];
    }
    // Do any additional setup after loading the view.
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

- (IBAction)btnSearch:(id)sender {
    
    NSString* txt=[[self txtSearch] text];
    _start = mach_absolute_time();
    
    for (int i=0; i<1000; i++) {
        [filteredList removeAllObjects];
        // Filter the array using NSPredicate
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@",txt];
        filteredList = [NSMutableArray arrayWithArray:[olist filteredArrayUsingPredicate:predicate]];
    }
    _stop = mach_absolute_time();
    [[self lblSearch] setText:[NSString stringWithFormat:@"%.3lf sec",[self seconds]]];
    

}
-(double) seconds
{
    if((_stop-_start) > 0)
    {
        uint64_t elapsedTimeNano = 0;
        
        mach_timebase_info_data_t timeBaseInfo;
        mach_timebase_info(&timeBaseInfo);
        elapsedTimeNano = (_stop-_start) * timeBaseInfo.numer / timeBaseInfo.denom;
        double elapsedSeconds = elapsedTimeNano /1000.0/1000.0/1000.0;
        return elapsedSeconds;
    }
    return 0.0;
}
@end
