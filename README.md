Search-As-You-Type-Index 
========================
 'include' folder : the files you need for the SaytIndex (Search as you type Index)
 'Test Search Index' folder: demo ios app compares performances and makes stress tests

 SaytIndex (Search-As-You-Type-Index) is a kind of simple search as you type index designed for data more than 10000 in mobile phones, ios, android.It is written in C++.It makes prefix search over index x100 times faster than the regular array predicate search.Though loading index file fast,there is also asynchronous index file loading method.Note than it can search multi prefixes like 'ne ye' would bring you 'new year',but asynchronous search is just sing word search Stress tests are included in the demo.

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
 Reading Index file in ios

 NSString* filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%s" , "index"]
                                                          ofType:@"txt"];
    SaytIndex* index=new SaytIndex([filePath UTF8String]); // reads the index in filePath
   // SaytIndex* index=new SaytIndex(); to create new index

   //  index->readAsync([filePath UTF8String]); reading index file async
   //index->save([filePath UTF8String]);  saving index file
 