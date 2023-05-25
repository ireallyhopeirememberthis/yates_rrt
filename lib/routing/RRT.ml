open Core

open Util
open Yates_Frt
open Yates_types.Types
open Yates_Rrt

let create_counter () =
  let count = ref 0 in
  fun () -> 
    let value = !count in
    count := value + 1;
    string_of_int value


(* Initialization not needed *)
let initialize _ : unit = ()

(* Recovery: normalization recovery *)
let local_recovery = Util.normalization_recovery

(*store routing once it's computed*)
(*SrcDstMap takes tuples (source/destination) of vertices as a key.*)
let prev_scheme = ref SrcDstMap.empty

(*let source_to_tree = ref (Map.Make(Topology.vertex).empty)*)

(*most of this code is taken from the Raeke.ml file*) 

let solve (topo:topology) (d:demands) : scheme =
  let new_scheme =
    if (SrcDstMap.is_empty !prev_scheme) then 
      begin
        Core.printf "#############starting hedge_iterations\n\n%!";

        let hosts = get_hosts_set topo in
        let end_points = hosts in 

        let epsilon = 0.1 in
        let n,mw_solution,_ = RRTs.hedge_iterations epsilon topo d end_points in
        (*write the trees in mw_solution to a file using the methods in Yates_Frt.ml*)
        let string_counter = create_counter () in
        List.iter ~f:(fun (x,_) -> FRT.write_rt topo x (string_counter ())) mw_solution;
        let bla = SrcDstMap.empty in
        Core.eprintf "%d iterations done.\n%!" n;
        (*SrcDstMap.set bla ~key:(, 3) ~data:4;  setting some stuff, so the Map is not empty anymore *)
        bla
      end
    else !prev_scheme in
  prev_scheme := new_scheme;
  new_scheme
  (*prev_scheme = new_scheme;
  new_scheme *)

  (*this function generates a single random routing tree, 
    using the initial weights of the edges for computation 
    of the distance metric. to actually get the randomized
    routing trees of the SMORE paper, we need adaptive 
    weights as above. similar to how it is done in the raeke 
    algorithm, but there these trees are then used to 
    calculate specific paths between endpoint pairs.
    instead, we want to generate a set of randomized
    trees, and assign some tree to each endpoint *)
let solve2 (topo:topology) (_:demands) : scheme =
    let frt_tree = FRT.make_frt_tree topo in
    let hosts = get_hosts_set topo in
    let rt = FRT.generate_rt topo frt_tree (VertexSet.to_list hosts) in
    let frt_name = "frt_tree" in
    FRT.write_frt topo frt_tree frt_name;
    let rt_name = "rt" in
    FRT.write_rt topo rt rt_name;
    SrcDstMap.empty 


