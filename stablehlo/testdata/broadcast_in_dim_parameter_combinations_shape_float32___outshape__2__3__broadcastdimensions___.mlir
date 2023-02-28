// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<f32>
    %1 = call @expected() : () -> tensor<2x3xf32>
    %2 = stablehlo.broadcast_in_dim %0, dims = [] : (tensor<f32>) -> tensor<2x3xf32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<2x3xf32>, tensor<2x3xf32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<f32> {
    %0 = stablehlo.constant dense<-1.65541482> : tensor<f32>
    return %0 : tensor<f32>
  }
  func.func private @expected() -> tensor<2x3xf32> {
    %0 = stablehlo.constant dense<-1.65541482> : tensor<2x3xf32>
    return %0 : tensor<2x3xf32>
  }
}
