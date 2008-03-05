open OUnit

let suite = "Lambda" >:::
  [Test_parser.suite;
   Test_equivalent.suite;
   Test_occurs_free.suite;
   Test_substitute.suite;
   Test_reduce.suite]

let _ = run_test_tt_main suite
