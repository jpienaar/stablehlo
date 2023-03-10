// RUN-DISABLED: stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[1], [0], [1]]> : tensor<3x1xi32>
    %1:2 = call @inputs() : () -> (tensor<3xbf16>, tensor<3xbf16>)
    %2 = call @expected() : () -> tensor<3xbf16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<bf16>, %arg1: tensor<bf16>):
      %5 = stablehlo.multiply %arg0, %arg1 : tensor<bf16>
      stablehlo.return %5 : tensor<bf16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<inserted_window_dims = [0], scatter_dims_to_operand_dims = [0], index_vector_dim = 1>} : (tensor<3xbf16>, tensor<3x1xi32>, tensor<3xbf16>) -> tensor<3xbf16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<3xbf16>, tensor<3xbf16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<3xbf16>, tensor<3xbf16>) {
    %0 = stablehlo.constant dense<[2.402340e-01, 2.625000e+00, -2.000000e+00]> : tensor<3xbf16>
    %1 = stablehlo.constant dense<[-5.750000e+00, 6.562500e+00, -7.460930e-01]> : tensor<3xbf16>
    return %0, %1 : tensor<3xbf16>, tensor<3xbf16>
  }
  func.func private @expected() -> tensor<3xbf16> {
    %0 = stablehlo.constant dense<[1.578130e+00, 1.131250e+01, -2.000000e+00]> : tensor<3xbf16>
    return %0 : tensor<3xbf16>
  }
}
