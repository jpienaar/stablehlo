// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x20xf16>
    %1 = call @expected() : () -> tensor<20x20xf16>
    %2 = stablehlo.floor %0 : tensor<20x20xf16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xf16>, tensor<20x20xf16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x20xf16> {
    %0 = stablehlo.constant dense<"0xBE4487BFD12C184054C40636C9BF3EBC60470AC5EE3CBF3A2C388EB99EC35EC2EB4015BAD043E3C255BF4243F93BD9C20FC4643229463542E0321BB0B4278CC1B0BDDB411042423F00C25248BEC33AC1E43C9C40B735F23CC83F583FAB42B8BCE7C555AE2E40A6BC8FB9F03395C545414F3755B95340A5B9524285BA923C673840BDEA414B44ADC04E39263313C76044A240AC431440363EBD4483B92E40FFBDEFC3A0433CBDDF3CA2BA8945E2BF0F411C3486BEAFB4EC290EAF19BD5FC14632A74442315FC4A5436E3F1AB590BFA34074BC5CBF0CC56DAFDBBE6EC16B2E5D3D0243123C804328C47140E2BFE6B0F5C25EC7DDC514BC6844F3C00644CC3023BC55BBE5B4E0BB1CC2633BC43FC4BFB53FC4C4753D27C223400145D3BFC6457040A5BA00B63EC74F2C3640B041E934A9BD1647C6C0E0BCB63A13C76443913F85BF684318405D3AAE3EBA3121C221398CB952BC7EC4EDC14441E62EE443553C0D2CE33AA8C1253BF4385FBB1FC530C598C7DF348E3C6C3B8B3F9F4423B6203CE44487C0B9C410BA003FC53EB9C4E43D6DBB73BC5245F0B805C205C7CF4206C089BC4F406FBDD9C431BCB3C5B1344DC145B50A42EBC06E45F93CBF456A362043B73F1E44AF404CC07CC4FFACA23E8CBDE9C2B6C10EB91044F542FB3A4AC56F4537C091BF8ABCAB43C7C0943E3DC42D3EF1BFF83D84B55E45F9C10345ACC289C1B44023C428B911C26EC11DC269C813B32A389E410EC40CBCD0C6EABC034440C67BC5E7C4C1C4B2B803C239432AC11DC34D3E97B4A4450648F2C35B3DAEC30DBDD63C373F63416E44D4C107C2993716C5A7B06C43A2C2EFB8D5C001C473C0D53BEFBEF94415C544C402410AC076409ABE2DC1B640803D2AB5CB3F38405A4714C01FB5E6B94643EAB8E9C469BB41C2EFC4FF3B17BC29BFD6B4F344A9C14EC4C4BA5AC51BBE3D3F15BC4644A3BF9C41423B9E457F3E74B6053E3DC01ABFF13D4F464142D2446BBC22BBECBD4DC37BA682BFCDB62ABE15BCD83DAC3616C2853BD44184403ABB59403E424BC1DDB6293D6235AA463CC2F2C263C1F8BB03C238409037C53C16C2253C143F01407B3D25C29CB44AC398C4DFC4E5B8E9AE4440DC3EC13CC345"> : tensor<20x20xf16>
    return %0 : tensor<20x20xf16>
  }
  func.func private @expected() -> tensor<20x20xf16> {
    %0 = stablehlo.constant dense<"0x004400C00000004000C5000000C000C0004700C6003C0000000000BC00C400C4004000BC004200C400C00042000000C400C5000000460042000000BC000000C200C000400042003C00C2004800C400C2003C00400000003C003C003C004200C000C600BC004000C000BC000000C60040000000BC004000BC004200BC003C000000C00040004400C20000000000C80044004000420040003C004400BC004000C000C4004200C0003C00BC004500C00040000000C000BC000000BC00C000C200000044000000C50042003C00BC00C0004000C000C000C600BC00C000C20000003C0042003C004200C5004000C000BC00C400C800C600C0004400C20044000000C000BC00BC00BC00C40000003C00C0003C00C5003C00C40040004500C00045004000BC00BC00C8000000400040000000C0004700C200C0000000C80042003C00C0004200400000003C000000C4000000BC00C000C500C2004000000042003C0000000000C20000000000BC00C600C600C80000003C0000003C004400BC003C004400C200C500BC003C003C00C5003C00BC00C0004500BC00C400C8004200C200C0004000C000C500C000C6000000C200BC004200C20045003C004500000042003C0044004000C200C500BC003C00C000C400C200BC00440042000000C6004500C200C000C0004200C2003C00C5003C00C0003C00BC004500C2004500C400C2004000C500BC00C400C200C480C800BC0000004000C500C000C700C0004400C700C600C500C500BC00C4004200C200C4003C00BC0045004800C4003C00C400C0003C003C0040004400C200C4000000C600BC004200C400BC00C200C500C2000000C0004400C600C5004000C2004000C000C20040003C00BC003C0040004700C200BC00BC004200BC00C500BC00C400C5000000C000C000BC004400C200C500BC00C600C0003C00C0004400C0004000000045003C00BC003C00C200C0003C00460042004400C000BC00C000C400BC00C000BC00C000C0003C000000C400000040004000BC0040004200C200BC003C0000004600C400C400C200BC00C400400000003C00C4003C003C0040003C00C400BC00C400C500C500BC00BC0040003C003C0045"> : tensor<20x20xf16>
    return %0 : tensor<20x20xf16>
  }
}
