import "distreduce_defs";

/*
This is incredibly hacky, but we essentially make copies of all the reduce scripts, 
and then rely on swift/coasters to provision the jobs to all the machines and return
results to the master node.
A true solution would provide this functionality via something like a signal to an 
HTTP server, something we will discuss later in our presentation
*/

foreach red in reduce_funs {
  reducefile res<concurrent_mapper;location="files/",prefix="res",suffix=".reduce">;
  res = runreduce(red);
}
