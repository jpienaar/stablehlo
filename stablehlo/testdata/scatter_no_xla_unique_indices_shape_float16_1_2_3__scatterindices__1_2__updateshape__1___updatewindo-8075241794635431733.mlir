// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[1, 2]> : tensor<2xi32>
    %1:2 = call @inputs() : () -> (tensor<1x2x3xf16>, tensor<1xf16>)
    %2 = call @expected() : () -> tensor<1x2x3xf16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f16>, %arg1: tensor<f16>):
      stablehlo.return %arg1 : tensor<f16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1, 2], scatter_dims_to_operand_dims = [1, 2]>, unique_indices = true} : (tensor<1x2x3xf16>, tensor<2xi32>, tensor<1xf16>) -> tensor<1x2x3xf16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<1x2x3xf16>, tensor<1x2x3xf16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1x2x3xf16>, tensor<1xf16>) {
    %0 = stablehlo.constant dense<[[[-9.487300e-01, -2.490230e+00, 5.773440e+00], [4.257810e+00, 6.762700e-02, 5.151370e-01]]]> : tensor<1x2x3xf16>
    %1 = stablehlo.constant dense<-1.350590e+00> : tensor<1xf16>
    return %0, %1 : tensor<1x2x3xf16>, tensor<1xf16>
  }
  func.func private @expected() -> tensor<1x2x3xf16> {
    %0 = stablehlo.constant dense<[[[-9.487300e-01, -2.490230e+00, 5.773440e+00], [4.257810e+00, 6.762700e-02, -1.350590e+00]]]> : tensor<1x2x3xf16>
    return %0 : tensor<1x2x3xf16>
  }
}

