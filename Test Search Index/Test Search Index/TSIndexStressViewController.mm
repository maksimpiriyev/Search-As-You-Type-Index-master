//
//  TSStressViewController.m
//  Test Search Index
//
//  Created by Maksim Piriyev on 8/1/14.
//  Copyright (c) 2014 Maksim Industries. All rights reserved.
//

#import "TSIndexStressViewController.h"
#include "Search.h"
#include "F.h"

#include <mach/mach_time.h>
#include <stdint.h>
@interface TSIndexStressViewController ()

@end

@implementation TSIndexStressViewController
{
    vector<std::string> list;
    NSMutableArray* olist;//= [NSMutableArray new];
    NSMutableArray* filteredList;//= [NSMutableArray new];
    uint64_t _start;
    uint64_t _stop;
    INDEX* index;
    SaytIndex* sindex;

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
    NSString* filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%s" , "index"]
                                                         ofType:@"txt"];
    _start = mach_absolute_time();

    sindex=new SaytIndex([filePath UTF8String]);
  //  index=&search::read_index([filePath UTF8String]);
    _stop = mach_absolute_time();

    //list.push_back("ASDasd");
    for (int i=0; i<list.size(); i++) {
        [olist addObject:[NSString stringWithFormat:@"%s",list[i].c_str()]];
    }
    // Do any additional setup after loading the view.
    [[self lblSearch] setText:[NSString stringWithFormat:@"%.3lf sec",[self seconds]]];
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
        auto l=sindex->search([txt UTF8String]);
        for (int i=0; i<l.size(); i++) {
            [filteredList addObject:[NSString stringWithFormat:@"%s",list[l[i]].c_str()]];
        }
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
