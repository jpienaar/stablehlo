// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x20xui16>
    %1 = call @expected() : () -> tensor<20x20xui16>
    %2 = stablehlo.negate %0 : tensor<20x20xui16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xui16>, tensor<20x20xui16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x20xui16> {
    %0 = stablehlo.constant dense<"0x0800050000000000010003000000020004000100010000000300010003000300010002000100010002000200000001000100010000000100000002000300040002000000010001000100000006000000000001000600000001000500010004000100010000000000020003000200050000000300040003000100010002000200000005000000000007000000010005000300010008000200020000000300000004000300040002000600030003000200000005000200010000000300010002000300000001000400020003000000080001000000070001000500000003000500000008000100000001000000010000000000010007000300010004000200010003000000030000000500020000000200020001000100010001000000030000000000000004000400040002000400010004000200010003000000000002000100010001000300030000000100010000000300030006000300010001000300030005000100000003000200040004000100020003000000010003000700010000000100020003000200010000000100000002000000000002000300020000000300010000000000020001000100020006000100050002000100040004000400030000000500020001000200020000000200000002000000020002000600030001000300030000000500020002000400020002000000070001000500020002000700000004000500030004000000010000000000000001000100010002000200060001000000000006000400010002000300020000000100020000000600030002000800010004000300030000000100010001000200020000000000010001000200010002000000020003000200010002000200050001000200000000000400020000000200000000000000000000000000050001000300070000000900020001000100070004000100010001000100010001000000000003000700020001000000000001000300010002000000010005000000010002000100020005000300010000000300000000000000010001000200010001000400000004000200020005000500000000000000000000000100030001000100020001000500010002000200"> : tensor<20x20xui16>
    return %0 : tensor<20x20xui16>
  }
  func.func private @expected() -> tensor<20x20xui16> {
    %0 = stablehlo.constant dense<"0xF8FFFBFF00000000FFFFFDFF0000FEFFFCFFFFFFFFFF0000FDFFFFFFFDFFFDFFFFFFFEFFFFFFFFFFFEFFFEFF0000FFFFFFFFFFFF0000FFFF0000FEFFFDFFFCFFFEFF0000FFFFFFFFFFFF0000FAFF00000000FFFFFAFF0000FFFFFBFFFFFFFCFFFFFFFFFF00000000FEFFFDFFFEFFFBFF0000FDFFFCFFFDFFFFFFFFFFFEFFFEFF0000FBFF00000000F9FF0000FFFFFBFFFDFFFFFFF8FFFEFFFEFF0000FDFF0000FCFFFDFFFCFFFEFFFAFFFDFFFDFFFEFF0000FBFFFEFFFFFF0000FDFFFFFFFEFFFDFF0000FFFFFCFFFEFFFDFF0000F8FFFFFF0000F9FFFFFFFBFF0000FDFFFBFF0000F8FFFFFF0000FFFF0000FFFF00000000FFFFF9FFFDFFFFFFFCFFFEFFFFFFFDFF0000FDFF0000FBFFFEFF0000FEFFFEFFFFFFFFFFFFFFFFFF0000FDFF000000000000FCFFFCFFFCFFFEFFFCFFFFFFFCFFFEFFFFFFFDFF00000000FEFFFFFFFFFFFFFFFDFFFDFF0000FFFFFFFF0000FDFFFDFFFAFFFDFFFFFFFFFFFDFFFDFFFBFFFFFF0000FDFFFEFFFCFFFCFFFFFFFEFFFDFF0000FFFFFDFFF9FFFFFF0000FFFFFEFFFDFFFEFFFFFF0000FFFF0000FEFF00000000FEFFFDFFFEFF0000FDFFFFFF00000000FEFFFFFFFFFFFEFFFAFFFFFFFBFFFEFFFFFFFCFFFCFFFCFFFDFF0000FBFFFEFFFFFFFEFFFEFF0000FEFF0000FEFF0000FEFFFEFFFAFFFDFFFFFFFDFFFDFF0000FBFFFEFFFEFFFCFFFEFFFEFF0000F9FFFFFFFBFFFEFFFEFFF9FF0000FCFFFBFFFDFFFCFF0000FFFF000000000000FFFFFFFFFFFFFEFFFEFFFAFFFFFF00000000FAFFFCFFFFFFFEFFFDFFFEFF0000FFFFFEFF0000FAFFFDFFFEFFF8FFFFFFFCFFFDFFFDFF0000FFFFFFFFFFFFFEFFFEFF00000000FFFFFFFFFEFFFFFFFEFF0000FEFFFDFFFEFFFFFFFEFFFEFFFBFFFFFFFEFF00000000FCFFFEFF0000FEFF000000000000000000000000FBFFFFFFFDFFF9FF0000F7FFFEFFFFFFFFFFF9FFFCFFFFFFFFFFFFFFFFFFFFFFFFFF00000000FDFFF9FFFEFFFFFF00000000FFFFFDFFFFFFFEFF0000FFFFFBFF0000FFFFFEFFFFFFFEFFFBFFFDFFFFFF0000FDFF000000000000FFFFFFFFFEFFFFFFFFFFFCFF0000FCFFFEFFFEFFFBFFFBFF00000000000000000000FFFFFDFFFFFFFFFFFEFFFFFFFBFFFFFFFEFFFEFF"> : tensor<20x20xui16>
    return %0 : tensor<20x20xui16>
  }
}
