// plain distributed count, no map reduce

type inputfile;
type exefile;
type countedfile;

//input files
inputfile inputfiles[] <filesys_mapper;location=@arg("filedir","files/"),suffix=".txt">;

exefile count_fun<single_file_mapper;file=@arg("countfn","countwords.py")>;

//code for running python
app (countedfile sout) runcount(inputfile f, exefile count) {
  python @count @f stdout=@filename(sout);
}

foreach f in inputfiles {
  countedfile c<regexp_mapper;
               source=@f,
                 match="(.*)txt",
                 transform="\\1counted">;
  c = runcount(f,count_fun);
}
