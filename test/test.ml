open Crdt

let clients = Array.init 2 (fun i -> Counter.init i)
let client1 = clients.(0)
let client2 = clients.(1)

let _ =
  Counter.increment client1 1;
  Counter.increment client2 3;
  Counter.increment client2 3;
  Counter.increment client1 1;
  Counter.increment client1 1;
  Printf.printf "Client1 is: %d\n" (Counter.query client1);
  Printf.printf "Client2 is: %d\n" (Counter.query client2);

  Array.iter
    (fun c1 -> Array.iter (fun c2 -> Counter.reconcile c1 c2) clients)
    clients;
  Printf.printf "Client1 is: %d\n" (Counter.query client1);
  Printf.printf "Client2 is: %d\n" (Counter.query client2)
