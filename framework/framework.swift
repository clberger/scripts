// Distributed Reduce map-reduce (key,value): Proof-of-concept
// This swift script implements a distributed reduce via passing
// implemented instances of the map,reduce, and combine functions to
// coasters, which in turn will allocate all three on a single worker node.

type inputfile;
type shellfile;
type exefile;
type reducefile;
type resultfile;
type word {
  string w;
  int c;
}
type fullcount {
  word words[];
}

//input files
inputfile inputfiles[] <filesys_mapper;location="files/",suffix=".txt">;


shellfile mapreduce_shell_script<single_file_mapper;file=@arg("shellscript","mapreduce.sh")>;
exefile map_fun<single_file_mapper;file=@arg("mapfn","mapcount.py")>;
exefile combine_fun<single_file_mapper;file=@arg("combinefn","combinecount.py")>;
exefile reduce_fun<single_file_mapper;file=@arg("reducefn","reducecount.py")>;
exefile aggregate_fun<single_file_mapper;file=@arg("aggregatefn","aggregatecount.py")>;

//code for running python in shell
app (reducefile sout) runmapreduce(shellfile shellscript, inputfile f, exefile map, exefile combine, exefile reduce){
      shell @shellscript @f @map @combine @reduce stdout=@filename(sout);
}
app (resultfile sout) runaggregate(exefile aggregate, reducefile redfiles[]){
      python @aggregate @filename(redfiles) stdout=@filename(sout);
}
app() touchfun(resultfile res) {
  touch res;
}


//TODO: implement a map-reduce framework on alternate functionalities
//and modify swift to take more structural approaches to map-reduce

/*TODO: fix issue with granularity
 right now, the map-reduce is done on the granularity of files,
 what we want is for this to be made coarser, or in other words,
 produce an aggregate reduce file for all files on a given node,
 not multiple files per node.  This requires modification of the language
 to include an aggregate function to run at the end of the script
*/

/*
this is where the distributed map (combine, and reduce) will occur
right now, it's being implemented by the user who is aware of map-reduce
capability of the program using (key,value) compositions.
*/
foreach f in inputfiles {
  reducefile r<regexp_mapper;
               source=@f,
                 match="(.*)txt",
                 transform="\\1reduce">;
  r = runmapreduce(mapreduce_shell_script,f,map_fun,combine_fun,reduce_fun);

}

resultfile result<single_file_mapper;file="result.txt">;
reducefile reducefiles[]<filesys_mapper;files="files/*.reduce">;

touchfun(result);
result = runaggregate(aggregate_fun,reducefiles);
