//
//  Search.cpp
//  Test Search Index
//
//  Created by Maksim Piriyev on 8/1/14.
//  Copyright (c) 2014 Maksim Industries. All rights reserved.
//

#include "Search.h"
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
//INDEX& create_index(int capacity);


    inline string& salt(string s){
        std::transform(s.begin(), s.end(), s.begin(), ::tolower);
        
        string t=s;
        char* c=new char[t.size()+1];
        for (int i=0,j=0; i<t.size(); i++) {
            if(t[i]==',') c[i]=' ';
            else if(t[i]=='[') c[i]=' ';
            else if(t[i]==']') c[i]=' ';
            else if(t[i]==';') c[i]=' ';
            else if(t[i]==':') c[i]=' ';
            else if(t[i]=='}') c[i]=' ';
            else if(t[i]=='{') c[i]=' ';
            else if(t[i]=='(') c[i]=' ';
            else if(t[i]==')') c[i]=' ';
            else if(t[i]=='*') c[i]=' ';
            else if(t[i]=='\'') c[i]=' ';
            else if(t[i]=='\"') c[i]=' ';
            else if(t[i]=='\"') c[i]=' ';
            else if(t[i]=='\r') c[i]=' ';
            else if(t[i]=='\n') c[i]=' ';
            else if(t[i]=='\t') c[i]=' ';
            else if(t[i]=='%') c[i]=' ';
            else c[i]=t[i];
            
        }
        c[t.size()]=0;
        return *new string(c);
        
        
    }
    inline string& salt(wstring s){
        std::transform(s.begin(), s.end(), s.begin(), ::tolower);
        
        wstring t=s;
        char* c=new char[t.size()+1];
        for (int i=0,j=0; i<t.size(); i++) {
            if(t[i]==L'ç') c[i]='c';
            else if(t[i]==',') c[i]=' ';
            else if(t[i]==L'ö') c[i]='o';
            else if(t[i]==L'ğ') c[i]='g';
            else if(t[i]==L'ə') c[i]='e';
            else if(t[i]==L'ş') c[i]='s';
            else if(t[i]==L'ü') c[i]='u';
            else if(t[i]==L'ı') c[i]='i';
            else c[i]=t[i];
            
        }
        c[t.size()]=0;
        return  salt(string(c));
    }
    
    
    
    int xlower_bound(INDEX& list,string& s){
        int l=0,h=list.size(),m=0;
        for(;l<h;)
        {
            m=(l+h)/2;
            if(list[m].first<s)l=m+1;
            else h=m;
            
        }
        if(list.size()>0 && list[l].first.size() >=s.size() && list[l].first.substr(0,s.size())==s) return l;
        
        return -1;
    }
    int xupper_bound(INDEX& list,string s){
        int l=0,h=list.size(),m=0;
        for(;l<h;)
        {
            m=(l+h)/2;
            if(list[m].first<s || (list[m].first.size() >=s.size() && list[m].first.substr(0,s.size())==s) )l=m+1;
            else h=m;
            
        }
        if(l>0 && list[l-1].first.size() >=s.size() && list[l-1].first.substr(0,s.size())==s) return l;
        
        return -1;
    }
    
    
    vector<int> search(INDEX& list,string s){
        vector<int> rtn;
        unordered_set<int> hist;
        bool first_time=true;
        istringstream iss(salt(s));
        while(iss>>s){
            vector<int> trtn;
            unordered_set<int> thist;
            
            int start=xlower_bound(list,s);
            int end=xupper_bound(list,s);
            for(size_t i = start; i < end; ++i)
            {
                vector<int>& l=list[i].second;
                for (int j=0; j<l.size(); j++) {
                    if(first_time){
                        if(thist.find(l[j])==thist.end()){
                            trtn.push_back(l[j]);
                            thist.insert(l[j]);
                        }
                    }else{
                        if(thist.find(l[j])==thist.end() && hist.find(l[j])!=hist.end()){
                            trtn.push_back(l[j]);
                            thist.insert(l[j]);
                        }
                    }
                }
            }
            rtn=trtn;
            hist=thist;
            first_time=false;
            
        }
        return rtn;
    }
    
    void _search_async(INDEX* _list,string s,const std::function <void (vector<int>)> *_f,bool* isFinished){
        INDEX& list=*_list;
        const std::function <void (vector<int>)>& f=*_f;
        vector<int> rtn;
        unordered_set<int> hist;
        int start=xlower_bound(list,s);
        int end=xupper_bound(list,s);
        //return ;
        cout<<start<<" "<<end<<endl;
        for(size_t i = start; i < end; ++i)
        {
            rtn.clear();
            //		cout<<list[i].first<<"\n";
            vector<int>& l=list[i].second;
            for (int j=0; j<l.size(); j++) {
                if(hist.find(l[j])==hist.end()){
                    rtn.push_back(l[j]);
                    hist.insert(l[j]);
                }
            }
            if(isFinished!=NULL && *isFinished) break;
            if(rtn.size()>0){
                f(rtn);
            }
        }
    }
    
    thread& search_async(INDEX& list,string s,const std::function <void (vector<int>)>& f,bool* isFinished){
        thread* tr=new thread(_search_async,&list,s,&f,isFinished);
        
        return *tr;
        
    }
    
    INDEX& create_index(int capacity){
        INDEX* x=new INDEX();
        x->reserve(capacity);
        return *x;
    }
    
    
    
    void _add(INDEX& x,int id,string& word){
        int i=xlower_bound(x,word);
        if(i==-1 || x[i].first!=word){
            auto it=lower_bound(x.begin(), x.end(),pair<string,vector<int> >(word,vector<int>()));
            x.insert(it, pair<string,vector<int> >(word,vector<int>()));
            
        }
        i=xlower_bound(x,word);
        auto it=lower_bound(x[i].second.begin(), x[i].second.end(),id);
        x[i].second.insert(it, id);
    }
    
    void add(INDEX& x,int id,wstring& words){
        string& slt=salt(words);
        istringstream iss(slt);
        string t;
        while(iss>>t){
            _add(x,id,t);
        }
    }
    void add(INDEX& x,int id,string& words){
        string& slt=salt(words);
        istringstream iss(slt);
        string t;
        while(iss>>t){
            _add(x,id,t);
        }
    }
    
    
    void save(INDEX& x,const char* fileName){
        ofstream out(fileName);
        out<<x.size()<<"\n";
        for (auto it=x.begin(); it!=x.end(); it++) {
            out<<(*it).first;
            auto j=(*it).second;
            out<<" "<<j.size();
            for (int i=0; i<j.size(); i++) {
                out<<" "<<j[i];
            }
            out<<"\n";
        }
        
        out.close();
    }
    
    INDEX& read_index(const char* fileName){
        ifstream in(fileName);
        auto file=fopen(fileName, "r");
        int sz=0,tsz=0,t=0;
        fscanf(file, "%d",&sz);
        INDEX& x=create_index(sz);
        char buf[1000];
        string word;
        int kk=x.size();
        for (int i=0; i<sz; i++) {
            fscanf(file, "%s",buf);
            
            word=string(buf);
            fscanf(file, "%d",&tsz);
            vector<int> v;
            v.reserve(tsz);
            pair<string,vector<int>& >  p(word,v);
            
            for (int j=0; j<tsz; j++) {
                fscanf(file, "%d",&t);
                p.second.push_back(t);
            }
            x.push_back(p);
        }
        in.close();
        return x;
    }
    void test_read_write(){
        INDEX& x=read_index("/Users/maksim/Desktop/OWL3.txt");
        save(x,"/Users/maksim/Desktop/OWL4.txt");
    }
    void test_search(){
        INDEX& x=read_index("/Users/maksim/Desktop/OWL3.txt");
        for (int i=0; i<1000; i++)
            auto r=search(x, "MAX");
        //    for (int i=0; i<r.size(); i++) {
        //        cout<<r[i]<<" ";
        //    }
    }
    void test_search_async(){
        INDEX& x=read_index("/Users/maksim/Desktop/OWL3.txt");
        //for (int i=0; i<1000; i++)
        thread& tr=  search_async(x, "MAX",[](vector<int> l){
            cout<<endl<<"size: "<<l.size()<<endl;
            for (int i=0; i<l.size(); i++) cout<<l[i]<<" ";
        });
        tr.join();
        //    for (int i=0; i<r.size(); i++) {
        //        cout<<r[i]<<" ";
        //    }
    }
    void test_add(){
        INDEX& x=read_index("/Users/maksim/Desktop/OWL3.txt");
        wstring w=L"A ZZZZ MAXIMUS";
        add(x, 33, w);
        add(x, 77, w);
        save(x,"/Users/maksim/Desktop/OWL5.txt");
    }
    void test_add_file(){
        ifstream in("/Users/maksim/Desktop/restaurant_names_salt.txt");
        string s;
        int id=0;
        INDEX& x=create_index();
        vector<string> l;
        while (getline(in,s) && s!=""){
            add(x, id, s);
            l.push_back(s);
            id++;
        }
        save(x, "/Users/maksim/Desktop/resto_ix.txt");
    }
    void test_add_search_file(){
        ifstream in("/Users/maksim/Desktop/restaurant_names_salt.txt");
        string s;
        int id=0;
        vector<string> l;
        while (getline(in,s) && s!=""){
            l.push_back(s);
            id++;
        }
        
        INDEX ix=read_index( "/Users/maksim/Desktop/resto_ix.txt");
        vector<int> r;
        for (int i=0; i<10000; i++)
            r=search(ix, "emi");
        for (int i=0; i<r.size(); i++) {
            cout<<l[r[i]]<<endl;
        }
        
        
    }
    
}
  
