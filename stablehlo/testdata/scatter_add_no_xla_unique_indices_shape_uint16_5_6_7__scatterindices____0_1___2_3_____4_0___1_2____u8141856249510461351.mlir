// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0, 1], [2, 3]], [[4, 0], [1, 2]]]> : tensor<2x2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xui16>, tensor<5x2x2xui16>)
    %2 = call @expected() : () -> tensor<5x6x7xui16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<ui16>, %arg1: tensor<ui16>):
      %5 = stablehlo.add %arg0, %arg1 : tensor<ui16>
      stablehlo.return %5 : tensor<ui16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1, 2], scatter_dims_to_operand_dims = [1, 2], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xui16>, tensor<2x2x2xi32>, tensor<5x2x2xui16>) -> tensor<5x6x7xui16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xui16>, tensor<5x6x7xui16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xui16>, tensor<5x2x2xui16>) {
    %0 = stablehlo.constant dense<"0x010000000100000009000300000002000700040001000500010005000500020002000100000000000200020003000100040000000000030005000000000000000100000001000100030003000500030000000300020001000000000006000400010000000300000003000300050002000100050001000400010004000100000005000000040003000300010001000300010005000000000000000000010001000000000000000200020001000100000001000500040005000200060004000000010002000000020002000300000005000000000001000000010000000000020000000100020000000000000001000000000002000100000001000100010001000100010001000200000000000100030001000200050002000000030000000600010002000000010002000300010002000100080001000500050001000300010004000400030001000400000002000200010002000000040002000000000003000200010000000000010005000000080003000200000002000200010006000300000001000000060002000400040004000200000000000100010004000200050004000200"> : tensor<5x6x7xui16>
    %1 = stablehlo.constant dense<[[[0, 3], [1, 0]], [[2, 2], [1, 0]], [[0, 4], [1, 0]], [[2, 3], [0, 1]], [[1, 4], [2, 1]]]> : tensor<5x2x2xui16>
    return %0, %1 : tensor<5x6x7xui16>, tensor<5x2x2xui16>
  }
  func.func private @expected() -> tensor<5x6x7xui16> {
    %0 = stablehlo.constant dense<"0x010000000100000009000300000002000700040001000500010005000500020002000400000000000200020003000100040000000000030006000000000000000100000001000100030003000500030000000300020003000000000006000400010000000300000003000300050002000100050001000600010004000100000005000000040003000300010002000300010005000000000000000000010001000000000000000200020001000100000001000500040005000200060004000000010002000000020002000700000005000000000001000000010000000000020001000100020000000000000001000000000002000100000001000100010003000100010001000200000000000100040001000200050002000000030000000900010002000000010002000300010002000100080001000500050001000300010004000400030001000400000002000200010003000000040002000000000003000200020000000000010005000000080003000600000002000200010006000300000001000000060004000400040004000200000000000100010004000200050004000200"> : tensor<5x6x7xui16>
    return %0 : tensor<5x6x7xui16>
  }
}

