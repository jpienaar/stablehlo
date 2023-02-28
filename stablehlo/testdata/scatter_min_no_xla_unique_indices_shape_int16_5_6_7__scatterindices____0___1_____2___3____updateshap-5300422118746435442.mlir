// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0], [1]], [[2], [3]]]> : tensor<2x2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xi16>, tensor<5x2x2x7xi16>)
    %2 = call @expected() : () -> tensor<5x6x7xi16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<i16>, %arg1: tensor<i16>):
      %5 = stablehlo.minimum %arg0, %arg1 : tensor<i16>
      stablehlo.return %5 : tensor<i16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 3], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xi16>, tensor<2x2x1xi32>, tensor<5x2x2x7xi16>) -> tensor<5x6x7xi16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xi16>, tensor<5x6x7xi16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xi16>, tensor<5x2x2x7xi16>) {
    %0 = stablehlo.constant dense<"0xFDFF0000020001000200030000000100FEFF0100000004000100FFFF0300FFFFFFFF0300FFFF0300000003000800010003000400FDFF0000050000000000FFFFFFFFFFFF03000200FCFF0000010001000000F9FFFEFF02000200FDFF0300FDFF0000000000000100FEFF00000400FCFF0100020003000200FDFFFEFFFFFFFFFF00000200FCFF02000100FEFFFBFF0300FFFF0000FEFFFEFF0200FAFF01000000F9FF0200FFFF00000000FFFF0400FDFFFFFF0000010001000100FDFF0000FFFFFCFF00000500000002000300FDFFFCFF0000000002000100FCFF000000000000FCFF030001000400000001000100FFFF0300020002000200FFFFFEFFFCFFFFFFFDFF020001000500040000000200FDFFFEFF00000100020000000100000000000200FCFF0000FCFF03000000030000000100000002000300000003000000FBFF0500FFFF020009000700FEFF0100040000000000FFFFFFFF0000FEFF00000000FFFFFFFFFEFFFEFF020000000300FDFFFDFF0000FFFF080001000800FEFFFFFF0100FDFFFFFF0300FEFF02000100FFFFFDFFFCFFFEFF02000300FDFF0200FCFF04000000"> : tensor<5x6x7xi16>
    %1 = stablehlo.constant dense<"0xFFFF0000000000000300060001000000FEFF02000000030000000200010000000200FFFFFFFF050000000000FCFF0000FFFFFEFFF8FF00000000FBFFFAFF0300040000000300FBFFFCFF000000000800000002000000FFFF020004000500FFFF00000200FEFFFFFF03000100020000000300020001000000FFFFFDFFFDFFFEFF040000000000FEFFFFFF01000300FBFF00000000FCFFFFFF0000FCFF00000000FCFF0100FEFF010003000300000000000100FEFFFCFF0300FFFFFCFF02000100FDFF000000000200FEFFFBFF04000000FCFFF9FFFAFFFEFF03000000FDFFFCFF0000FEFF0200010002000200FEFF01000000FDFF08000200FFFF0000FDFF010001000000FFFF040000000300FDFF00000200FAFF0200FCFF"> : tensor<5x2x2x7xi16>
    return %0, %1 : tensor<5x6x7xi16>, tensor<5x2x2x7xi16>
  }
  func.func private @expected() -> tensor<5x6x7xi16> {
    %0 = stablehlo.constant dense<"0xFDFF0000000000000200030000000000FEFF0100000003000000FFFF0100FFFFFFFFFFFFFFFF030000000000FCFF0000FFFFFEFFF8FF0000050000000000FFFFFFFFFFFF03000200FCFF0000010001000000F9FFFEFFFBFFFAFFFDFF0300FDFF0000FBFFFCFF0000FEFF00000000FCFF0000FFFF02000200FDFFFEFFFFFFFFFFFEFFFFFFFCFF01000100FEFFFBFF0300FFFF0000FEFFFEFF0200FAFF01000000F9FF0200FFFF00000000FFFF0100FDFFFFFFFDFFFDFFFEFF0100FDFF0000FEFFFCFF00000300FBFF00000000FCFFFCFF0000FCFF00000000FCFF0000FEFF0000FCFF030001000400000001000100FFFF0300020002000200FFFFFEFFFCFFFFFFFDFF00000100FEFFFCFF0000FFFFFCFFFEFF0000FDFF000000000100FEFFFBFF0200FCFFFCFFF9FFFAFFFEFF03000000FDFFFCFF02000300000003000000FBFF0500FFFF020009000700FEFF010004000000FEFFFFFFFFFF0000FEFFFEFF0000FFFFFDFFFEFFFEFFFFFF0000FDFFFDFFFDFF0000FFFF040000000300FDFFFFFF0100FAFFFFFFFCFFFEFF02000100FFFFFDFFFCFFFEFF02000300FDFF0200FCFF04000000"> : tensor<5x6x7xi16>
    return %0 : tensor<5x6x7xi16>
  }
}

