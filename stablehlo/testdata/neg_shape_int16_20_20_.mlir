// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x20xi16>
    %1 = call @expected() : () -> tensor<20x20xi16>
    %2 = stablehlo.negate %0 : tensor<20x20xi16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xi16>, tensor<20x20xi16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x20xi16> {
    %0 = stablehlo.constant dense<"0x00000200FEFFFCFF000000000100FCFF010001000200010002000200FCFF01000200FDFFFFFF02000100FCFFFFFF0000FCFF0000FFFFFFFF0300FEFFFCFFFDFF0000FEFF01000000030005000000000000000500FFFFFBFF0000FDFF000000000000010000000200FFFF0200020001000300FEFFFAFF030000000000F9FF0000FEFF0100020000000000010004000000FEFF000007000100FBFF0000FFFF01000000FFFF0200FFFFFFFF0200010006000100FFFFFCFF00000000FDFF0200FEFF0000FDFF0000000003000000FCFFFFFF0100FBFFFCFFFFFFFDFF000004000300FFFFFFFF0000FEFF00000300FFFF000000000200FDFFFDFF0000FEFF0600010001000000FDFF0300FCFF01000000010005000400FDFFF9FF03000000FDFF000001000100020000000200FEFF0000FEFFFFFFFEFF0200FEFFFFFFFFFF0400030003000500FBFF000003000400FCFF01000100FDFFFEFF00000000000001000200FCFFFEFF0200FDFFFFFF000009000000030002000000FBFF02000400020001000000FFFFFCFF03000100FEFF0400FEFFFFFF0000FDFF00000200FEFFFCFFFCFF03000000FCFFFBFF05000200FFFFFFFFFDFF020000000400FFFF00000100FDFFFFFF030001000400FFFFFCFF03000000000000000000FCFF00000400020001000200FDFFFDFF0000010000000100FDFF0400FFFF0000000000000000FEFF09000000FFFFFDFF04000000FFFFFFFF0000000002000100FEFF0300FBFF010000000300FDFF00000300010003000000020004000200FBFF00000100000001000000FEFF00000100000000000100020001000200FDFF000003000100FEFF01000000000000000300FFFFFEFF0000FCFF0000FEFF0000000002000200FEFFF8FFFBFF000000000000FDFF010000000000FEFF000000000300FFFF0100FFFF0000000000000200FDFFF9FFF8FF040000000200FFFF0000FDFF0000040000000000F9FF040000000000FFFF04000000FAFF010002000300FFFF0000FEFF0200020000000200FDFFFCFF000002000000000003000300FAFF0000FFFF0000FDFF0100FFFFFCFF0000FAFFFFFF00000100FAFFFFFFFFFF0000F8FF0400FEFFFDFFFFFF0100"> : tensor<20x20xi16>
    return %0 : tensor<20x20xi16>
  }
  func.func private @expected() -> tensor<20x20xi16> {
    %0 = stablehlo.constant dense<"0x0000FEFF0200040000000000FFFF0400FFFFFFFFFEFFFFFFFEFFFEFF0400FFFFFEFF03000100FEFFFFFF0400010000000400000001000100FDFF02000400030000000200FFFF0000FDFFFBFF000000000000FBFF0100050000000300000000000000FFFF0000FEFF0100FEFFFEFFFFFFFDFF02000600FDFF00000000070000000200FFFFFEFF00000000FFFFFCFF000002000000F9FFFFFF050000000100FFFF00000100FEFF01000100FEFFFFFFFAFFFFFF01000400000000000300FEFF02000000030000000000FDFF000004000100FFFF05000400010003000000FCFFFDFF01000100000002000000FDFF010000000000FEFF0300030000000200FAFFFFFFFFFF00000300FDFF0400FFFF0000FFFFFBFFFCFF03000700FDFF000003000000FFFFFFFFFEFF0000FEFF02000000020001000200FEFF020001000100FCFFFDFFFDFFFBFF05000000FDFFFCFF0400FFFFFFFF03000200000000000000FFFFFEFF04000200FEFF030001000000F7FF0000FDFFFEFF00000500FEFFFCFFFEFFFFFF000001000400FDFFFFFF0200FCFF02000100000003000000FEFF020004000400FDFF000004000500FBFFFEFF010001000300FEFF0000FCFF01000000FFFF03000100FDFFFFFFFCFF01000400FDFF000000000000000004000000FCFFFEFFFFFFFEFF030003000000FFFF0000FFFF0300FCFF010000000000000000000200F7FF000001000300FCFF00000100010000000000FEFFFFFF0200FDFF0500FFFF0000FDFF03000000FDFFFFFFFDFF0000FEFFFCFFFEFF05000000FFFF0000FFFF000002000000FFFF00000000FFFFFEFFFFFFFEFF03000000FDFFFFFF0200FFFF000000000000FDFF01000200000004000000020000000000FEFFFEFF0200080005000000000000000300FFFF00000000020000000000FDFF0100FFFF0100000000000000FEFF030007000800FCFF0000FEFF0100000003000000FCFF000000000700FCFF000000000100FCFF00000600FFFFFEFFFDFF010000000200FEFFFEFF0000FEFF030004000000FEFF00000000FDFFFDFF06000000010000000300FFFF010004000000060001000000FFFF06000100010000000800FCFF020003000100FFFF"> : tensor<20x20xi16>
    return %0 : tensor<20x20xi16>
  }
}
