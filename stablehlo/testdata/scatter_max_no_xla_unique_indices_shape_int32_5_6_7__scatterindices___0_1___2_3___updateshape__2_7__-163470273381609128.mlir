// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[0, 1], [2, 3]]> : tensor<2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xi32>, tensor<2x7xi32>)
    %2 = call @expected() : () -> tensor<5x6x7xi32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<i32>, %arg1: tensor<i32>):
      %5 = stablehlo.maximum %arg0, %arg1 : tensor<i32>
      stablehlo.return %5 : tensor<i32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [1], inserted_window_dims = [0, 1], scatter_dims_to_operand_dims = [0, 1], index_vector_dim = 1>, unique_indices = true} : (tensor<5x6x7xi32>, tensor<2x2xi32>, tensor<2x7xi32>) -> tensor<5x6x7xi32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xi32>, tensor<5x6x7xi32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xi32>, tensor<2x7xi32>) {
    %0 = stablehlo.constant dense<"0x04000000FDFFFFFF0000000001000000FFFFFFFF0000000002000000FEFFFFFF00000000FFFFFFFF000000000100000000000000010000000400000001000000FDFFFFFF0100000004000000FBFFFFFF0000000002000000FDFFFFFFFFFFFFFF030000000100000006000000010000000200000000000000FEFFFFFF000000000100000003000000FDFFFFFF02000000FDFFFFFF05000000FCFFFFFF0100000000000000FDFFFFFF01000000FEFFFFFF02000000030000000400000002000000000000000000000001000000F9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000FFFFFFFF0200000000000000FEFFFFFF00000000FEFFFFFF0500000000000000FFFFFFFF00000000FFFFFFFFFDFFFFFFFFFFFFFF00000000010000000400000000000000FFFFFFFF010000000100000006000000010000000100000003000000FCFFFFFF04000000FBFFFFFF02000000000000000000000000000000FCFFFFFFFEFFFFFF0000000001000000FDFFFFFF0400000000000000FCFFFFFF00000000FEFFFFFF01000000020000000200000000000000FFFFFFFF00000000010000000100000003000000FDFFFFFF060000000200000004000000030000000400000001000000FAFFFFFF08000000FDFFFFFFFFFFFFFFF8FFFFFF0000000001000000FEFFFFFFFFFFFFFF00000000FCFFFFFF0100000000000000FFFFFFFF000000000000000000000000000000000600000000000000FEFFFFFF0200000000000000000000000300000002000000FFFFFFFFFEFFFFFF0000000004000000010000000100000003000000FDFFFFFF00000000FFFFFFFFFFFFFFFF00000000FEFFFFFFFEFFFFFF01000000FDFFFFFFFEFFFFFF0300000002000000FEFFFFFFFFFFFFFF00000000010000000000000000000000FDFFFFFF030000000000000000000000FDFFFFFF04000000000000000000000000000000020000000100000000000000FEFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFF0000000005000000FEFFFFFF000000000000000000000000FDFFFFFFFDFFFFFF01000000FEFFFFFFFEFFFFFF040000000000000001000000FFFFFFFFFDFFFFFF00000000FEFFFFFFFFFFFFFFFBFFFFFF00000000FDFFFFFFFCFFFFFF00000000FAFFFFFF0400000000000000FBFFFFFF00000000"> : tensor<5x6x7xi32>
    %1 = stablehlo.constant dense<[[2, 0, -4, 0, 0, -1, 0], [-1, 2, -4, -1, 5, 0, 0]]> : tensor<2x7xi32>
    return %0, %1 : tensor<5x6x7xi32>, tensor<2x7xi32>
  }
  func.func private @expected() -> tensor<5x6x7xi32> {
    %0 = stablehlo.constant dense<"0x04000000FDFFFFFF0000000001000000FFFFFFFF00000000020000000200000000000000FFFFFFFF000000000100000000000000010000000400000001000000FDFFFFFF0100000004000000FBFFFFFF0000000002000000FDFFFFFFFFFFFFFF030000000100000006000000010000000200000000000000FEFFFFFF000000000100000003000000FDFFFFFF02000000FDFFFFFF05000000FCFFFFFF0100000000000000FDFFFFFF01000000FEFFFFFF02000000030000000400000002000000000000000000000001000000F9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000FFFFFFFF0200000000000000FEFFFFFF00000000FEFFFFFF0500000000000000FFFFFFFF00000000FFFFFFFFFDFFFFFFFFFFFFFF00000000010000000400000000000000FFFFFFFF010000000100000006000000010000000100000003000000FCFFFFFF04000000FBFFFFFF02000000000000000000000000000000FCFFFFFFFEFFFFFF0000000001000000FDFFFFFF0400000000000000FCFFFFFF00000000FEFFFFFF01000000020000000200000000000000FFFFFFFF0000000001000000010000000300000002000000060000000200000005000000030000000400000001000000FAFFFFFF08000000FDFFFFFFFFFFFFFFF8FFFFFF0000000001000000FEFFFFFFFFFFFFFF00000000FCFFFFFF0100000000000000FFFFFFFF000000000000000000000000000000000600000000000000FEFFFFFF0200000000000000000000000300000002000000FFFFFFFFFEFFFFFF0000000004000000010000000100000003000000FDFFFFFF00000000FFFFFFFFFFFFFFFF00000000FEFFFFFFFEFFFFFF01000000FDFFFFFFFEFFFFFF0300000002000000FEFFFFFFFFFFFFFF00000000010000000000000000000000FDFFFFFF030000000000000000000000FDFFFFFF04000000000000000000000000000000020000000100000000000000FEFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFF0000000005000000FEFFFFFF000000000000000000000000FDFFFFFFFDFFFFFF01000000FEFFFFFFFEFFFFFF040000000000000001000000FFFFFFFFFDFFFFFF00000000FEFFFFFFFFFFFFFFFBFFFFFF00000000FDFFFFFFFCFFFFFF00000000FAFFFFFF0400000000000000FBFFFFFF00000000"> : tensor<5x6x7xi32>
    return %0 : tensor<5x6x7xi32>
  }
}

