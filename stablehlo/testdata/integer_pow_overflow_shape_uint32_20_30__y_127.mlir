// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x30xui32>
    %1 = call @expected() : () -> tensor<20x30xui32>
    %2 = call @integer_pow(%0) : (tensor<20x30xui32>) -> tensor<20x30xui32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x30xui32>, tensor<20x30xui32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x30xui32> {
    %0 = stablehlo.constant dense<"0x000000000100000001000000020000000200000000000000000000000200000000000000020000000100000003000000060000000500000003000000040000000300000000000000050000000400000001000000010000000000000000000000020000000000000002000000020000000000000000000000030000000300000000000000030000000400000003000000000000000300000001000000000000000000000006000000030000000200000005000000030000000000000000000000000000000000000002000000030000000100000000000000000000000500000001000000000000000400000007000000040000000600000003000000040000000200000002000000000000000400000005000000040000000100000005000000000000000000000002000000020000000000000003000000030000000000000004000000000000000100000001000000030000000300000000000000000000000000000004000000020000000100000000000000040000000500000001000000010000000000000000000000040000000100000005000000010000000800000000000000000000000300000000000000010000000200000001000000010000000100000001000000070000000100000003000000010000000100000000000000020000000200000004000000040000000400000001000000000000000300000003000000040000000000000000000000020000000300000001000000010000000100000001000000020000000300000000000000000000000100000000000000010000000000000001000000040000000200000000000000010000000100000000000000030000000200000005000000000000000300000000000000030000000500000001000000030000000600000000000000010000000000000000000000000000000300000003000000030000000200000003000000050000000500000000000000050000000000000001000000010000000100000000000000040000000200000001000000020000000000000001000000010000000100000000000000000000000000000003000000000000000200000001000000000000000700000004000000020000000000000000000000010000000100000003000000000000000000000003000000070000000000000002000000010000000300000000000000010000000200000001000000030000000300000005000000030000000200000000000000020000000100000007000000000000000100000001000000000000000100000000000000000000000400000002000000040000000000000002000000030000000300000002000000020000000200000003000000020000000100000001000000040000000400000000000000000000000300000000000000000000000100000001000000030000000000000001000000030000000000000000000000010000000000000000000000020000000300000001000000050000000000000003000000070000000200000000000000010000000100000003000000000000000500000001000000010000000600000000000000010000000300000003000000030000000100000002000000010000000500000000000000050000000400000003000000010000000200000000000000010000000200000000000000020000000300000002000000040000000400000002000000020000000100000001000000000000000200000002000000000000000000000000000000020000000400000005000000010000000000000002000000000000000200000003000000000000000400000008000000030000000200000004000000030000000200000001000000010000000000000002000000000000000200000005000000020000000000000003000000030000000300000004000000010000000100000001000000000000000000000009000000030000000000000001000000010000000300000000000000000000000200000006000000030000000300000002000000020000000600000003000000000000000100000001000000010000000300000004000000010000000100000000000000010000000300000000000000050000000000000002000000020000000500000001000000070000000200000003000000070000000100000003000000010000000200000001000000000000000200000001000000020000000000000000000000010000000600000000000000020000000000000003000000040000000100000000000000020000000000000001000000050000000200000003000000000000000600000002000000050000000100000000000000070000000000000001000000030000000600000006000000020000000100000001000000090000000000000001000000000000000700000002000000040000000200000002000000050000000000000004000000030000000300000005000000000000000200000001000000010000000000000001000000060000000000000004000000030000000500000001000000030000000100000002000000000000000000000006000000000000000000000002000000000000000400000001000000020000000100000003000000010000000500000002000000020000000000000003000000010000000300000004000000020000000000000003000000040000000400000001000000010000000100000004000000040000000100000002000000010000000000000000000000030000000100000000000000060000000100000000000000030000000200000000000000030000000300000000000000030000000000000003000000010000000100000002000000010000000000000001000000020000000000000003000000010000000000000001000000000000000500000004000000010000000000000003000000000000000200000000000000000000000000000003000000010000000100000000000000030000000300000003000000040000000400000002000000000000000100000001000000020000000000000000000000030000000200000000000000060000000300000005000000050000000000000002000000020000000200000000000000060000000000000001000000060000000300000000000000050000000100000001000000020000000100000002000000010000000200000000000000000000000500000001000000000000000100000001000000030000000400000007000000010000000200000001000000000000000100000004000000020000000100000002000000030000000100000002000000"> : tensor<20x30xui32>
    return %0 : tensor<20x30xui32>
  }
  func.func private @expected() -> tensor<20x30xui32> {
    %0 = stablehlo.constant dense<"0x0000000001000000010000000000000000000000000000000000000000000000000000000000000001000000AB28828300000000CD72B76FAB28828300000000AB28828300000000CD72B76F0000000001000000010000000000000000000000000000000000000000000000000000000000000000000000AB288283AB28828300000000AB28828300000000AB28828300000000AB28828301000000000000000000000000000000AB28828300000000CD72B76FAB2882830000000000000000000000000000000000000000AB288283010000000000000000000000CD72B76F010000000000000000000000B721D6BA0000000000000000AB2882830000000000000000000000000000000000000000CD72B76F0000000001000000CD72B76F0000000000000000000000000000000000000000AB288283AB2882830000000000000000000000000100000001000000AB288283AB2882830000000000000000000000000000000000000000010000000000000000000000CD72B76F010000000100000000000000000000000000000001000000CD72B76F01000000000000000000000000000000AB28828300000000010000000000000001000000010000000100000001000000B721D6BA01000000AB28828301000000010000000000000000000000000000000000000000000000000000000100000000000000AB288283AB28828300000000000000000000000000000000AB2882830100000001000000010000000100000000000000AB28828300000000000000000100000000000000010000000000000001000000000000000000000000000000010000000100000000000000AB28828300000000CD72B76F00000000AB28828300000000AB288283CD72B76F01000000AB288283000000000000000001000000000000000000000000000000AB288283AB288283AB28828300000000AB288283CD72B76FCD72B76F00000000CD72B76F00000000010000000100000001000000000000000000000000000000010000000000000000000000010000000100000001000000000000000000000000000000AB28828300000000000000000100000000000000B721D6BA000000000000000000000000000000000100000001000000AB2882830000000000000000AB288283B721D6BA000000000000000001000000AB28828300000000010000000000000001000000AB288283AB288283CD72B76FAB28828300000000000000000000000001000000B721D6BA000000000100000001000000000000000100000000000000000000000000000000000000000000000000000000000000AB288283AB288283000000000000000000000000AB28828300000000010000000100000000000000000000000000000000000000AB28828300000000000000000100000001000000AB2882830000000001000000AB288283000000000000000001000000000000000000000000000000AB28828301000000CD72B76F00000000AB288283B721D6BA00000000000000000100000001000000AB28828300000000CD72B76F0100000001000000000000000000000001000000AB288283AB288283AB288283010000000000000001000000CD72B76F00000000CD72B76F00000000AB28828301000000000000000000000001000000000000000000000000000000AB288283000000000000000000000000000000000000000001000000010000000000000000000000000000000000000000000000000000000000000000000000CD72B76F0100000000000000000000000000000000000000AB288283000000000000000000000000AB2882830000000000000000AB28828300000000010000000100000000000000000000000000000000000000CD72B76F0000000000000000AB288283AB288283AB28828300000000010000000100000001000000000000000000000039E22156AB288283000000000100000001000000AB28828300000000000000000000000000000000AB288283AB288283000000000000000000000000AB28828300000000010000000100000001000000AB2882830000000001000000010000000000000001000000AB28828300000000CD72B76F000000000000000000000000CD72B76F01000000B721D6BA00000000AB288283B721D6BA01000000AB2882830100000000000000010000000000000000000000010000000000000000000000000000000100000000000000000000000000000000000000AB288283000000000100000000000000000000000000000001000000CD72B76F00000000AB288283000000000000000000000000CD72B76F0100000000000000B721D6BA0000000001000000AB288283000000000000000000000000010000000100000039E22156000000000100000000000000B721D6BA00000000000000000000000000000000CD72B76F0000000000000000AB288283AB288283CD72B76F000000000000000001000000010000000000000001000000000000000000000000000000AB288283CD72B76F01000000AB28828301000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000001000000AB28828301000000CD72B76F000000000000000000000000AB28828301000000AB288283000000000000000000000000AB288283000000000000000001000000010000000100000000000000000000000100000000000000010000000000000000000000AB2882830100000000000000000000000100000000000000AB2882830000000000000000AB288283AB28828300000000AB28828300000000AB2882830100000001000000000000000100000000000000010000000000000000000000AB28828301000000000000000100000000000000CD72B76F000000000100000000000000AB2882830000000000000000000000000000000000000000AB288283010000000100000000000000AB288283AB288283AB288283000000000000000000000000000000000100000001000000000000000000000000000000AB288283000000000000000000000000AB288283CD72B76FCD72B76F000000000000000000000000000000000000000000000000000000000100000000000000AB28828300000000CD72B76F010000000100000000000000010000000000000001000000000000000000000000000000CD72B76F01000000000000000100000001000000AB28828300000000B721D6BA010000000000000001000000000000000100000000000000000000000100000000000000AB2882830100000000000000"> : tensor<20x30xui32>
    return %0 : tensor<20x30xui32>
  }
  func.func private @integer_pow(%arg0: tensor<20x30xui32>) -> tensor<20x30xui32> {
    %0 = stablehlo.multiply %arg0, %arg0 : tensor<20x30xui32>
    %1 = stablehlo.multiply %arg0, %0 : tensor<20x30xui32>
    %2 = stablehlo.multiply %0, %0 : tensor<20x30xui32>
    %3 = stablehlo.multiply %1, %2 : tensor<20x30xui32>
    %4 = stablehlo.multiply %2, %2 : tensor<20x30xui32>
    %5 = stablehlo.multiply %3, %4 : tensor<20x30xui32>
    %6 = stablehlo.multiply %4, %4 : tensor<20x30xui32>
    %7 = stablehlo.multiply %5, %6 : tensor<20x30xui32>
    %8 = stablehlo.multiply %6, %6 : tensor<20x30xui32>
    %9 = stablehlo.multiply %7, %8 : tensor<20x30xui32>
    %10 = stablehlo.multiply %8, %8 : tensor<20x30xui32>
    %11 = stablehlo.multiply %9, %10 : tensor<20x30xui32>
    return %11 : tensor<20x30xui32>
  }
}
