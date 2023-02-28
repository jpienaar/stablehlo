// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<2xcomplex<f32>>
    %1 = call @expected() : () -> tensor<2xcomplex<f32>>
    %2 = stablehlo.custom_call @check.eq(%0, %1) : (tensor<2xcomplex<f32>>, tensor<2xcomplex<f32>>) -> tensor<i1>
    return %2 : tensor<i1>
  }
  func.func private @inputs() -> tensor<2xcomplex<f32>> {
    %0 = stablehlo.constant dense<[(-3.29600501,-0.649608493), (-0.940406262,0.171288654)]> : tensor<2xcomplex<f32>>
    return %0 : tensor<2xcomplex<f32>>
  }
  func.func private @expected() -> tensor<2xcomplex<f32>> {
    %0 = stablehlo.constant dense<[(-3.29600501,-0.649608493), (-0.940406262,0.171288654)]> : tensor<2xcomplex<f32>>
    return %0 : tensor<2xcomplex<f32>>
  }
}
