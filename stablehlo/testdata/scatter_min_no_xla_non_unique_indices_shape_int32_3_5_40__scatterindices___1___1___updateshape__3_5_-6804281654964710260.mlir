// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<1> : tensor<2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<3x5x40xi32>, tensor<3x5x2xi32>)
    %2 = call @expected() : () -> tensor<3x5x40xi32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<i32>, %arg1: tensor<i32>):
      %5 = stablehlo.minimum %arg0, %arg1 : tensor<i32>
      stablehlo.return %5 : tensor<i32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [2], scatter_dims_to_operand_dims = [2], index_vector_dim = 1>} : (tensor<3x5x40xi32>, tensor<2x1xi32>, tensor<3x5x2xi32>) -> tensor<3x5x40xi32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<3x5x40xi32>, tensor<3x5x40xi32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<3x5x40xi32>, tensor<3x5x2xi32>) {
    %0 = stablehlo.constant dense<"0x010000000000000000000000FDFFFFFF04000000FEFFFFFFFFFFFFFF02000000FFFFFFFF0100000000000000FDFFFFFFFBFFFFFF00000000FDFFFFFF01000000FFFFFFFF000000000000000000000000000000000800000005000000FDFFFFFF020000000000000001000000FDFFFFFF010000000000000001000000000000000300000000000000FFFFFFFF0300000000000000FEFFFFFF000000000200000000000000FDFFFFFF030000000000000000000000FFFFFFFFFEFFFFFFFFFFFFFFFFFFFFFF0500000000000000FFFFFFFFFEFFFFFFFDFFFFFF00000000FCFFFFFFFEFFFFFF01000000FFFFFFFFFCFFFFFF00000000FFFFFFFF02000000FFFFFFFF00000000FFFFFFFF000000000100000000000000FEFFFFFF0000000000000000FFFFFFFFFBFFFFFF01000000FCFFFFFF000000000000000000000000FDFFFFFFFDFFFFFF00000000020000000000000000000000FEFFFFFF05000000FCFFFFFF00000000FDFFFFFFFEFFFFFFF9FFFFFFFFFFFFFF03000000FDFFFFFF0300000002000000000000000100000001000000000000000300000002000000FBFFFFFF00000000FCFFFFFFFFFFFFFF02000000000000000200000000000000FDFFFFFFFCFFFFFFFFFFFFFFF9FFFFFFFFFFFFFF03000000FDFFFFFF00000000FCFFFFFF00000000FFFFFFFFFFFFFFFF00000000FEFFFFFF010000000000000001000000FFFFFFFF0300000005000000FFFFFFFF00000000FBFFFFFF01000000FDFFFFFFFEFFFFFF00000000FDFFFFFF00000000010000000000000004000000FEFFFFFF0000000000000000FFFFFFFFF9FFFFFF01000000FFFFFFFF000000000200000000000000010000000000000000000000FFFFFFFF00000000FEFFFFFFFFFFFFFFFDFFFFFF000000000100000001000000FFFFFFFF0000000001000000FBFFFFFF000000000100000001000000FFFFFFFF0400000000000000F9FFFFFF00000000FCFFFFFFFEFFFFFFFBFFFFFFFCFFFFFF000000000200000002000000000000000200000001000000FBFFFFFF02000000FCFFFFFF0000000000000000FFFFFFFFFDFFFFFFFFFFFFFF01000000FFFFFFFF0000000000000000FDFFFFFF030000000000000001000000FFFFFFFF030000000000000000000000FFFFFFFFFDFFFFFF0000000001000000020000000000000000000000FFFFFFFFFEFFFFFF00000000FEFFFFFFFEFFFFFF02000000000000000200000000000000F8FFFFFF000000000200000003000000FEFFFFFF00000000FBFFFFFF000000000300000000000000010000000100000000000000030000000200000005000000FEFFFFFF00000000FDFFFFFFFDFFFFFFFDFFFFFFFEFFFFFF04000000FFFFFFFFFCFFFFFF04000000FFFFFFFFFEFFFFFF01000000000000000200000001000000FBFFFFFF01000000FFFFFFFF01000000FEFFFFFF00000000000000000000000003000000000000000100000000000000000000000000000000000000F9FFFFFF01000000FEFFFFFFFBFFFFFF0000000002000000010000000000000000000000FBFFFFFFF9FFFFFF0000000000000000FEFFFFFF0100000001000000FEFFFFFF00000000010000000000000001000000FDFFFFFFFFFFFFFF03000000000000000000000000000000FFFFFFFF020000000000000006000000FCFFFFFF000000000600000000000000FEFFFFFFFDFFFFFFFFFFFFFFFEFFFFFFFBFFFFFF0200000000000000FAFFFFFFFEFFFFFF02000000010000000200000000000000070000000600000003000000FFFFFFFFF7FFFFFF0000000000000000F9FFFFFFFFFFFFFF0000000002000000FBFFFFFF00000000FCFFFFFFF9FFFFFF01000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000FFFFFFFF00000000050000000100000003000000FFFFFFFF03000000010000000100000002000000FCFFFFFF01000000000000000100000002000000FDFFFFFF04000000000000000000000005000000F9FFFFFF00000000F9FFFFFF01000000FEFFFFFFFFFFFFFFFDFFFFFF01000000FFFFFFFFFFFFFFFF03000000000000000000000000000000FEFFFFFF000000000000000000000000FEFFFFFFFBFFFFFF00000000FCFFFFFFFCFFFFFF00000000FDFFFFFF00000000010000000400000000000000FFFFFFFFFDFFFFFF02000000FFFFFFFFFBFFFFFFFCFFFFFF00000000030000000200000000000000FEFFFFFF000000000200000000000000FFFFFFFF020000000000000000000000070000000000000003000000FEFFFFFF030000000000000003000000FEFFFFFF010000000000000000000000FEFFFFFF0000000003000000FEFFFFFF00000000010000000100000000000000FFFFFFFF020000000100000004000000010000000500000000000000FFFFFFFF00000000F9FFFFFF01000000FFFFFFFFFEFFFFFF02000000FEFFFFFF0300000000000000020000000000000001000000FFFFFFFFFEFFFFFF0600000004000000FCFFFFFFFFFFFFFF030000000200000000000000030000000300000002000000FFFFFFFF00000000FCFFFFFFFFFFFFFF00000000000000000100000002000000FEFFFFFFFEFFFFFFFDFFFFFF0300000002000000FEFFFFFFFFFFFFFFFFFFFFFF0000000000000000FFFFFFFF00000000FCFFFFFFFDFFFFFF0100000000000000040000000000000003000000FFFFFFFFFBFFFFFF000000000000000000000000FFFFFFFFFCFFFFFFFDFFFFFFFFFFFFFF0100000003000000030000000100000000000000020000000100000000000000FDFFFFFF02000000FEFFFFFF000000000200000000000000FEFFFFFF02000000FAFFFFFF00000000010000000000000000000000FCFFFFFFFEFFFFFF0200000002000000020000000B000000FDFFFFFF00000000FBFFFFFF0000000000000000FCFFFFFFFFFFFFFF020000000000000002000000FEFFFFFFFFFFFFFF000000000100000002000000FFFFFFFF02000000000000000000000000000000FDFFFFFF040000000300000000000000FFFFFFFFFFFFFFFFFFFFFFFF0100000002000000FFFFFFFFFDFFFFFF010000000100000001000000FBFFFFFF02000000FDFFFFFFFFFFFFFFFCFFFFFF030000000000000000000000FEFFFFFFFFFFFFFFFDFFFFFF02000000040000000000000002000000FEFFFFFF03000000000000000300000002000000FCFFFFFF02000000FDFFFFFFFFFFFFFF00000000FEFFFFFFFDFFFFFFFEFFFFFF00000000FEFFFFFF00000000FDFFFFFF00000000FFFFFFFFFCFFFFFF00000000FFFFFFFFFEFFFFFF01000000FEFFFFFFFDFFFFFF0100000000000000FEFFFFFFFFFFFFFFFFFFFFFF"> : tensor<3x5x40xi32>
    %1 = stablehlo.constant dense<[[[3, -1], [4, 0], [4, 1], [-1, -4], [0, 0]], [[0, -3], [0, 0], [1, 3], [0, -4], [0, -2]], [[-2, -2], [7, 4], [1, 0], [-2, -2], [2, -2]]]> : tensor<3x5x2xi32>
    return %0, %1 : tensor<3x5x40xi32>, tensor<3x5x2xi32>
  }
  func.func private @expected() -> tensor<3x5x40xi32> {
    %0 = stablehlo.constant dense<"0x01000000FFFFFFFF00000000FDFFFFFF04000000FEFFFFFFFFFFFFFF02000000FFFFFFFF0100000000000000FDFFFFFFFBFFFFFF00000000FDFFFFFF01000000FFFFFFFF000000000000000000000000000000000800000005000000FDFFFFFF020000000000000001000000FDFFFFFF010000000000000001000000000000000300000000000000FFFFFFFF0300000000000000FEFFFFFF000000000200000000000000FDFFFFFF030000000000000000000000FFFFFFFFFEFFFFFFFFFFFFFFFFFFFFFF0500000000000000FFFFFFFFFEFFFFFFFDFFFFFF00000000FCFFFFFFFEFFFFFF01000000FFFFFFFFFCFFFFFF00000000FFFFFFFF02000000FFFFFFFF00000000FFFFFFFF000000000100000000000000FEFFFFFF0000000000000000FFFFFFFFFBFFFFFF01000000FCFFFFFF000000000000000000000000FDFFFFFFFDFFFFFF00000000020000000000000000000000FEFFFFFF05000000FCFFFFFF00000000FDFFFFFFFEFFFFFFF9FFFFFFFFFFFFFF03000000FDFFFFFF0300000002000000000000000100000001000000000000000300000002000000FBFFFFFF00000000FCFFFFFFFFFFFFFF02000000000000000200000000000000FDFFFFFFFCFFFFFFFFFFFFFFF9FFFFFFFFFFFFFF03000000FDFFFFFF00000000FCFFFFFF00000000FCFFFFFFFFFFFFFF00000000FEFFFFFF010000000000000001000000FFFFFFFF0300000005000000FFFFFFFF00000000FBFFFFFF01000000FDFFFFFFFEFFFFFF00000000FDFFFFFF00000000010000000000000004000000FEFFFFFF0000000000000000FFFFFFFFF9FFFFFF01000000FFFFFFFF000000000200000000000000010000000000000000000000FFFFFFFF00000000FEFFFFFFFFFFFFFFFDFFFFFF000000000100000001000000FFFFFFFF0000000001000000FBFFFFFF000000000100000001000000FFFFFFFF0400000000000000F9FFFFFF00000000FCFFFFFFFEFFFFFFFBFFFFFFFCFFFFFF000000000200000002000000000000000200000001000000FBFFFFFF02000000FCFFFFFF0000000000000000FFFFFFFFFDFFFFFFFFFFFFFF01000000FFFFFFFF0000000000000000FDFFFFFF0300000000000000FDFFFFFFFFFFFFFF030000000000000000000000FFFFFFFFFDFFFFFF0000000001000000020000000000000000000000FFFFFFFFFEFFFFFF00000000FEFFFFFFFEFFFFFF02000000000000000200000000000000F8FFFFFF000000000200000003000000FEFFFFFF00000000FBFFFFFF000000000300000000000000010000000100000000000000030000000200000005000000FEFFFFFF00000000FDFFFFFFFDFFFFFFFDFFFFFFFEFFFFFF04000000FFFFFFFFFCFFFFFF04000000FFFFFFFFFEFFFFFF01000000000000000200000001000000FBFFFFFF01000000FFFFFFFF01000000FEFFFFFF00000000000000000000000003000000000000000100000000000000000000000000000000000000F9FFFFFF01000000FEFFFFFFFBFFFFFF0000000002000000010000000000000000000000FBFFFFFFF9FFFFFF0000000000000000FEFFFFFF0100000001000000FEFFFFFF00000000010000000000000001000000FDFFFFFFFFFFFFFF03000000000000000000000000000000FFFFFFFF020000000000000006000000FCFFFFFF000000000600000000000000FEFFFFFFFDFFFFFFFFFFFFFFFEFFFFFFFBFFFFFF0200000000000000FAFFFFFFFEFFFFFF02000000010000000200000000000000070000000600000003000000FFFFFFFFF7FFFFFF0000000000000000F9FFFFFFFFFFFFFF0000000002000000FBFFFFFF00000000FCFFFFFFF9FFFFFF01000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000FFFFFFFF00000000050000000100000003000000FFFFFFFF03000000010000000100000002000000FCFFFFFF01000000000000000100000002000000FDFFFFFF04000000000000000000000005000000F9FFFFFF00000000F9FFFFFF01000000FEFFFFFFFFFFFFFFFDFFFFFF01000000FFFFFFFFFFFFFFFF03000000000000000000000000000000FEFFFFFF000000000000000000000000FEFFFFFFFBFFFFFF00000000FCFFFFFFFCFFFFFF00000000FDFFFFFF00000000010000000400000000000000FFFFFFFFFDFFFFFF02000000FFFFFFFFFBFFFFFFFCFFFFFF00000000030000000200000000000000FEFFFFFF0000000002000000FEFFFFFFFFFFFFFF020000000000000000000000070000000000000003000000FEFFFFFF030000000000000003000000FEFFFFFF010000000000000000000000FEFFFFFF0000000003000000FEFFFFFF00000000010000000100000000000000FFFFFFFF020000000100000004000000010000000500000000000000FFFFFFFF00000000F9FFFFFF01000000FFFFFFFFFEFFFFFF02000000FEFFFFFF0300000000000000020000000000000001000000FFFFFFFFFEFFFFFF0600000004000000FCFFFFFFFFFFFFFF030000000200000000000000030000000300000002000000FFFFFFFF00000000FCFFFFFFFFFFFFFF00000000000000000100000002000000FEFFFFFFFEFFFFFFFDFFFFFF0300000002000000FEFFFFFFFFFFFFFFFFFFFFFF0000000000000000FFFFFFFF00000000FCFFFFFFFDFFFFFF0100000000000000000000000000000003000000FFFFFFFFFBFFFFFF000000000000000000000000FFFFFFFFFCFFFFFFFDFFFFFFFFFFFFFF0100000003000000030000000100000000000000020000000100000000000000FDFFFFFF02000000FEFFFFFF000000000200000000000000FEFFFFFF02000000FAFFFFFF00000000010000000000000000000000FCFFFFFFFEFFFFFF0200000002000000020000000B000000FDFFFFFFFEFFFFFFFBFFFFFF0000000000000000FCFFFFFFFFFFFFFF020000000000000002000000FEFFFFFFFFFFFFFF000000000100000002000000FFFFFFFF02000000000000000000000000000000FDFFFFFF040000000300000000000000FFFFFFFFFFFFFFFFFFFFFFFF0100000002000000FFFFFFFFFDFFFFFF010000000100000001000000FBFFFFFF02000000FDFFFFFFFFFFFFFFFCFFFFFF0300000000000000FEFFFFFFFEFFFFFFFFFFFFFFFDFFFFFF02000000040000000000000002000000FEFFFFFF03000000000000000300000002000000FCFFFFFF02000000FDFFFFFFFFFFFFFF00000000FEFFFFFFFDFFFFFFFEFFFFFF00000000FEFFFFFF00000000FDFFFFFF00000000FFFFFFFFFCFFFFFF00000000FFFFFFFFFEFFFFFF01000000FEFFFFFFFDFFFFFF0100000000000000FEFFFFFFFFFFFFFFFFFFFFFF"> : tensor<3x5x40xi32>
    return %0 : tensor<3x5x40xi32>
  }
}

