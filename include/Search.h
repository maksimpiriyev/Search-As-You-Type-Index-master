//
//  Search.h
//  Test Search Index
//
//  Created by Maksim Piriyev on 8/1/14.
//  Copyright (c) 2014 Maksim Industries. All rights reserved.
//

#ifndef Test_Search_Index_Search_h
#define Test_Search_Index_Search_h


#include <iostream>
#include <vector>
#include <map>
#include <unordered_map>
#include <unordered_set>
#include <algorithm>
#include <fstream>
#include <sstream>
#include <cstring>
#include <cstdlib>
#include <ctime>
#include <thread>
typedef std::vector<std::pair<std::string,std::vector<int> > >   INDEX;
using namespace std;

namespace search {
    

    inline string& salt(string s);
    inline string& salt(wstring s);


    int xlower_bound(INDEX& list,string& s);
    int xupper_bound(INDEX& list,string s);
    vector<int> search(INDEX& list,string s);
    
   // void _search_async(INDEX* _list,string s,const std::function <void (vector<int>)> *_f,bool* isFinished);
    thread& search_async(INDEX& list,string s,const std::function <void (vector<int>)>& f,bool* isFinished=NULL);
    INDEX& create_index(int capacity=10);


 //   void _add(INDEX& x,int id,string& word);
    void add(INDEX& x,int id,wstring& words);void add(INDEX& x,int id,string& words);

    void save(INDEX& x,const char* fileName);
    INDEX& read_index(const char* fileName);
    void test_read_write();
    void test_search();
    void test_search_async();
    void test_add();
    void test_add_file();
    void test_add_search_file();


}

class SaytIndex{
    INDEX* index;
    thread* readThread;
public:
    SaytIndex();
    SaytIndex(const char* fileName);
    ~SaytIndex();
    
    void read(const char* fileName);
    thread* readAsync(const char* fileName);
    void save(const char* fileName);
    
    vector<int> search(const char* word);
    thread* searchAsync(const char* word,const std::function <void (vector<int>)>& f,bool* isFinished);
    
    void add(int id,const char* word);
    void add(int id,const wchar_t* word);
    
    
};




#endif
