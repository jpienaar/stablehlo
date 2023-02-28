// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0], [1]], [[2], [3]]]> : tensor<2x2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xi32>, tensor<5x2x2x7xi32>)
    %2 = call @expected() : () -> tensor<5x6x7xi32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<i32>, %arg1: tensor<i32>):
      stablehlo.return %arg1 : tensor<i32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 3], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xi32>, tensor<2x2x1xi32>, tensor<5x2x2x7xi32>) -> tensor<5x6x7xi32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xi32>, tensor<5x6x7xi32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xi32>, tensor<5x2x2x7xi32>) {
    %0 = stablehlo.constant dense<"0xFFFFFFFF06000000000000000000000001000000000000000200000003000000FCFFFFFF01000000FEFFFFFF0000000000000000030000000000000000000000FEFFFFFF0000000000000000FEFFFFFFFEFFFFFF0100000006000000000000000400000004000000FEFFFFFFFCFFFFFF06000000FFFFFFFF02000000FEFFFFFF0400000003000000000000000100000000000000040000000200000004000000FCFFFFFFFEFFFFFF00000000FDFFFFFFFFFFFFFF000000000100000000000000040000000100000004000000FBFFFFFF00000000FDFFFFFF00000000000000000000000003000000FCFFFFFFFFFFFFFF03000000FEFFFFFF02000000FFFFFFFFFEFFFFFF000000000000000001000000000000000300000001000000FEFFFFFF000000000000000000000000FCFFFFFF01000000FBFFFFFF00000000FEFFFFFFFDFFFFFF0500000000000000FEFFFFFF0200000001000000FEFFFFFFFDFFFFFF0100000004000000040000000200000002000000FDFFFFFF00000000FEFFFFFF010000000100000007000000FFFFFFFFFAFFFFFF00000000FEFFFFFF020000000300000000000000FCFFFFFFFEFFFFFF00000000000000000000000002000000FEFFFFFFFCFFFFFF000000000100000002000000010000000100000004000000FBFFFFFF0200000001000000FEFFFFFFFEFFFFFF00000000FFFFFFFF0200000001000000020000000400000003000000FCFFFFFFFEFFFFFFFDFFFFFF00000000FFFFFFFFFFFFFFFFFDFFFFFF01000000FDFFFFFF00000000000000000100000003000000FEFFFFFF00000000000000000100000002000000FEFFFFFF0000000006000000000000000300000001000000FFFFFFFF0000000000000000FDFFFFFF00000000000000000200000003000000FDFFFFFFFEFFFFFF0500000005000000FEFFFFFFFEFFFFFF01000000FEFFFFFFFFFFFFFF0200000005000000010000000000000001000000FEFFFFFF00000000020000000000000005000000FFFFFFFFFEFFFFFFFAFFFFFF00000000FCFFFFFFFEFFFFFFFEFFFFFFFDFFFFFF000000000100000003000000FFFFFFFF010000000000000000000000FFFFFFFFFDFFFFFF000000000300000003000000030000000200000001000000F8FFFFFF000000000200000000000000"> : tensor<5x6x7xi32>
    %1 = stablehlo.constant dense<"0x04000000FDFFFFFF000000000100000000000000FFFFFFFFFDFFFFFF050000000100000000000000FFFFFFFFFEFFFFFF000000000200000004000000F9FFFFFF03000000000000000300000000000000FEFFFFFFFEFFFFFF0000000002000000FBFFFFFFFFFFFFFF00000000010000000100000000000000020000000000000001000000FDFFFFFF0300000002000000010000000400000001000000FDFFFFFF00000000010000000000000000000000FFFFFFFF0200000003000000FDFFFFFF09000000000000000000000003000000FFFFFFFFFFFFFFFF0000000004000000FDFFFFFFFFFFFFFF00000000000000000200000004000000FFFFFFFFFEFFFFFF0400000005000000FFFFFFFFFEFFFFFFFEFFFFFF040000000000000007000000FCFFFFFFFEFFFFFFFFFFFFFF050000000000000000000000010000000000000003000000FDFFFFFFFCFFFFFF010000000100000000000000FDFFFFFF00000000FFFFFFFFFFFFFFFF04000000FFFFFFFF020000000000000001000000FCFFFFFFFEFFFFFF00000000FFFFFFFF0000000000000000020000000300000000000000FEFFFFFF00000000FDFFFFFFFDFFFFFF01000000FFFFFFFFFFFFFFFFFEFFFFFF04000000000000000500000002000000FDFFFFFF000000000000000001000000000000000400000000000000FCFFFFFF00000000000000000200000004000000FBFFFFFF010000000200000000000000FEFFFFFF00000000FDFFFFFF0000000001000000FCFFFFFF0000000002000000"> : tensor<5x2x2x7xi32>
    return %0, %1 : tensor<5x6x7xi32>, tensor<5x2x2x7xi32>
  }
  func.func private @expected() -> tensor<5x6x7xi32> {
    %0 = stablehlo.constant dense<"0x04000000FDFFFFFF000000000100000000000000FFFFFFFFFDFFFFFF050000000100000000000000FFFFFFFFFEFFFFFF000000000200000004000000F9FFFFFF03000000000000000300000000000000FEFFFFFFFEFFFFFF0000000002000000FBFFFFFFFFFFFFFF000000000100000006000000FFFFFFFF02000000FEFFFFFF0400000003000000000000000100000000000000040000000200000004000000FCFFFFFFFEFFFFFF0100000000000000020000000000000001000000FDFFFFFF0300000002000000010000000400000001000000FDFFFFFF00000000010000000000000000000000FFFFFFFF0200000003000000FDFFFFFF09000000000000000000000003000000FFFFFFFFFFFFFFFF000000000400000001000000FEFFFFFF000000000000000000000000FCFFFFFF01000000FBFFFFFF00000000FEFFFFFFFDFFFFFF0500000000000000FEFFFFFFFDFFFFFFFFFFFFFF00000000000000000200000004000000FFFFFFFFFEFFFFFF0400000005000000FFFFFFFFFEFFFFFFFEFFFFFF040000000000000007000000FCFFFFFFFEFFFFFFFFFFFFFF050000000000000000000000010000000000000003000000FDFFFFFFFCFFFFFF01000000FEFFFFFFFCFFFFFF000000000100000002000000010000000100000004000000FBFFFFFF0200000001000000FEFFFFFFFEFFFFFF000000000100000000000000FDFFFFFF00000000FFFFFFFFFFFFFFFF04000000FFFFFFFF020000000000000001000000FCFFFFFFFEFFFFFF00000000FFFFFFFF0000000000000000020000000300000000000000FEFFFFFF00000000FDFFFFFFFDFFFFFF01000000FFFFFFFFFFFFFFFFFEFFFFFF0300000001000000FFFFFFFF0000000000000000FDFFFFFF00000000000000000200000003000000FDFFFFFFFEFFFFFF050000000500000004000000000000000500000002000000FDFFFFFF000000000000000001000000000000000400000000000000FCFFFFFF00000000000000000200000004000000FBFFFFFF010000000200000000000000FEFFFFFF00000000FDFFFFFF0000000001000000FCFFFFFF00000000020000000000000000000000FFFFFFFFFDFFFFFF000000000300000003000000030000000200000001000000F8FFFFFF000000000200000000000000"> : tensor<5x6x7xi32>
    return %0 : tensor<5x6x7xi32>
  }
}

