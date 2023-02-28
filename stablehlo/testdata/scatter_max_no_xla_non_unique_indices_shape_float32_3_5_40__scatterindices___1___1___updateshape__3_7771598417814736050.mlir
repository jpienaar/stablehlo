// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<1> : tensor<2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<3x5x40xf32>, tensor<3x5x2xf32>)
    %2 = call @expected() : () -> tensor<3x5x40xf32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f32>, %arg1: tensor<f32>):
      %5 = stablehlo.maximum %arg0, %arg1 : tensor<f32>
      stablehlo.return %5 : tensor<f32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [2], scatter_dims_to_operand_dims = [2], index_vector_dim = 1>} : (tensor<3x5x40xf32>, tensor<2x1xi32>, tensor<3x5x2xf32>) -> tensor<3x5x40xf32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<3x5x40xf32>, tensor<3x5x40xf32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<3x5x40xf32>, tensor<3x5x2xf32>) {
    %0 = stablehlo.constant dense<"0x30FE6E40041E9BBE7C15293F1E46A8C099F067BE569BB8BE0306DF3E862906BF81BEB2BFB5E3B940360B9BBF864E7FBFD53CB6BFDB7BB0C0346E28407701DDC0345BBE3FFCB1193FE38932401B299EBF85180840ED8EAE3FFAB832BF208692BF30AC0740B4064240049F6F40E2456B409AECD63FA404ABC079A32840F42AE8BEEF89D33FC912243FC6F1744047F4A53F4CB2823F35EB9BBFC3FFC53FD4D523BE596792BF32B5D43F5A98CDBE250E8FBE02FD87C0A3EEF53F78CA7EC0DEC317C05BED2FC08DC19EC07612BDBE64EB11407105AFBF6076A8BE591680BFD5E3D4BF03B41D3FF79F2F3FB31265BCA24499403A89A240FF29E1BF109BF4BD972FADC08BE48340AEA785C092A4F03FF1F34F4047572BBFEF56C63E65F0CB3FA3CCD13FE6C026405697D1BF58F80FBF3CB3263F2AFB0B3F79B2DFBEAAC61E3FEE0366407189DB3FB96C093DB3B9813E0E5F15BF5F5470C0512CB83F107AC7BE712C75C06841D440A77E4A40EBC10D40CC346FBF5CCDA3BF92E55A3E0F2E164037D1CBC052E203C1C81D7C408DED753F761294BF94F23F4025D8C7BF70C839C0643A86C02B30DFBEE09DF6BFD516D2BE190100C0438F853EB36744C0ED10CDBE61B307C06C632DC012D3BB403EE059BF1B4AA2BEB37EE43F434AFCBF6A1B08C0A6DF67403D6C94C01368144072937B40E091D13FCDE7AFBF28DE8FC0A12A35C00C872C3FD4B818C0E91E11BFC3A178BF95D01E402756F1C0B5BD10409834674057DC244073AE1DBF0242D03F48B0813FBC40B5C015FD5F403D8321C0C9B1B1C04FCA6F3F10D920C0D7803340D98DA54072A6923FD9E90EC0B96D6B4062C8B73D5954ABBE32F1793E8ABD93BEA7D28D40400D9AC041A0F13F59DF0F40E516883FF16C2C4086E80E408B373FC05F1001405161F83F82718B406B68E94071815A3FB145834040F1053F4BB0BFBF36E5763E28DA983F06FE7F3D5AE00FC00B04773F8655564022696CBF92C2C5BF0F8F1140EBCB57403C53CDBF577ADEBFCE8AF33F77524AC057EA39BED446DFC0E28CBCBF49BB33BFD75ECA3FDADFCDBEAF2C20BF599129405956D53FF4D272C07E315DC041C945C0CC2136403B337040B52FDD3E168E993FAF3060408087833E762C38C0BFD197C040368740E8097640FF612B40C1A7A3BE3B49B63FB20B54BF2B143340A5C9483F2D1B85403977FE3EA944EB3FA03D0EC0B4BC2A3FA998583F5C79B8C043862B3E7F9EC9C00241B5C0D885BCC020CE204093A8A7400D315BBF0ED2A2BFB719A13F6AE7553F589B6B3ECA530AC0A88EA53FCF930B408A127BC03040DCBFFA952EC04A739C3F38310CC06D9262BFB8CABF3F79A90BC0AA86C1BF4C891D3F326A92C00AFCB8BF6905873FE01742C06EE7ECBF5CE20E3F4437203EBD4B03C057F64DC03575DA3F517F5E40988963405EC50940B9321340340674403E5FC9BFDDA0ACC0B98E89C0C52497BF7A14DA3FDAF81640CC0128C015A39D40B11BE13F0FC7AAC0CB1FBD3E6D696AC0A45854409DE6DE3F65AC60C0651E893E94D50FBFD6632EC09C6C9BBF6EFD28BEB28A7F3F4B7C9F404A8E98C00D7D9ABE74FAF9BFB94718C0167BC2C0F3050440DB6041C03B3F19BFD6ABADC0679612BF0A1E793F4C93074031BB9A3F747007C01FA14CBFC5353EC0FE1A66C030871D402F0D5A3F50E53D40B364D63FB8D0C7401D3C423F372311404EE6E8BEC4E6CA3F67979CC057007540100169C0365422404277AA40A3838E3FA93913401A070140C65C88C07415A0400D6465C0055A3BC074B4A2BF2F0B1B404E2CD73FE8CC443F723E08BF61541D3F829675BFC3141D4087981440D7F300C1E6B3BA3FB7FF9E3F76BE903F48FA5B3F8F0147C0DAAC26C0ED8E0FBFDD03E7BEE8EC9F3AFCFD573F5064BFBFC77AAABFFFCFDC3F17464AC0EA50F73FA388ECC0DF5A6C40A6554240D48F41C038CA1F40F48EED3F8030043F86C2FC3FAE84ADBF2431883F1ED4BA406982F03F5F1750BF7BCF0EBF71A63D40AE86BCC0A2AE99401211C7C069850EBF0BA378C0F965C8408C4D3FC08AFE69C05259C33F2A5057C04D2D3940D5C846405EED24409A06493E84463EC0117142C0EEEDDEBFCC633ABFC8B79A3FAB5BB640D99847BFD61DF1BF4A911ABF1A44F03F9A635FC0C983A540ABDEA2BE4D562140783F4640DF5207C099E89BBF686E3FC076BDEA3FB9EC904068C87440040095C014A999C01D9B1FC03DB9BFBF6E1185C0D8CBB0BE6656794056619140B94E1DC0602EB13F8EC38540D91664C0603C2F3F1532903E5C3024BEB03A6CBF0CD7AE40D007E7BF7D41F1BFA09D58C0B33B5D408869863F30F20A3FF898433F08D219C019C733401AEA04C058B74B4047F7F7BF1118DD3F259B19BE0020353DECAE953F6D715DC0E32F65C028E95F409342D2BF6BAE3240A622ECBF259A0BBE3DDD8840BBD2EB40B4E292BFF95D15400DD42C40DF9989406FDB4E40D18EE83F3C72C53FE57B253FA25D19BFD758EC40671258BD3B0E5F405C0D8FC06CB4DCBE269906405D441C4057895B40A641F540364DC0BFBF3E31BF7241DB3F7045503F67797BBEA4B85E40581D47C0D5F0D940E4B1C2BF2D679DBE1A7B11C05FB38F403A268B40BD0CEBBF9649A3BFAA65AA4094CE0A407DE2EABF304B894050C7163FB2E503BF49DFC43FFA57E5BF3ABB10C09E2BB93EBDCD12C05840BD3F195D973CB5C865BF48E379BFA8FAB3BF1321C2BE9BCC24BFC5461640EAD653BF3A37943F6DEE9B40DD6988BFF41DCF3E4828923D8D2346C04647993FFAFB12C052186BC0B7F3AD3D048017C051351DC0C333FABFE83BF63ED471BCBF4DFB87C027B759C07CD671C003FA3CBF967849C0D8BBD0C018B320BFE79B68C04DB65ABF9724D43D361D60BF8796103DFA0A934046A16BBF3CF39D40DAFCF23F82D573C0CEDA7FC0C6DAC6BF7ECC9A3EE8AFBE3E98E14BBE41A818BF00A359C08D224840D4AAA2BF348691C0EAFF993F8A1C22C04C1F10C01B0542404202FCBF1E35EC3E5CF7AD3FD97098BF8472F2BEA1F035BFCC53F33F95F0C1BEAF0386C06FB9D2BFF6919EBFAD39A5BFEC94313FDDF5854011C3C74084AC8640A6D1993F404132BFCF178CC082F8253F34563B3F2AD989C0ED1C383F390004BF496B3E3F83B014403CE41F3F1EB6EE3FA9921AC01BACF2BED04D6940AABBBF405DB9ABC0E62CE43EEEF9883FFD809BBF32B010BFD10883C0B16D68C0A04DBABEEE1C2340DF33EB3E20EA1CBF38A56D40D34285C0E02E9EBFE58E5F406C7019C08BFF7BBFDFB656BE2899943F2AF303C095F1D53F7475E1BE05EAA44049AA32C0670B803D7C30733FF58888406FA9F63E80750040E87EDD3FE8EF80BFB972F63FBF44CD3F78AF0940"> : tensor<3x5x40xf32>
    %1 = stablehlo.constant dense<[[[-4.49007463, -0.760085582], [0.941607296, -0.0481957085], [-1.54088187, 1.21452105], [2.66251469, 0.420113832], [1.31080914, -5.5827384]], [[0.806138157, -0.94866693], [-4.03033066, 3.41672468], [1.55076098, -3.12725782], [-0.955601274, -1.32688069], [1.47374988, 2.59487581]], [[0.593935311, 0.666541278], [4.42754173, 3.13218069], [0.304172844, 5.25776243], [-0.34970805, 4.33897591], [6.34644127, 2.39576292]]]> : tensor<3x5x2xf32>
    return %0, %1 : tensor<3x5x40xf32>, tensor<3x5x2xf32>
  }
  func.func private @expected() -> tensor<3x5x40xf32> {
    %0 = stablehlo.constant dense<"0x30FE6E40041E9BBE7C15293F1E46A8C099F067BE569BB8BE0306DF3E862906BF81BEB2BFB5E3B940360B9BBF864E7FBFD53CB6BFDB7BB0C0346E28407701DDC0345BBE3FFCB1193FE38932401B299EBF85180840ED8EAE3FFAB832BF208692BF30AC0740B4064240049F6F40E2456B409AECD63FA404ABC079A32840F42AE8BEEF89D33FC912243FC6F1744047F4A53F4CB2823F35EB9BBFC3FFC53FD4D523BE596792BF32B5D43F5A98CDBE250E8FBE02FD87C0A3EEF53F78CA7EC0DEC317C05BED2FC08DC19EC07612BDBE64EB11407105AFBF6076A8BE591680BFD5E3D4BF03B41D3FF79F2F3FB31265BCA24499403A89A240FF29E1BF109BF4BD972FADC08BE48340AEA785C092A4F03FF1F34F4047572BBFEF56C63E65F0CB3FA3CCD13FE6C026405697D1BF58F80FBF3CB3263F2AFB0B3F79B2DFBEAAC61E3FEE0366407189DB3F6D759B3FB3B9813E0E5F15BF5F5470C0512CB83F107AC7BE712C75C06841D440A77E4A40EBC10D40CC346FBF5CCDA3BF92E55A3E0F2E164037D1CBC052E203C1C81D7C408DED753F761294BF94F23F4025D8C7BF70C839C0643A86C02B30DFBEE09DF6BFD516D2BE190100C0438F853EB36744C0ED10CDBE61B307C06C632DC012D3BB403EE059BF1B4AA2BEB37EE43F434AFCBF6A1B08C0A6DF67403D6C94C0A4662A4072937B40E091D13FCDE7AFBF28DE8FC0A12A35C00C872C3FD4B818C0E91E11BFC3A178BF95D01E402756F1C0B5BD10409834674057DC244073AE1DBF0242D03F48B0813FBC40B5C015FD5F403D8321C0C9B1B1C04FCA6F3F10D920C0D7803340D98DA54072A6923FD9E90EC0B96D6B4062C8B73D5954ABBE32F1793E8ABD93BEA7D28D40400D9AC041A0F13F59DF0F40E516883FF16C2C4086E80E4098C8A73F5F1001405161F83F82718B406B68E94071815A3FB145834040F1053F4BB0BFBF36E5763E28DA983F06FE7F3D5AE00FC00B04773F8655564022696CBF92C2C5BF0F8F1140EBCB57403C53CDBF577ADEBFCE8AF33F77524AC057EA39BED446DFC0E28CBCBF49BB33BFD75ECA3FDADFCDBEAF2C20BF599129405956D53FF4D272C07E315DC041C945C0CC2136403B337040B52FDD3E168E993FAF306040125F4E3F762C38C0BFD197C040368740E8097640FF612B40C1A7A3BE3B49B63FB20B54BF2B143340A5C9483F2D1B85403977FE3EA944EB3FA03D0EC0B4BC2A3FA998583F5C79B8C043862B3E7F9EC9C00241B5C0D885BCC020CE204093A8A7400D315BBF0ED2A2BFB719A13F6AE7553F589B6B3ECA530AC0A88EA53FCF930B408A127BC03040DCBFFA952EC04A739C3F38310CC06D9262BFB8CABF3F79A90BC09EAB5A404C891D3F326A92C00AFCB8BF6905873FE01742C06EE7ECBF5CE20E3F4437203EBD4B03C057F64DC03575DA3F517F5E40988963405EC50940B9321340340674403E5FC9BFDDA0ACC0B98E89C0C52497BF7A14DA3FDAF81640CC0128C015A39D40B11BE13F0FC7AAC0CB1FBD3E6D696AC0A45854409DE6DE3F65AC60C0651E893E94D50FBFD6632EC09C6C9BBF6EFD28BEB28A7F3F4B7C9F404A8E98C0567FC63F74FAF9BFB94718C0167BC2C0F3050440DB6041C03B3F19BFD6ABADC0679612BF0A1E793F4C93074031BB9A3F747007C01FA14CBFC5353EC0FE1A66C030871D402F0D5A3F50E53D40B364D63FB8D0C7401D3C423F372311404EE6E8BEC4E6CA3F67979CC057007540100169C0365422404277AA40A3838E3FA93913401A070140C65C88C07415A0400D6465C0055A3BC074B4A2BF2F0B1B404E2CD73FE8CC443F723E08BF61541D3F829675BFC3141D4087981440D7F300C1E6B3BA3FB7FF9E3F76BE903F48FA5B3F8F0147C0DAAC26C0ED8E0FBFDD03E7BEE8EC9F3AFCFD573F5064BFBFC77AAABFFFCFDC3F17464AC0EA50F73FA388ECC0DF5A6C40A6554240D48F41C038CA1F40F48EED3F8030043F86C2FC3FAE84ADBF2431883F1ED4BA406982F03F5F1750BF7BCF0EBF71A63D40AE86BCC0A2AE99401211C7C0721226400BA378C0F965C8408C4D3FC08AFE69C05259C33F2A5057C04D2D3940D5C846405EED24409A06493E84463EC0117142C0EEEDDEBFCC633ABFC8B79A3FAB5BB640D99847BFD61DF1BF4A911ABF1A44F03F9A635FC0C983A540ABDEA2BE4D562140783F4640DF5207C099E89BBF686E3FC076BDEA3FB9EC904068C87440040095C014A999C01D9B1FC03DB9BFBF6E1185C0D8CBB0BE665679405661914073A22A3F602EB13F8EC38540D91664C0603C2F3F1532903E5C3024BEB03A6CBF0CD7AE40D007E7BF7D41F1BFA09D58C0B33B5D408869863F30F20A3FF898433F08D219C019C733401AEA04C058B74B4047F7F7BF1118DD3F259B19BE0020353DECAE953F6D715DC0E32F65C028E95F409342D2BF6BAE3240A622ECBF259A0BBE3DDD8840BBD2EB40B4E292BFF95D15400DD42C40DF9989406FDB4E40D18EE83F6CAE8D40E57B253FA25D19BFD758EC40671258BD3B0E5F405C0D8FC06CB4DCBE269906405D441C4057895B40A641F540364DC0BFBF3E31BF7241DB3F7045503F67797BBEA4B85E40581D47C0D5F0D940E4B1C2BF2D679DBE1A7B11C05FB38F403A268B40BD0CEBBF9649A3BFAA65AA4094CE0A407DE2EABF304B894050C7163FB2E503BF49DFC43FFA57E5BF3ABB10C09E2BB93EBDCD12C05840BD3F195D973C973FA84048E379BFA8FAB3BF1321C2BE9BCC24BFC5461640EAD653BF3A37943F6DEE9B40DD6988BFF41DCF3E4828923D8D2346C04647993FFAFB12C052186BC0B7F3AD3D048017C051351DC0C333FABFE83BF63ED471BCBF4DFB87C027B759C07CD671C003FA3CBF967849C0D8BBD0C018B320BFE79B68C04DB65ABF9724D43D361D60BF8796103DFA0A934046A16BBF3CF39D40DAFCF23F82D573C0CEDA7FC0E4D88A407ECC9A3EE8AFBE3E98E14BBE41A818BF00A359C08D224840D4AAA2BF348691C0EAFF993F8A1C22C04C1F10C01B0542404202FCBF1E35EC3E5CF7AD3FD97098BF8472F2BEA1F035BFCC53F33F95F0C1BEAF0386C06FB9D2BFF6919EBFAD39A5BFEC94313FDDF5854011C3C74084AC8640A6D1993F404132BFCF178CC082F8253F34563B3F2AD989C0ED1C383F390004BF496B3E3F83B014403CE41F3F0C16CB40A9921AC01BACF2BED04D6940AABBBF405DB9ABC0E62CE43EEEF9883FFD809BBF32B010BFD10883C0B16D68C0A04DBABEEE1C2340DF33EB3E20EA1CBF38A56D40D34285C0E02E9EBFE58E5F406C7019C08BFF7BBFDFB656BE2899943F2AF303C095F1D53F7475E1BE05EAA44049AA32C0670B803D7C30733FF58888406FA9F63E80750040E87EDD3FE8EF80BFB972F63FBF44CD3F78AF0940"> : tensor<3x5x40xf32>
    return %0 : tensor<3x5x40xf32>
  }
}

