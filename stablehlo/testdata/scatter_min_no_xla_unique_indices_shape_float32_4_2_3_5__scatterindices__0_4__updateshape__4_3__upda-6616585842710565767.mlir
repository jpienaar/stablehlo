// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[0, 4]> : tensor<2xi32>
    %1:2 = call @inputs() : () -> (tensor<4x2x3x5xf32>, tensor<4x3xf32>)
    %2 = call @expected() : () -> tensor<4x2x3x5xf32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f32>, %arg1: tensor<f32>):
      %5 = stablehlo.minimum %arg0, %arg1 : tensor<f32>
      stablehlo.return %5 : tensor<f32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [1, 3], scatter_dims_to_operand_dims = [1, 3]>, unique_indices = true} : (tensor<4x2x3x5xf32>, tensor<2xi32>, tensor<4x3xf32>) -> tensor<4x2x3x5xf32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<4x2x3x5xf32>, tensor<4x2x3x5xf32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<4x2x3x5xf32>, tensor<4x3xf32>) {
    %0 = stablehlo.constant dense<"0xC4B47ABF74E505C0C1760B40BFB922C0CFDD7FC0CD03E73E85F456BE56F077C06A106A40F193E4BFC2F93A3F9B4C0DC0D57A8ABDF30807403FAE484091AF9A3EF053794095614A3F3AF9854061A24C40D59CE7BFC23A923E64B0DDBE7D1F8440F43445C03E8C21BF611D35BEC525913F3CDC54BF7672A440ED28B9C0C88E3D40EF17F2BFB3229D40D105493E014CA5BFD731C9403E3190BF3ED050C0461D5F3F6C61A4BF44104C402F8758C03CFC74C03BA70240A5EF063F6C4F8C3F4741803F7C9A45C0FA973DBF9453AF3E7FD95E40594872BFD8E8C0C045919F4081F94EC0E912B3BF340C11402ABC28403C6FC8BD7893884053AD0DC08F5E95BE829B7740A24AB23F59F9B73F4E5179BFA4AD22401D49E1BF29E5603F42C75FC05590C2C0CEC5B44048C885BF18D5084083F6A0406F2293BFE71C763F05D7D3BF350608412F294BC02FD43D40991613C07C658140683080BFA8EF0F3E75388EC0693E76405C773AC0821D0DBF4CFFFF3F9624563FD58E90C0412C14BF67B3EE3FBABAC8C06DF86940B20EAC3F8C71F73F8425EF3F4BEC783F70F345407DBFEB3F3F6AED4046DB3F3F926745C0592DF2BFCC83314073AFF140572635C00861F6BE58E916BFF4AC3EC005E76540AE06333F45564A3FE63F87C039CCC83FC0E2ABBFDC3139C0"> : tensor<4x2x3x5xf32>
    %1 = stablehlo.constant dense<[[-0.316763908, 1.81231821, 0.358443171], [-1.65285075, 0.899360537, 3.13519478], [-1.60189772, -2.31099534, -0.73344624], [1.27145743, 1.88954532, 3.51110101]]> : tensor<4x3xf32>
    return %0, %1 : tensor<4x2x3x5xf32>, tensor<4x3xf32>
  }
  func.func private @expected() -> tensor<4x2x3x5xf32> {
    %0 = stablehlo.constant dense<"0xC4B47ABF74E505C0C1760B40BFB922C0CFDD7FC0CD03E73E85F456BE56F077C06A106A40F193E4BFC2F93A3F9B4C0DC0D57A8ABDF3080740DD85B73E91AF9A3EF053794095614A3F3AF9854061A24C40D59CE7BFC23A923E64B0DDBE7D1F8440F43445C03E8C21BF611D35BEC525913F3CDC54BF7672A440ED28B9C0C88E3D40EF17F2BFB3229D409D90D3BF014CA5BFD731C9403E3190BF3ED050C0461D5F3F6C61A4BF44104C402F8758C03CFC74C03BA70240A5EF063F6C4F8C3F4741803F7C9A45C0FA973DBF9453AF3E7FD95E40594872BFD8E8C0C045919F4081F94EC0E912B3BF340C11402ABC28403C6FC8BD7893884053AD0DC08F5E95BE829B7740FC0ACDBF59F9B73F4E5179BFA4AD22401D49E1BF59E713C042C75FC05590C2C0CEC5B44048C885BF22C33BBF83F6A0406F2293BFE71C763F05D7D3BF350608412F294BC02FD43D40991613C07C658140683080BFA8EF0F3E75388EC0693E76405C773AC0821D0DBF4CFFFF3F9624563FD58E90C0412C14BF1EBFA23FBABAC8C06DF86940B20EAC3F8C71F73F8425EF3F4BEC783F70F345407DBFEB3F3F6AED4046DB3F3F926745C0592DF2BFCC83314073AFF140572635C00861F6BE58E916BFF4AC3EC005E76540AE06333F45564A3FE63F87C039CCC83FC0E2ABBFDC3139C0"> : tensor<4x2x3x5xf32>
    return %0 : tensor<4x2x3x5xf32>
  }
}

