// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<3x4x5xf32>
    %1 = call @expected() : () -> tensor<3x4x5xf32>
    %2 = stablehlo.reverse %0, dims = [] : tensor<3x4x5xf32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<3x4x5xf32>, tensor<3x4x5xf32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<3x4x5xf32> {
    %0 = stablehlo.constant dense<[[[-0.464423895, -1.50158894, -2.0344243, -1.41180933, -2.90842533], [0.823336541, 3.45140028, 3.69739723, -1.89843452, -1.68810058], [3.40111327, 1.05722153, 2.11909556, -0.850937306, 5.09096432], [-1.23388743, 3.58495235, -0.120762065, 2.2584517, 0.494466394]], [[4.47528076, 0.917005598, 1.54741216, -6.545910e+00, 2.31888652], [-2.10922027, -4.11765957, -5.467250e-01, 1.67117274, 4.70610762], [-0.055694636, 1.16180658, -8.108325, 5.54486752, -4.16301775], [-0.85471028, 0.89209491, 4.35790396, 8.51306534, 0.492473841]], [[0.271108121, 6.0962081, -1.66858292, 2.68769217, 2.20100784], [-5.08213377, 1.03311872, 2.17707014, -3.29460859, -1.56388259], [-1.33692706, 2.77195072, 0.144049063, 5.18237638, 5.3109436], [1.95865726, 6.17927361, 1.1321938, 1.05025399, 1.04188859]]]> : tensor<3x4x5xf32>
    return %0 : tensor<3x4x5xf32>
  }
  func.func private @expected() -> tensor<3x4x5xf32> {
    %0 = stablehlo.constant dense<[[[-0.464423895, -1.50158894, -2.0344243, -1.41180933, -2.90842533], [0.823336541, 3.45140028, 3.69739723, -1.89843452, -1.68810058], [3.40111327, 1.05722153, 2.11909556, -0.850937306, 5.09096432], [-1.23388743, 3.58495235, -0.120762065, 2.2584517, 0.494466394]], [[4.47528076, 0.917005598, 1.54741216, -6.545910e+00, 2.31888652], [-2.10922027, -4.11765957, -5.467250e-01, 1.67117274, 4.70610762], [-0.055694636, 1.16180658, -8.108325, 5.54486752, -4.16301775], [-0.85471028, 0.89209491, 4.35790396, 8.51306534, 0.492473841]], [[0.271108121, 6.0962081, -1.66858292, 2.68769217, 2.20100784], [-5.08213377, 1.03311872, 2.17707014, -3.29460859, -1.56388259], [-1.33692706, 2.77195072, 0.144049063, 5.18237638, 5.3109436], [1.95865726, 6.17927361, 1.1321938, 1.05025399, 1.04188859]]]> : tensor<3x4x5xf32>
    return %0 : tensor<3x4x5xf32>
  }
}
