// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<2xf32>, tensor<2xf32>)
    %1 = call @expected() : () -> tensor<2xf32>
    %2 = stablehlo.divide %0#0, %0#1 : tensor<2xf32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<2xf32>, tensor<2xf32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<2xf32>, tensor<2xf32>) {
    %0 = stablehlo.constant dense<0.000000e+00> : tensor<2xf32>
    %1 = stablehlo.constant dense<0.000000e+00> : tensor<2xf32>
    return %0, %1 : tensor<2xf32>, tensor<2xf32>
  }
  func.func private @expected() -> tensor<2xf32> {
    %0 = stablehlo.constant dense<0xFFC00000> : tensor<2xf32>
    return %0 : tensor<2xf32>
  }
}
