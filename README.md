Search-As-You-Type-Index 
========================
 'include' folder : the files you need for the SaytIndex (Search as you type Index)
 'Test Search Index' folder: demo ios app compares performances and makes stress tests

 SaytIndex (Search-As-You-Type-Index) is a kind of simple search as you type index designed for data more than 10,000 in mobile phones, ios, android.It is written in C++.It makes prefix search over index x100 times faster (for ~10,000 data) than the regular array predicate search.The best usage scenario is create index once and use it always.Though loading index file fast,there is also asynchronous index file loading method.Note than it can search multi prefixes like 'ne ye' would bring you 'new year',but asynchronous search is just single word search ('ne' but not 'ne ye'). It supports wchar_t , unicode characters,but index is converted and stored in ascii. Since it is written in C++ you should rename your .m files to .mm in IOS. Stress tests are included in the demo. Results for iphone 5:

![Stress Test](http://data.bloggif.com/distant/user/store/3/6/2/0/5fbdd5630193e52dead6957d912b0263.gif)


 The class structure of index:
```c++
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
 ```
 Generating Index file in ios
```c++
 NSString* filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%s" , "index"]
                                                          ofType:@"txt"];

    SaytIndex* index=new SaytIndex(); //to create new index
    index->add(33,L"üniform ïnfo");
    index->add(34,"some info");
    auto list=index->search("in"); // 33,34 indices of documents
    index->save([filePath UTF8String]);  saving index file
```
 Reading Index file in ios
```c++
 NSString* filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%s" , "index"]
                                                          ofType:@"txt"];
    SaytIndex* index=new SaytIndex([filePath UTF8String]); // reads the index in filePath
    SaytIndex* index=new SaytIndex();// to create new index

     index->readAsync([filePath UTF8String]); reading index file async
   index->save([filePath UTF8String]);  saving index file
```
 How index works! Index is list of sorted words and their corresponding document indices(sorted order).Index is stored in a text file. Algorithm does binary search over the words,has the complexity: log(number of potential keywords)*(length of keyword)
