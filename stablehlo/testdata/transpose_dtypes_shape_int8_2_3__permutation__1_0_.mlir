// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<2x3xi8>
    %1 = call @expected() : () -> tensor<3x2xi8>
    %2 = stablehlo.transpose %0, dims = [1, 0] : (tensor<2x3xi8>) -> tensor<3x2xi8>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<3x2xi8>, tensor<3x2xi8>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<2x3xi8> {
    %0 = stablehlo.constant dense<[[-1, -1, 0], [-2, -4, -3]]> : tensor<2x3xi8>
    return %0 : tensor<2x3xi8>
  }
  func.func private @expected() -> tensor<3x2xi8> {
    %0 = stablehlo.constant dense<[[-1, -2], [-1, -4], [0, -3]]> : tensor<3x2xi8>
    return %0 : tensor<3x2xi8>
  }
}
