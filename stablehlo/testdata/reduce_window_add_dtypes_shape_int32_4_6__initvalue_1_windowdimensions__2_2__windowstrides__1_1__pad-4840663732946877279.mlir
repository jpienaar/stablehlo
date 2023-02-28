// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<4x6xi32>
    %1 = call @expected() : () -> tensor<3x5xi32>
    %2 = stablehlo.constant dense<1> : tensor<i32>
    %3 = "stablehlo.reduce_window"(%0, %2) ({
    ^bb0(%arg0: tensor<i32>, %arg1: tensor<i32>):
      %5 = stablehlo.add %arg0, %arg1 : tensor<i32>
      stablehlo.return %5 : tensor<i32>
    }) {window_dimensions = dense<2> : tensor<2xi64>} : (tensor<4x6xi32>, tensor<i32>) -> tensor<3x5xi32>
    %4 = stablehlo.custom_call @check.eq(%3, %1) : (tensor<3x5xi32>, tensor<3x5xi32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> tensor<4x6xi32> {
    %0 = stablehlo.constant dense<[[4, 4, 0, 1, -1, -1], [-2, 1, 0, 0, 3, -6], [2, -4, -4, -2, -2, 0], [-4, -3, 2, 4, -3, 0]]> : tensor<4x6xi32>
    return %0 : tensor<4x6xi32>
  }
  func.func private @expected() -> tensor<3x5xi32> {
    %0 = stablehlo.constant dense<[[8, 6, 2, 4, -4], [-2, -6, -5, 0, -4], [-8, -8, 1, -2, -4]]> : tensor<3x5xi32>
    return %0 : tensor<3x5xi32>
  }
}

