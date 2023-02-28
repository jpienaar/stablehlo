// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<1> : tensor<2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<3x5x40xi16>, tensor<3x5x2xi16>)
    %2 = call @expected() : () -> tensor<3x5x40xi16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<i16>, %arg1: tensor<i16>):
      %5 = stablehlo.add %arg0, %arg1 : tensor<i16>
      stablehlo.return %5 : tensor<i16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [2], scatter_dims_to_operand_dims = [2], index_vector_dim = 1>} : (tensor<3x5x40xi16>, tensor<2x1xi32>, tensor<3x5x2xi16>) -> tensor<3x5x40xi16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<3x5x40xi16>, tensor<3x5x40xi16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<3x5x40xi16>, tensor<3x5x2xi16>) {
    %0 = stablehlo.constant dense<"0xFFFFFCFF01000100000000000200FFFF0000030000000200FCFFFFFF0000FDFF070000000000000002000000FFFF01000000FBFF0000010000000200FDFFFFFF03000000FDFFFCFF0200040000000300FFFF0400FDFFFFFF0100FDFF00000100FDFF04000000FFFF0000040002000100FDFFFEFF01000400FCFF0400000003000000FFFFFFFF00000700FEFFFBFFFFFF0100FEFF020005000000020001000300FAFFFBFF0100FCFFFFFF01000000010002000100FDFF00000000FAFF0000000000000200FFFF0200000000000100000003000700FEFFFDFF00000000020004000000FEFFFFFFFDFF0200FBFFFEFFFFFF000007000200FDFF0300FDFF060000000100000003000000FBFFFBFF04000100FEFFFDFF0300020001000000FDFFFFFFFFFF0300FFFF03000100FEFFFCFF0000FCFF01000100FFFF010004000000FFFFFEFF0300FDFFFFFF0300000000000500FFFF000001000000FCFF02000200FFFF020002000200000000000000FEFF00000100F9FF00000000000005000400FFFFFEFF00000100FBFF0600FBFFFEFFF8FF0400FCFFFEFFFCFFFFFF01000000FDFF0300010002000000FFFF0000010001000100060005000000FFFFFCFFFAFFFDFF0000F9FF000000000000030000000100FFFFFDFFFEFFFEFF0B0000000000FDFF00000000000000000100FDFF00000300FEFFFFFFFEFF04000000FFFFFAFFFFFFFFFFFEFFFEFFFFFFFEFF0000FEFFFEFFFCFFFEFF0600FAFF0200FFFFFBFF02000000040001000300030000000000020004000100F9FF0300FFFFFDFF0000010004000200FFFFFEFFFEFF01000000FCFFFDFFFFFF0000030000000000010000000100FFFF00000500FFFFFEFF0500FFFF0300000000000000000000000200FFFF0000FEFFFEFFFEFFFEFFFFFF04000000FDFFF9FF04000000000001000000040002000300FEFF030000000200FCFFFFFF0500FEFFFFFF00000100FEFF0000FBFFFDFFFDFFFFFF020008000100FFFF0000FEFFFCFF02000000FFFF000004000200FFFF00000100FDFF0000FEFF020000000000FEFFFEFF0000000004000600000004000000020001000000FEFF040005000000FFFFFFFFFDFF03000000FEFFFDFF010000000100FEFF00000400FEFFFDFF0000F7FFFEFF0000FFFF010000000000010003000000000000000200030000000200FDFF02000100FFFF03000000FDFFFEFF0700FDFFFFFF0200000000000600FFFFFFFFFFFF0300FDFFF9FF0100040001000000FEFFFBFF0000FDFFFEFF00000300FDFF06000200FDFF01000600000002000300FDFF0400FFFF0400FDFF000000000000FDFF0100FDFF0000FFFFFFFFFDFFFEFF0400FCFF000000000100FDFFFAFFFEFFFFFFFCFF0000FFFF000005000500020001000300FBFF03000400FBFFFDFF0400FFFFFFFF0000FEFFFDFF0300FDFFFBFFFCFFFFFF0100FEFFFFFF0000FEFF000003000200FEFFFDFFFFFF0400000003000200FBFFFFFF0200FFFF0000FBFF00000200FFFF01000000FEFFFBFF000000000000010003000100FEFFFDFFFCFFFCFF0300FEFFFDFF010001000100FCFF0000FDFFFCFFFFFFFFFF0100FEFFFFFF070004000000FEFFFDFFFDFFFFFF0100FDFFFCFFFDFFFDFF0400030000000300FDFF0100FCFF00000300FCFF010000000000FDFF00000600000000000100"> : tensor<3x5x40xi16>
    %1 = stablehlo.constant dense<[[[-1, -4], [-4, 2], [-2, 1], [0, -1], [2, -3]], [[0, -1], [2, 0], [0, 0], [0, 5], [0, 0]], [[1, -5], [-3, 1], [-1, 2], [4, 1], [1, -3]]]> : tensor<3x5x2xi16>
    return %0, %1 : tensor<3x5x40xi16>, tensor<3x5x2xi16>
  }
  func.func private @expected() -> tensor<3x5x40xi16> {
    %0 = stablehlo.constant dense<"0xFFFFF7FF01000100000000000200FFFF0000030000000200FCFFFFFF0000FDFF070000000000000002000000FFFF01000000FBFF0000010000000200FDFFFFFF03000000FDFFFCFF0200040000000300FFFF0200FDFFFFFF0100FDFF00000100FDFF04000000FFFF0000040002000100FDFFFEFF01000400FCFF0400000003000000FFFFFFFF00000700FEFFFBFFFFFF0100FEFF020005000000020001000300FAFFFAFF0100FCFFFFFF01000000010002000100FDFF00000000FAFF0000000000000200FFFF0200000000000100000003000700FEFFFDFF00000000020004000000FEFFFFFFFDFF0200FBFFFEFFFFFF000006000200FDFF0300FDFF060000000100000003000000FBFFFBFF04000100FEFFFDFF0300020001000000FDFFFFFFFFFF0300FFFF03000100FEFFFCFF0000FCFF01000100FFFF010004000000FFFFFEFF0200FDFFFFFF0300000000000500FFFF000001000000FCFF02000200FFFF020002000200000000000000FEFF00000100F9FF00000000000005000400FFFFFEFF00000100FBFF0600FBFFFEFFF8FF0400FBFFFEFFFCFFFFFF01000000FDFF0300010002000000FFFF0000010001000100060005000000FFFFFCFFFAFFFDFF0000F9FF000000000000030000000100FFFFFDFFFEFFFEFF0B0000000000FDFF00000200000000000100FDFF00000300FEFFFFFFFEFF04000000FFFFFAFFFFFFFFFFFEFFFEFFFFFFFEFF0000FEFFFEFFFCFFFEFF0600FAFF0200FFFFFBFF02000000040001000300030000000000020004000100F9FF0300FFFFFDFF0000010004000200FFFFFEFFFEFF01000000FCFFFDFFFFFF0000030000000000010000000100FFFF00000500FFFFFEFF0500FFFF0300000000000000000000000200FFFF00000300FEFFFEFFFEFFFFFF04000000FDFFF9FF04000000000001000000040002000300FEFF030000000200FCFFFFFF0500FEFFFFFF00000100FEFF0000FBFFFDFFFDFFFFFF020008000100FFFF0000FEFFFCFF02000000FFFF000004000200FFFF00000100FDFF0000FEFF020000000000FEFFFEFF0000000004000600000004000000020001000000FEFF040005000000FFFFFFFFFDFF03000000FEFFFDFF0100FCFF0100FEFF00000400FEFFFDFF0000F7FFFEFF0000FFFF010000000000010003000000000000000200030000000200FDFF02000100FFFF03000000FDFFFEFF0700FDFFFFFF0200000000000600FFFFFDFFFFFF0300FDFFF9FF0100040001000000FEFFFBFF0000FDFFFEFF00000300FDFF06000200FDFF01000600000002000300FDFF0400FFFF0400FDFF000000000000FDFF0100FDFF0000FFFFFFFFFDFFFFFF0400FCFF000000000100FDFFFAFFFEFFFFFFFCFF0000FFFF000005000500020001000300FBFF03000400FBFFFDFF0400FFFFFFFF0000FEFFFDFF0300FDFFFBFFFCFFFFFF0100FEFFFFFF0000FEFF050003000200FEFFFDFFFFFF0400000003000200FBFFFFFF0200FFFF0000FBFF00000200FFFF01000000FEFFFBFF000000000000010003000100FEFFFDFFFCFFFCFF0300FEFFFDFF010001000100FCFFFEFFFDFFFCFFFFFFFFFF0100FEFFFFFF070004000000FEFFFDFFFDFFFFFF0100FDFFFCFFFDFFFDFF0400030000000300FDFF0100FCFF00000300FCFF010000000000FDFF00000600000000000100"> : tensor<3x5x40xi16>
    return %0 : tensor<3x5x40xi16>
  }
}

