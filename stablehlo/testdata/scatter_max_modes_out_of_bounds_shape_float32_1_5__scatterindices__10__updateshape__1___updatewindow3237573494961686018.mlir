// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<10> : tensor<1xi32>
    %1:2 = call @inputs() : () -> (tensor<1x5xf32>, tensor<1xf32>)
    %2 = call @expected() : () -> tensor<1x5xf32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f32>, %arg1: tensor<f32>):
      %5 = stablehlo.maximum %arg0, %arg1 : tensor<f32>
      stablehlo.return %5 : tensor<f32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1]>} : (tensor<1x5xf32>, tensor<1xi32>, tensor<1xf32>) -> tensor<1x5xf32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<1x5xf32>, tensor<1x5xf32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1x5xf32>, tensor<1xf32>) {
    %0 = stablehlo.constant dense<[[-0.198677436, -1.02581632, 0.632963955, -1.9831953, -2.71500278]]> : tensor<1x5xf32>
    %1 = stablehlo.constant dense<-7.6055522> : tensor<1xf32>
    return %0, %1 : tensor<1x5xf32>, tensor<1xf32>
  }
  func.func private @expected() -> tensor<1x5xf32> {
    %0 = stablehlo.constant dense<[[-0.198677436, -1.02581632, 0.632963955, -1.9831953, -2.71500278]]> : tensor<1x5xf32>
    return %0 : tensor<1x5xf32>
  }
}