SaytIndex::SaytIndex(){
    this->index=&search::create_index();
    this->readThread=NULL;
}

SaytIndex::~SaytIndex(){
    this->index->clear();
    delete this->index;
    this->readThread=NULL;
}
    SaytIndex::SaytIndex(const char* fileName){
        this->index=&search::read_index(fileName);
        this->readThread=NULL;
    }
    void SaytIndex::read(const char* fileName){
        this->index->clear();
        this->index=&search::read_index(fileName);

    }
thread* SaytIndex::readAsync(const char* fileName){
    this->readThread= new thread(&SaytIndex::read,this,fileName);
    return this->readThread;
}
    void SaytIndex::save(const char* fileName){ search::save(*this->index, fileName);}
vector<int> SaytIndex::search(const char* word){
    if(this->readThread!=NULL){this->readThread->join();this->readThread=NULL;}
    return search::search(*(this->index), string(word));
}
thread* SaytIndex::searchAsync(const char* word,const std::function <void (vector<int>)>& f,bool* isFinished){
    if(this->readThread!=NULL){this->readThread->join();this->readThread=NULL;}
    return &search::search_async(*(this->index), string(word),f,isFinished);
}
//        vector<int> searchAsync(const char* word);
//        
    void SaytIndex::add(int id,const char* words){ search::add(*(this->index), id, *new string(words));}
    void SaytIndex::add(int id,const wchar_t* words){ search::add(*(this->index), id, *new wstring(words)); }

    


    

