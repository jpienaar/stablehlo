// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<32> : tensor<1xi32>
    %1:2 = call @inputs() : () -> (tensor<1x50x3xf32>, tensor<1x3xf32>)
    %2 = call @expected() : () -> tensor<1x50x3xf32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f32>, %arg1: tensor<f32>):
      %5 = stablehlo.minimum %arg0, %arg1 : tensor<f32>
      stablehlo.return %5 : tensor<f32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1]>, unique_indices = true} : (tensor<1x50x3xf32>, tensor<1xi32>, tensor<1x3xf32>) -> tensor<1x50x3xf32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<1x50x3xf32>, tensor<1x50x3xf32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1x50x3xf32>, tensor<1x3xf32>) {
    %0 = stablehlo.constant dense<"0x7C0C373FB31B09C06D5DE7BF7768593F7EBDD3BF61A0C83E7A69ECBFA62B93C06DC26BBFD6120DC0B24FBBBFEBA6BE3F10FEB7C0BCBC8FC09FEC34BF817195BEE7AA503FB5AD05C0BA031AC0D00894BF2FD8A0BE5772CF3F602BF7BF434C12C016BD66C0BF17C4401F9AAEC041250FBFA36E82BF72C13FC0CF24D63FB79CA43F3EE850C0C21554BE7EB2773F56BE3ABFCCCDC3BE6EE828C06EAE1FC0FDE393407FC111C0897D2540FD1FB9BFE023C9BF9D0F91C0F8CD093F386EA240FB835FC0FAA719C06932D33FE730D93EB0BA7A40B5574D40D6928B4085079040B8A49EBFBD4EA2C067EAB8BF08E854BF9A7711BF3E9C5B406C963D406E9E9ABF1136D23FE7390D3F28B0453FB62C2C3E556E26BF85128D3BA3A90A407B6EC43FC7502EBF201B00BEC8781EBFAF221540F1DD7240A7D75CC025B783BE8CB3063F0F1243BF1929B43FFFD7CF3CB39A61405460E8C0079239BF68F3BCC0B5A528BFC2E7A8BFC5CDB7C067122EC0AED4E63FBEB82CC0CCB5AD3E04D851BFA05BC03ED62F3EC0368093BF61B210402CED8CBE3FEA1C4086E24EBFA612C8BFFA12B1BFD12E64C04AEA4D3E93F093C0C73326C007FDA6406E3566C0C32F8EC0E9133F40FE3B9E3FFF81CAC038383340ABB0B14097C0433FEE74E53F2F0664BFAE4438C02494BEBFE12FEE3FB233B34006EA33405779D9BE6C3A5A40E3208E40F52E603FE6D9C03FB64712C0D53CA4C00CE8D3BDAF6AA1C0DDFC903F630D694083BAC03F52B38A40915A18405F9D02C090F90641931776C0E288D13E8549E2BF1B7E3FC0EC6C913FE519DC400B20B1400ACB1CC01A2E043F5D438FC00BCBA03F"> : tensor<1x50x3xf32>
    %1 = stablehlo.constant dense<[[1.63640583, 3.68580055, -3.94174528]]> : tensor<1x3xf32>
    return %0, %1 : tensor<1x50x3xf32>, tensor<1x3xf32>
  }
  func.func private @expected() -> tensor<1x50x3xf32> {
    %0 = stablehlo.constant dense<"0x7C0C373FB31B09C06D5DE7BF7768593F7EBDD3BF61A0C83E7A69ECBFA62B93C06DC26BBFD6120DC0B24FBBBFEBA6BE3F10FEB7C0BCBC8FC09FEC34BF817195BEE7AA503FB5AD05C0BA031AC0D00894BF2FD8A0BE5772CF3F602BF7BF434C12C016BD66C0BF17C4401F9AAEC041250FBFA36E82BF72C13FC0CF24D63FB79CA43F3EE850C0C21554BE7EB2773F56BE3ABFCCCDC3BE6EE828C06EAE1FC0FDE393407FC111C0897D2540FD1FB9BFE023C9BF9D0F91C0F8CD093F386EA240FB835FC0FAA719C06932D33FE730D93EB0BA7A40B5574D40D6928B4085079040B8A49EBFBD4EA2C067EAB8BF08E854BF9A7711BF3E9C5B406C963D406E9E9ABF1136D23FE7390D3F28B0453FB62C2C3E556E26BF85128D3BA3A90A407B6EC43FC7502EBF201B00BEC8781EBFAF221540F1DD7240A7D75CC025B783BE8CB3063F0F1243BF1929B43FFFD7CF3CB39A61405460E8C0079239BF68F3BCC0B5A528BFC2E7A8BFC5CDB7C067122EC0AED4E63FBEB82CC0CCB5AD3E04D851BFA05BC03ED62F3EC0368093BF61B210408E457CC03FEA1C4086E24EBFA612C8BFFA12B1BFD12E64C04AEA4D3E93F093C0C73326C007FDA6406E3566C0C32F8EC0E9133F40FE3B9E3FFF81CAC038383340ABB0B14097C0433FEE74E53F2F0664BFAE4438C02494BEBFE12FEE3FB233B34006EA33405779D9BE6C3A5A40E3208E40F52E603FE6D9C03FB64712C0D53CA4C00CE8D3BDAF6AA1C0DDFC903F630D694083BAC03F52B38A40915A18405F9D02C090F90641931776C0E288D13E8549E2BF1B7E3FC0EC6C913FE519DC400B20B1400ACB1CC01A2E043F5D438FC00BCBA03F"> : tensor<1x50x3xf32>
    return %0 : tensor<1x50x3xf32>
  }
}

