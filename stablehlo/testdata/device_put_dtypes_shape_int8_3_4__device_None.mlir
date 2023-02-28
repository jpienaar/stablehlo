// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<3x4xi8>
    %1 = call @expected() : () -> tensor<3x4xi8>
    %2 = stablehlo.custom_call @check.eq(%0, %1) : (tensor<3x4xi8>, tensor<3x4xi8>) -> tensor<i1>
    return %2 : tensor<i1>
  }
  func.func private @inputs() -> tensor<3x4xi8> {
    %0 = stablehlo.constant dense<[[2, -2, 0, -3], [0, 1, -1, 2], [-3, 0, 8, -4]]> : tensor<3x4xi8>
    return %0 : tensor<3x4xi8>
  }
  func.func private @expected() -> tensor<3x4xi8> {
    %0 = stablehlo.constant dense<[[2, -2, 0, -3], [0, 1, -1, 2], [-3, 0, 8, -4]]> : tensor<3x4xi8>
    return %0 : tensor<3x4xi8>
  }
}
