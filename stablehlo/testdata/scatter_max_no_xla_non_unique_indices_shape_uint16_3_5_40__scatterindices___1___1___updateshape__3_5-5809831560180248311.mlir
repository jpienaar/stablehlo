// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<1> : tensor<2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<3x5x40xui16>, tensor<3x5x2xui16>)
    %2 = call @expected() : () -> tensor<3x5x40xui16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<ui16>, %arg1: tensor<ui16>):
      %5 = stablehlo.maximum %arg0, %arg1 : tensor<ui16>
      stablehlo.return %5 : tensor<ui16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [2], scatter_dims_to_operand_dims = [2], index_vector_dim = 1>} : (tensor<3x5x40xui16>, tensor<2x1xi32>, tensor<3x5x2xui16>) -> tensor<3x5x40xui16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<3x5x40xui16>, tensor<3x5x40xui16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<3x5x40xui16>, tensor<3x5x2xui16>) {
    %0 = stablehlo.constant dense<"0x01000000010001000200040003000100030001000000040005000300010001000200020002000200000003000000030006000000000000000100050002000200020004000100020002000100000000000300030001000000000000000000010009000300030002000000000000000100010003000200000003000200030000000000020001000200010000000300020004000000010003000500060003000300010003000400030002000200030000000000030000000200040006000000010004000000020000000100000002000200030000000100030001000100000002000000040004000000030003000300040000000100020004000400010000000300030006000100020004000000020002000300020002000B000100010003000000080003000100020001000A00020006000300020000000100000002000100000000000200060001000000020002000100000004000000000002000200040002000200000002000100020002000300020000000400010000000200000001000200020000000100040000000200030004000600040000000200000002000100010004000200010000000700020000000300000001000200000001000000000001000200020004000000000002000100020002000100010005000000000002000800010004000600000003000100000007000000010001000600000007000300030002000100020005000000000002000600000008000200030002000000030000000000040002000000020002000100040002000300030001000200080001000100000004000200030000000400070003000800000006000000010000000200020001000000020000000400010001000400040001000000010002000300020001000000000001000600080002000100000003000100020005000100040004000300040005000000000001000300000001000200010001000100080000000500010000000400020004000400010002000300010000000200000002000000000003000100040001000200000001000100070000000500030004000500060005000200000002000000030001000700010000000000010002000000040000000000040008000500000002000100020003000600010000000500040002000500030001000200020005000700030005000100000004000100020001000100000000000400040003000200000005000200000000000000020000000000000008000100030000000300000003000100040006000400000002000000020000000200010000000300000003000000020003000200000002000100050000000300010008000100020000000300000000000500040002000000010004000300000000000000000001000100020006000300000004000200010000000000010001000100020002000600000004000400010004000000000002000000040000000400020001000100020000000400010001000100010000000200040001000200040002000700010000000300000006000000000000000000010000000200000006000200020003000400000003000000060003000000070002000000050003000300010002000100030005000400030001000300010001000300020003000000000001000000000003000100000001000100060001000000"> : tensor<3x5x40xui16>
    %1 = stablehlo.constant dense<[[[0, 3], [0, 3], [1, 0], [5, 6], [2, 5]], [[2, 2], [5, 3], [1, 4], [3, 5], [3, 1]], [[1, 0], [1, 1], [1, 0], [1, 8], [0, 2]]]> : tensor<3x5x2xui16>
    return %0, %1 : tensor<3x5x40xui16>, tensor<3x5x2xui16>
  }
  func.func private @expected() -> tensor<3x5x40xui16> {
    %0 = stablehlo.constant dense<"0x01000300010001000200040003000100030001000000040005000300010001000200020002000200000003000000030006000000000000000100050002000200020004000100020002000100000000000300030001000000000000000000010009000300030002000000000000000100010003000200000003000200030000000000020001000200010000000300020004000000010003000500060003000300010003000400030002000200030000000000030000000200040006000000010004000000020000000100000002000200030000000100030001000100000002000000040004000000030003000300040000000600020004000400010000000300030006000100020004000000020002000300020002000B000100010003000000080003000100020001000A00020006000300020000000100000002000100000000000500060001000000020002000100000004000000000002000200040002000200000002000100020002000300020000000400010000000200000001000200020000000100040000000200030004000600040000000200000002000100010004000200010000000700020000000300000001000200000001000000000001000200020004000000000002000100020002000100010005000000000002000800010005000600000003000100000007000000010001000600000007000300030002000100020005000000000002000600000008000200030002000000030000000000040002000000020002000100040002000400030001000200080001000100000004000200030000000400070003000800000006000000010000000200020001000000020000000400010001000400040001000000010002000300020001000000050001000600080002000100000003000100020005000100040004000300040005000000000001000300000001000200010001000100080000000500010000000400020004000400010002000300010003000200000002000000000003000100040001000200000001000100070000000500030004000500060005000200000002000000030001000700010000000000010002000000040000000000040008000500000002000100020003000600010000000500040002000500030001000200020005000700030005000100000004000100020001000100000000000400040003000200000005000200000000000000020000000000000008000100030000000300000003000100040006000400000002000000020000000200010000000300000003000000020003000200000002000100050000000300010008000100020001000300000000000500040002000000010004000300000000000000000001000100020006000300000004000200010000000000010001000100020002000600000004000400010004000000000002000800040000000400020001000100020000000400010001000100010000000200040001000200040002000700010000000300000006000000000000000000010000000200000006000200020003000400020003000000060003000000070002000000050003000300010002000100030005000400030001000300010001000300020003000000000001000000000003000100000001000100060001000000"> : tensor<3x5x40xui16>
    return %0 : tensor<3x5x40xui16>
  }
}

