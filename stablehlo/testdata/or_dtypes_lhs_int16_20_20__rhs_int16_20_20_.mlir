// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<20x20xi16>, tensor<20x20xi16>)
    %1 = call @expected() : () -> tensor<20x20xi16>
    %2 = stablehlo.or %0#0, %0#1 : tensor<20x20xi16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xi16>, tensor<20x20xi16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<20x20xi16>, tensor<20x20xi16>) {
    %0 = stablehlo.constant dense<"0x04000000FFFFFFFFFFFFFDFF060005000100FAFFFEFFFFFF0100FFFF0400FFFF0300000003000300FDFF01000600FEFF0100FBFFF7FF0000FEFFFFFFFCFF0000030000000300FEFF01000200FFFF00000000010003000200FFFF05000300010003000200030007000000FDFF010000000200FFFF01000200FFFFFFFFFEFFFDFF0000FFFFFBFF02000000FFFFFCFF0400010002000000FCFFFBFF020005000100FEFF00000100FFFF0500FEFF05000200000002000000FFFFF9FF0000040001000000020000000100FDFF0000000004000100FCFFFCFFFEFF01000100020000000200FDFFFCFFFEFFFFFF0300FEFFFEFF0200FEFF01000200FEFFFFFF0600FFFFFEFF0000000000000300FEFF0000FEFF020000000000FEFFFEFF0300000000000100FEFFFBFF0300FFFF0300FCFF00000100FDFF0100000003000000000003000200FDFF05000000FFFFFDFFFFFFFFFF0100000000000100050001000000FBFF0000FFFF0000050000000000040000000300FEFF000001000400FEFF00000400060000000600FFFF01000600F8FF0200010000000000FEFF010000000000FEFF000002000100FFFFFEFF0100000000000300FEFF000003000200FDFF00000200FFFF0300010000000200FEFFFAFFFFFF0000FDFFFFFF02000000FFFF0200FBFF010001000000FFFF00000000FDFFFAFF0500FFFFFDFFFAFFFFFF020000000000FFFF03000000000003000300FEFF0100010000000200FFFF02000600FEFFFDFF00000000FAFF0400FDFFFDFF0000FFFFFFFF0200F8FFF9FF0000FFFF0000FDFF0100FDFF040001000000FCFF0300FAFF0000FDFF0400000000000000FDFF04000000FCFF04000000FEFFFDFFFBFF02000200FEFF0100FCFF030002000500020002000300060005000000FBFF0000040002000000FFFFFCFFFFFFFCFF0100F9FFFEFF0300000000000200010000000000FEFF000001000500FFFF00000000FFFFFEFFFCFF0100FCFF0300FBFFFFFFFCFF0000FEFFFEFFFEFF0200020002000100050000000000FDFF020000000000FFFF0300FBFF020000000300FDFFFEFF010002000000FEFFFEFFFEFF0000010004000100FFFFFFFF0100020000000000FFFF"> : tensor<20x20xi16>
    %1 = stablehlo.constant dense<"0x020000000400FCFFFFFF02000000FDFF0400FEFF0300FEFF0000FDFF01000400010004000200FBFFFEFF06000000FFFFFFFF00000200FFFF0000000000000000FFFF00000600FDFF010002000000FCFFFBFF01000000FFFFFDFF03000000000001000100FDFFFFFF0000000000000100FEFF01000100FEFF0100FDFF0500FEFF000000000100FCFFFDFF000001000100FDFF04000000FFFFFAFFFDFF04000100FAFF040000000200FEFFFFFFFFFFFEFF0000FFFFFFFF0000000000000000FCFF00000500FFFF0100050000000600FDFF00000200FCFF050000000100FDFF040004000200FEFF00000400FDFF0700FDFFFEFF000001000100FEFFFEFFFCFFFEFFFFFF00000100FFFFFFFF000000000000FDFF0400000003000000000000000300FEFF0100FEFFFFFF0400030002000200FFFF000005000000FCFF02000400FFFFFFFF01000400000002000400050000000000FDFF010000000200FEFFFCFF01000000FDFF02000000040005000000FEFF01000000FBFF0100FEFF0000FEFF010000000300FCFFFEFFFCFF09000000FCFF0100020002000200FEFFFCFFFCFF000004000200080002000400FEFF02000300FFFF0000030003000000010001000100FDFFFEFFFFFF0000010000000400FEFF07000500010001000400FFFFFFFF0000FEFF00000500FFFF0100000000000200FFFF0300FDFFFFFFFEFF01000000FFFF0200FFFF00000000FBFF000004000100FFFF010000000000FEFF0300FFFFFCFF0100FFFF0000FBFF0000010003000300FEFF0100FFFF00000300FCFFFFFF0000FCFF03000000020000000100000002000100FFFF0400FEFF0200FFFFFEFF02000100FFFFFDFF010002000400FEFFFFFF010004000400FDFFFEFF0000FFFF0000060000000000FEFF000002000500FEFF020004000000FDFFFEFF0100FEFF0100020000000700FEFF0200FFFF0000000001000200FEFF030000000000FEFFFBFF04000200000003000100FFFF01000400FBFFFFFF0100FFFF0200FCFF05000200000001000100FFFF00000500030000000100F9FF0100FFFF0100030001000400FFFF0600FEFF0000FFFF000000000000FEFF000002000300FEFF0000FFFF0400"> : tensor<20x20xi16>
    return %0, %1 : tensor<20x20xi16>, tensor<20x20xi16>
  }
  func.func private @expected() -> tensor<20x20xi16> {
    %0 = stablehlo.constant dense<"0x06000000FFFFFFFFFFFFFFFF0600FDFF0500FEFFFFFFFFFF0100FFFF0500FFFF030004000300FBFFFFFF07000600FFFFFFFFFBFFF7FFFFFFFEFFFFFFFCFF0000FFFF00000700FFFF01000200FFFFFCFFFBFF01000300FFFFFFFF07000300010003000300FFFFFFFF0000FDFF01000100FEFFFFFF0100FEFFFFFFFFFFFFFFFFFF0000FFFFFBFFFEFFFDFFFFFFFDFF0500FDFF06000000FFFFFBFFFFFF05000100FEFF04000100FFFFFFFFFFFFFFFFFEFF0000FFFFFFFFFFFFF9FF00000400FDFF00000700FFFF0100FDFF00000600FDFF0100FEFFFCFFFFFF01000100FFFF04000600FFFFFEFFFEFFFFFFFFFFFFFFFFFFFEFFFEFF01000300FEFFFFFFFEFFFFFFFFFF00000100FFFFFFFFFEFF0000FEFFFFFF04000000FFFFFEFF030000000300FFFFFFFFFFFFFFFFFFFF0300FEFF0200FFFFFDFF05000000FFFF02000400FFFFFFFFFDFF05000000FFFFFDFFFFFFFFFF0100FDFF010001000700FFFFFCFFFBFF0000FFFF02000500040005000400FEFF0300FEFFFBFF0100FEFFFEFFFEFF050006000300FEFFFFFFFDFF0F00F8FFFEFF010002000200FEFFFFFFFCFFFCFFFEFF040002000900FFFFFEFFFFFF02000300FFFFFEFF030003000200FDFF01000300FFFFFFFFFFFF00000300FEFFFEFFFFFF0700FDFFFFFF03000400FFFFFFFFFBFFFFFF01000500FFFF01000000FDFFFAFFFFFFFFFFFDFFFFFFFFFF03000000FFFFFFFFFFFF00000000FBFF0300FEFF0100FFFF01000200FFFFFEFF0700FFFFFDFF0100FFFFFAFFFFFFFDFFFDFF0300FFFFFFFF0300FFFFF9FF0300FFFFFFFFFDFFFDFFFFFF040003000000FDFF0300FAFF0100FFFF0400FEFF0200FFFFFFFF06000100FFFFFDFF0100FEFFFDFFFFFFFFFF0300FEFF0500FDFFFFFF0200FFFF0200060003000600FFFF0000FBFF0500FEFF02000400FFFFFDFFFFFFFDFFFFFFF9FFFEFF03000700FEFF0200FFFF00000000FFFF0200FFFF0700FFFF0000FEFFFFFFFEFFFEFF0100FFFF0300FFFFFFFFFCFFFBFFFFFFFFFFFFFF0200FEFF07000300050001000100FFFF020005000300FFFF0300FBFF0300FFFF0300FFFFFFFF0500FFFF0600FEFFFEFFFFFF000001000400FFFFFFFFFFFF0300FEFF0000FFFFFFFF"> : tensor<20x20xi16>
    return %0 : tensor<20x20xi16>
  }
}
