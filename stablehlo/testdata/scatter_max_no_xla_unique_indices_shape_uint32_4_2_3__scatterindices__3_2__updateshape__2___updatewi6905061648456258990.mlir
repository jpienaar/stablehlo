// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[3, 2]> : tensor<2xi32>
    %1:2 = call @inputs() : () -> (tensor<4x2x3xui32>, tensor<2xui32>)
    %2 = call @expected() : () -> tensor<4x2x3xui32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<ui32>, %arg1: tensor<ui32>):
      %5 = stablehlo.maximum %arg0, %arg1 : tensor<ui32>
      stablehlo.return %5 : tensor<ui32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [0, 2], scatter_dims_to_operand_dims = [0, 2]>, unique_indices = true} : (tensor<4x2x3xui32>, tensor<2xi32>, tensor<2xui32>) -> tensor<4x2x3xui32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<4x2x3xui32>, tensor<4x2x3xui32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<4x2x3xui32>, tensor<2xui32>) {
    %0 = stablehlo.constant dense<[[[7, 0, 0], [4, 2, 1]], [[3, 1, 1], [0, 3, 0]], [[1, 3, 0], [5, 4, 0]], [[4, 0, 2], [1, 0, 1]]]> : tensor<4x2x3xui32>
    %1 = stablehlo.constant dense<[1, 4]> : tensor<2xui32>
    return %0, %1 : tensor<4x2x3xui32>, tensor<2xui32>
  }
  func.func private @expected() -> tensor<4x2x3xui32> {
    %0 = stablehlo.constant dense<[[[7, 0, 0], [4, 2, 1]], [[3, 1, 1], [0, 3, 0]], [[1, 3, 0], [5, 4, 0]], [[4, 0, 2], [1, 0, 4]]]> : tensor<4x2x3xui32>
    return %0 : tensor<4x2x3xui32>
  }
}

