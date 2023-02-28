// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<2x3xui32>, tensor<ui32>)
    %1 = call @expected() : () -> tensor<4x7xui32>
    %2 = stablehlo.pad %0#0, %0#1, low = [1, 2], high = [1, 2], interior = [0, 0] : (tensor<2x3xui32>, tensor<ui32>) -> tensor<4x7xui32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<4x7xui32>, tensor<4x7xui32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<2x3xui32>, tensor<ui32>) {
    %0 = stablehlo.constant dense<0> : tensor<2x3xui32>
    %1 = stablehlo.constant dense<0> : tensor<ui32>
    return %0, %1 : tensor<2x3xui32>, tensor<ui32>
  }
  func.func private @expected() -> tensor<4x7xui32> {
    %0 = stablehlo.constant dense<0> : tensor<4x7xui32>
    return %0 : tensor<4x7xui32>
  }
}
