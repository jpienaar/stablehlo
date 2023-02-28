// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<0> : tensor<1xi32>
    %1:2 = call @inputs() : () -> (tensor<1x125xi32>, tensor<1xi32>)
    %2 = call @expected() : () -> tensor<1x125xi32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<i32>, %arg1: tensor<i32>):
      %5 = stablehlo.multiply %arg0, %arg1 : tensor<i32>
      stablehlo.return %5 : tensor<i32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1]>, unique_indices = true} : (tensor<1x125xi32>, tensor<1xi32>, tensor<1xi32>) -> tensor<1x125xi32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<1x125xi32>, tensor<1x125xi32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1x125xi32>, tensor<1xi32>) {
    %0 = stablehlo.constant dense<"0x000000000100000001000000FFFFFFFFFEFFFFFFFDFFFFFFFEFFFFFF00000000010000000000000000000000FEFFFFFF00000000FEFFFFFF03000000FFFFFFFF00000000FCFFFFFFFEFFFFFF0100000003000000FEFFFFFF0600000000000000FDFFFFFFFFFFFFFFFEFFFFFFFEFFFFFF0000000000000000FFFFFFFF04000000FAFFFFFF0000000002000000FDFFFFFFF9FFFFFF000000000100000004000000FDFFFFFFFBFFFFFFFFFFFFFF00000000FFFFFFFFFCFFFFFF000000000000000001000000FEFFFFFFFFFFFFFF0200000000000000000000000200000003000000000000000200000000000000FBFFFFFFFEFFFFFF00000000FDFFFFFFFFFFFFFFFEFFFFFFFCFFFFFF0100000003000000FFFFFFFF010000000000000003000000FCFFFFFFFFFFFFFF0000000003000000FAFFFFFF000000000700000001000000FEFFFFFF0000000006000000FCFFFFFFFFFFFFFF0100000000000000FFFFFFFF0000000000000000000000000000000001000000F9FFFFFFFEFFFFFF00000000FEFFFFFFFEFFFFFFFEFFFFFFFEFFFFFFFFFFFFFFFDFFFFFF0000000003000000040000000400000000000000FBFFFFFFFEFFFFFF03000000FFFFFFFF01000000FFFFFFFFF9FFFFFF0400000001000000FDFFFFFF000000000500000000000000FDFFFFFFFEFFFFFF0400000000000000FBFFFFFF"> : tensor<1x125xi32>
    %1 = stablehlo.constant dense<0> : tensor<1xi32>
    return %0, %1 : tensor<1x125xi32>, tensor<1xi32>
  }
  func.func private @expected() -> tensor<1x125xi32> {
    %0 = stablehlo.constant dense<"0x000000000100000001000000FFFFFFFFFEFFFFFFFDFFFFFFFEFFFFFF00000000010000000000000000000000FEFFFFFF00000000FEFFFFFF03000000FFFFFFFF00000000FCFFFFFFFEFFFFFF0100000003000000FEFFFFFF0600000000000000FDFFFFFFFFFFFFFFFEFFFFFFFEFFFFFF0000000000000000FFFFFFFF04000000FAFFFFFF0000000002000000FDFFFFFFF9FFFFFF000000000100000004000000FDFFFFFFFBFFFFFFFFFFFFFF00000000FFFFFFFFFCFFFFFF000000000000000001000000FEFFFFFFFFFFFFFF0200000000000000000000000200000003000000000000000200000000000000FBFFFFFFFEFFFFFF00000000FDFFFFFFFFFFFFFFFEFFFFFFFCFFFFFF0100000003000000FFFFFFFF010000000000000003000000FCFFFFFFFFFFFFFF0000000003000000FAFFFFFF000000000700000001000000FEFFFFFF0000000006000000FCFFFFFFFFFFFFFF0100000000000000FFFFFFFF0000000000000000000000000000000001000000F9FFFFFFFEFFFFFF00000000FEFFFFFFFEFFFFFFFEFFFFFFFEFFFFFFFFFFFFFFFDFFFFFF0000000003000000040000000400000000000000FBFFFFFFFEFFFFFF03000000FFFFFFFF01000000FFFFFFFFF9FFFFFF0400000001000000FDFFFFFF000000000500000000000000FDFFFFFFFEFFFFFF0400000000000000FBFFFFFF"> : tensor<1x125xi32>
    return %0 : tensor<1x125xi32>
  }
}

