//
//  F.c
//  Test Search Index
//
//  Created by Maksim Piriyev on 8/1/14.
//  Copyright (c) 2014 Maksim Industries. All rights reserved.
//

#include "F.h"
#include <iostream>
#include <fstream>
#include <vector>
#include <string>
using namespace std;

vector<string> read_file(const char* name){
    NSString* filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%s" , name]
                                                         ofType:@"txt"];
    ifstream inn([filePath UTF8String]);
    string s;
    vector<string> r;
    
    while(getline(inn,s)&& s!=""){
        r.push_back(s);
    };
    inn.close();
    //r.push_back("asdads");
    return r;
    
}