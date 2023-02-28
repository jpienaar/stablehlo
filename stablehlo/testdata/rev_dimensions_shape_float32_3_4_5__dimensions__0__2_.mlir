// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<3x4x5xf32>
    %1 = call @expected() : () -> tensor<3x4x5xf32>
    %2 = stablehlo.reverse %0, dims = [0, 2] : tensor<3x4x5xf32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<3x4x5xf32>, tensor<3x4x5xf32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<3x4x5xf32> {
    %0 = stablehlo.constant dense<[[[-1.98385429, -2.30945373, 1.51759779, -0.285959214, 2.47747445], [0.272397488, -3.93382144, -1.74110687, -2.28210092, -1.16285217], [-0.794024169, 6.73959827, 5.71728086, 9.38643741, -1.17788923], [3.13179207, 1.20094347, 2.41477132, -2.78201818, 2.3772893]], [[3.06073213, -2.7227149, 0.123076648, -4.37336493, -6.92281866], [-5.54955769, -4.16841936, -3.15850592, -3.69914746, 0.840284943], [2.41977453, -3.59469795, -3.00077724, 0.41007033, 7.05760241], [1.72370541, -2.81880975, -1.63942921, -0.33505857, 0.445375204]], [[-2.49106288, 6.38465643, -2.12248063, 2.30540729, 3.12124443], [-1.88724816, 3.67404461, 2.30696249, -0.936812341, -2.2690382], [-4.78598976, -0.919804751, -0.780682444, 5.88345575, -2.79272985], [3.88456535, 3.04881573, 0.686845183, -2.81020141, 4.195130e+00]]]> : tensor<3x4x5xf32>
    return %0 : tensor<3x4x5xf32>
  }
  func.func private @expected() -> tensor<3x4x5xf32> {
    %0 = stablehlo.constant dense<[[[3.12124443, 2.30540729, -2.12248063, 6.38465643, -2.49106288], [-2.2690382, -0.936812341, 2.30696249, 3.67404461, -1.88724816], [-2.79272985, 5.88345575, -0.780682444, -0.919804751, -4.78598976], [4.195130e+00, -2.81020141, 0.686845183, 3.04881573, 3.88456535]], [[-6.92281866, -4.37336493, 0.123076648, -2.7227149, 3.06073213], [0.840284943, -3.69914746, -3.15850592, -4.16841936, -5.54955769], [7.05760241, 0.41007033, -3.00077724, -3.59469795, 2.41977453], [0.445375204, -0.33505857, -1.63942921, -2.81880975, 1.72370541]], [[2.47747445, -0.285959214, 1.51759779, -2.30945373, -1.98385429], [-1.16285217, -2.28210092, -1.74110687, -3.93382144, 0.272397488], [-1.17788923, 9.38643741, 5.71728086, 6.73959827, -0.794024169], [2.3772893, -2.78201818, 2.41477132, 1.20094347, 3.13179207]]]> : tensor<3x4x5xf32>
    return %0 : tensor<3x4x5xf32>
  }
}
