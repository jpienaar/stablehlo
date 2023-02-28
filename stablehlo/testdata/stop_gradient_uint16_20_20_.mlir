// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x20xui16>
    %1 = call @expected() : () -> tensor<20x20xui16>
    %2 = stablehlo.custom_call @check.eq(%0, %1) : (tensor<20x20xui16>, tensor<20x20xui16>) -> tensor<i1>
    return %2 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x20xui16> {
    %0 = stablehlo.constant dense<"0x0100000001000000010001000000010002000000050001000000010000000700010002000400010000000000050000000200040003000100050001000300000003000100010003000500060000000200060001000400050001000200040002000300060002000300030005000000050003000300020003000300020001000200040002000300020005000000010003000000010000000100010000000600000007000200030001000500020004000500000003000000000002000300010001000000020003000100000000000000030005000100050003000200010003000000020003000400000001000000010003000200060004000400010003000000020005000200050000000500010001000300060001000100030005000400070001000300010004000200010002000700020004000200000002000400050004000000030004000400040001000300010000000300000003000200000001000300000006000500000002000300020004000300050000000000010001000400010003000400010002000300050004000400010004000400000000000500010003000300030000000200020004000100030004000300020002000200040003000000010002000100040000000000010002000200040000000000010001000400000004000000020000000000070000000200040000000100050000000500030001000100040002000500000000000200000001000200020003000200050003000400000000000100020002000100040002000000030001000400000004000400010002000900010002000300050006000000010000000000060000000100010001000300040001000100020001000300000001000300030000000500010000000200020001000100000000000300010003000100000002000300020002000200020004000000010000000200050003000000030002000000040000000100050001000600050007000600000003000300010002000400030002000100010000000300040002000400010001000000020002000100010002000600050002000300030004000000070003000000020001000300020000000300010003000500000003000000"> : tensor<20x20xui16>
    return %0 : tensor<20x20xui16>
  }
  func.func private @expected() -> tensor<20x20xui16> {
    %0 = stablehlo.constant dense<"0x0100000001000000010001000000010002000000050001000000010000000700010002000400010000000000050000000200040003000100050001000300000003000100010003000500060000000200060001000400050001000200040002000300060002000300030005000000050003000300020003000300020001000200040002000300020005000000010003000000010000000100010000000600000007000200030001000500020004000500000003000000000002000300010001000000020003000100000000000000030005000100050003000200010003000000020003000400000001000000010003000200060004000400010003000000020005000200050000000500010001000300060001000100030005000400070001000300010004000200010002000700020004000200000002000400050004000000030004000400040001000300010000000300000003000200000001000300000006000500000002000300020004000300050000000000010001000400010003000400010002000300050004000400010004000400000000000500010003000300030000000200020004000100030004000300020002000200040003000000010002000100040000000000010002000200040000000000010001000400000004000000020000000000070000000200040000000100050000000500030001000100040002000500000000000200000001000200020003000200050003000400000000000100020002000100040002000000030001000400000004000400010002000900010002000300050006000000010000000000060000000100010001000300040001000100020001000300000001000300030000000500010000000200020001000100000000000300010003000100000002000300020002000200020004000000010000000200050003000000030002000000040000000100050001000600050007000600000003000300010002000400030002000100010000000300040002000400010001000000020002000100010002000600050002000300030004000000070003000000020001000300020000000300010003000500000003000000"> : tensor<20x20xui16>
    return %0 : tensor<20x20xui16>
  }
}
