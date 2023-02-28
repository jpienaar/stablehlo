// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[1, 2]> : tensor<2xi32>
    %1:2 = call @inputs() : () -> (tensor<1x2x3xf32>, tensor<1xf32>)
    %2 = call @expected() : () -> tensor<1x2x3xf32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f32>, %arg1: tensor<f32>):
      %5 = stablehlo.add %arg0, %arg1 : tensor<f32>
      stablehlo.return %5 : tensor<f32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1, 2], scatter_dims_to_operand_dims = [1, 2]>, unique_indices = true} : (tensor<1x2x3xf32>, tensor<2xi32>, tensor<1xf32>) -> tensor<1x2x3xf32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<1x2x3xf32>, tensor<1x2x3xf32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1x2x3xf32>, tensor<1xf32>) {
    %0 = stablehlo.constant dense<[[[-6.6639595, 6.77831697, 3.89070392], [-4.3090229, -2.11022854, -0.190506324]]]> : tensor<1x2x3xf32>
    %1 = stablehlo.constant dense<-2.56569052> : tensor<1xf32>
    return %0, %1 : tensor<1x2x3xf32>, tensor<1xf32>
  }
  func.func private @expected() -> tensor<1x2x3xf32> {
    %0 = stablehlo.constant dense<[[[-6.6639595, 6.77831697, 3.89070392], [-4.3090229, -2.11022854, -2.75619674]]]> : tensor<1x2x3xf32>
    return %0 : tensor<1x2x3xf32>
  }
}

