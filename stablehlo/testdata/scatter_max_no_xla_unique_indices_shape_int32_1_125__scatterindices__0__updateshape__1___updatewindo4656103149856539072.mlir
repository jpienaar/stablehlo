// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<0> : tensor<1xi32>
    %1:2 = call @inputs() : () -> (tensor<1x125xi32>, tensor<1xi32>)
    %2 = call @expected() : () -> tensor<1x125xi32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<i32>, %arg1: tensor<i32>):
      %5 = stablehlo.maximum %arg0, %arg1 : tensor<i32>
      stablehlo.return %5 : tensor<i32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1]>, unique_indices = true} : (tensor<1x125xi32>, tensor<1xi32>, tensor<1xi32>) -> tensor<1x125xi32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<1x125xi32>, tensor<1x125xi32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1x125xi32>, tensor<1xi32>) {
    %0 = stablehlo.constant dense<"0xFFFFFFFF00000000FEFFFFFFFEFFFFFFFBFFFFFF0100000000000000FDFFFFFF00000000FEFFFFFF03000000FFFFFFFFFDFFFFFFFFFFFFFF020000000200000000000000000000000300000001000000FCFFFFFFFCFFFFFF0400000000000000FFFFFFFFFFFFFFFF02000000FDFFFFFF01000000FEFFFFFF00000000FBFFFFFFFEFFFFFFFFFFFFFFFFFFFFFF050000000000000000000000FFFFFFFF0300000000000000FEFFFFFF00000000FDFFFFFF000000000200000005000000FEFFFFFF0400000002000000000000000200000000000000FDFFFFFF000000000200000001000000F8FFFFFFFFFFFFFF0000000000000000FBFFFFFF0000000003000000FEFFFFFF020000000400000000000000030000000500000003000000050000000300000001000000FFFFFFFF05000000FFFFFFFF00000000FEFFFFFFFDFFFFFF01000000FDFFFFFFFEFFFFFFFFFFFFFF00000000FFFFFFFFFEFFFFFF0100000003000000020000000400000000000000000000000300000000000000030000000300000002000000FCFFFFFFFFFFFFFFFFFFFFFFFBFFFFFFFFFFFFFFFFFFFFFF0000000000000000FFFFFFFF0200000001000000FEFFFFFFFEFFFFFF020000000300000003000000FFFFFFFF03000000FDFFFFFF01000000FFFFFFFF0000000001000000FEFFFFFFFDFFFFFFFFFFFFFF01000000"> : tensor<1x125xi32>
    %1 = stablehlo.constant dense<3> : tensor<1xi32>
    return %0, %1 : tensor<1x125xi32>, tensor<1xi32>
  }
  func.func private @expected() -> tensor<1x125xi32> {
    %0 = stablehlo.constant dense<"0x0300000000000000FEFFFFFFFEFFFFFFFBFFFFFF0100000000000000FDFFFFFF00000000FEFFFFFF03000000FFFFFFFFFDFFFFFFFFFFFFFF020000000200000000000000000000000300000001000000FCFFFFFFFCFFFFFF0400000000000000FFFFFFFFFFFFFFFF02000000FDFFFFFF01000000FEFFFFFF00000000FBFFFFFFFEFFFFFFFFFFFFFFFFFFFFFF050000000000000000000000FFFFFFFF0300000000000000FEFFFFFF00000000FDFFFFFF000000000200000005000000FEFFFFFF0400000002000000000000000200000000000000FDFFFFFF000000000200000001000000F8FFFFFFFFFFFFFF0000000000000000FBFFFFFF0000000003000000FEFFFFFF020000000400000000000000030000000500000003000000050000000300000001000000FFFFFFFF05000000FFFFFFFF00000000FEFFFFFFFDFFFFFF01000000FDFFFFFFFEFFFFFFFFFFFFFF00000000FFFFFFFFFEFFFFFF0100000003000000020000000400000000000000000000000300000000000000030000000300000002000000FCFFFFFFFFFFFFFFFFFFFFFFFBFFFFFFFFFFFFFFFFFFFFFF0000000000000000FFFFFFFF0200000001000000FEFFFFFFFEFFFFFF020000000300000003000000FFFFFFFF03000000FDFFFFFF01000000FFFFFFFF0000000001000000FEFFFFFFFDFFFFFFFFFFFFFF01000000"> : tensor<1x125xi32>
    return %0 : tensor<1x125xi32>
  }
}

