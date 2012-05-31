// Distributed Reduce map-reduce (key,value): Proof-of-concept
// This swift script implements a distributed reduce via passing
// implemented instances of the map,reduce, and combine functions to
// coasters, which in turn will allocate all three on a single worker node.

type inputfile;
type shellfile;
type exefile;
type reducefile;
type resultfile;

//input files
inputfile inputfiles[] <filesys_mapper;location=@arg("fileloc","files/"),suffix=".txt">;


shellfile mapreduce_shell_script<single_file_mapper;file=@arg("shellscript","map.sh")>;
exefile map_fun<single_file_mapper;file=@arg("mapfn","mapcount.py")>;
exefile combine_fun<single_file_mapper;file=@arg("combinefn","combinecount.py")>;
exefile reduce_fun<single_file_mapper;file=@arg("reducefn","reducecount.py")>;
exefile aggregate_fun<single_file_mapper;file=@arg("aggregatefn","aggregatecount.py")>;

//code for running python in shell
app (external o) runmapcombine(shellfile shellscript, inputfile f, exefile map, exefile combine){
      shell @shellscript @f @map @combine;
}
app (reducefile sout) runreduce(shellfile shellscript, external i, exefile reduce){
      shell @shellscript @i @reduce stdout=@sout;
}


/*
this is where the distributed map (combine, and reduce) will occur
right now, it's being implemented by the user who is aware of map-reduce
capability of the program using (key,value) compositions.
*/
foreach f in inputfiles {
  //reducefile r[] <ext; exec="fileList.sh", location="output", nfiles=, prefix=@filename(f), suffix(".mapped") >;
  external r;
  r = runmapreduce(mapreduce_shell_script,f,map_fun,combine_fun);
}

foreach 
