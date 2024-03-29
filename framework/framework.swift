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
inputfile inputfiles[] <filesys_mapper;location=@arg("filedir","files/"),suffix=".txt">;


shellfile mapreduce_shell_script<single_file_mapper;file=@arg("shellscript","mapreduce.sh")>;
exefile map_fun<single_file_mapper;file=@arg("mapfn","mapcount.py")>;
exefile combine_fun<single_file_mapper;file=@arg("combinefn","combinecount.py")>;
exefile reduce_fun<single_file_mapper;file=@arg("reducefn","reducecount.py")>;

//code for running python in shell
app (reducefile sout) runmapreduce(shellfile shellscript, inputfile f, exefile map, exefile combine, exefile reduce){
      shell @shellscript @f @map @combine @reduce stdout=@filename(sout);
}
(external t) getFnames(reducefile redfiles[]) {
}

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

/* Note: For now, the aggregate operation is run separately from swift */
