// RUN-DISABLED: stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<2x3x9x10xf16>, tensor<3x3x4x5xf16>)
    %1 = call @expected() : () -> tensor<2x3x6x6xf16>
    %2 = stablehlo.convolution(%0#0, %0#1) dim_numbers = [b, f, 0, 1]x[o, i, 0, 1]->[b, f, 0, 1], window = {} {batch_group_count = 1 : i64, feature_group_count = 1 : i64, precision_config = [#stablehlo<precision HIGHEST>, #stablehlo<precision HIGHEST>]} : (tensor<2x3x9x10xf16>, tensor<3x3x4x5xf16>) -> tensor<2x3x6x6xf16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<2x3x6x6xf16>, tensor<2x3x6x6xf16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<2x3x9x10xf16>, tensor<3x3x4x5xf16>) {
    %0 = stablehlo.constant dense<"0xC9383A3776BB664089BD7E44DD3FA2C17DA2C0BE0CC41DC40B42F741F93C70BC5ABFEB3AF746C7C23AC3623D084343B5AF40D73D8A427641143B8837363D303526C2064283C10EB9CCB6C8C046C4163F3639DC3A58B8B74372C599413F38B4BBBDB846BC71C480BEAEBFDA3462B88BB50BC3B93FF8A936C4BA3AB8446FAF974472C1E042B14305C78148034113C322C089BFC539183CA3C743C3F0401A45703D3244FCC55D44C740C2C26BC15B44E3B36F34A9C28D319B4386B2AFB9103553C12D4071B90BB3E43F01BCA2461C421FC2D7C3DEC08EC15443E246BB3C7FBC81C33A3575389DB73EB19FC59741CF402F35CC442443A6C19C3009464A4459345AC0B43D3D4320BAA544E045F9B30C40C3C654C50FC139441C3A22C4F03C9941F1450AC115BF424384408EBD44C275387D3FD4BFB0C1AFBF413D42B97A3E55C44FC1C3C4E940B1413047F144D5C0B1C168C29EC22E1ED0C306467C37F3420B4547B82041BCC343C21DC08ABE19BCF84066395D2FC242E1C1484448429831983CAAC0C93D46B907C4454552BAF9BD0A3D6C2FD5437944B2C44CC6DE44BA45743A2FC4D1BE5D3B56BD30C265BB3E44BA35CC3CF53E1D422D42413E93433043F63AD74310469E3C15C457C5E9B6FCC628BE38B351C25B408D3C66BCD1AB0ABABEC3713CA7BDBFB50A456EA5723D31C0DFC2BFBC71BA7EBD23BF2230B24114C018419EB8B03CDDB75DB868C1A7B3FE4112C2EDC0BC4687C442B7ED4129B4AC43F74005365C41A33DE544423FEEAFA5460C44C8BF4E3CAB3EE13D60BDED3FAE3829B9E5B05EBFF3414F4766417B3311B96BBD7D3D3941FDC165BF54C049C5DCBC96C1224015BD38C12EBBA53C20C043C33439EEB87644A5442E3C4E3B07BE7231AE4073BA283EDA3D1E44893DF83C53C0AD3EAD40BEB47AB3693FAC3D9940E93AB4BD4B2BD6C6382E37BFE6387CB94846B13CDB4473C129B5B9C6F94415433E4896C08C3FDEC45C2D25465B41B1BF6A409EBF4E41434308C25F3C1247AFC019BEDD3318C0D1434CB8F23FAF449240AABF0B45FA46AFAFA03AB540BA45A1C6EFC0553D9B3EB7C19F3F3ABF1CC5D7BD4346463CCAC0EDC6682F4247D7B82B417B46A5BF47B829C13725243B33C170BDC43E1844C2411243AB215EC5A7400D34DDBD383CCE375441EA2F83BCC5BE2444133D09414C43A8BCC3344BBB6546FF336AC053C62547A6BDF9C23543AFC367C0BEC1A444CB3DBC3F5243A5336C43B2C36C431D3040C0E9B7E63CC5AA0F413F3BDD44DCC15043A4BAF939F13AAA3CCD3F793BF44060406339C0C3CB448FC48BBF34C0D7B505C18945FEBB89B991BF173C4F42F23B0CC0414195441B47D04213363CC232C101C3AFC1C0B84D3C59C597472448DEBF0C40AABCEF45FBC24DB7DAAE1B41BCC51B419E37543FCA2DD53624BE55B57938EAAB25403F4192C446458A44C7BCE13289C35742AC3F694529BE003BD2C49A404CBF3BC0F4445DB86A3DC7ACCBC563B757448E3BBA40183DCDC3"> : tensor<2x3x9x10xf16>
    %1 = stablehlo.constant dense<"0x3B3A0435484326B7903FF0C0D33C633DB6C394400DC20E4064C1553589C896BD94446D35EEC1A94118C3993DC3383A34CAC49A3A93C45642E13C7F4324449341673F64C16CC27CC289A147C2343F0D3FD34323C352C460C3F5C522BE913DF33E6041B4C2823F453E043CDA3434C5D9BFCF40003F54405B3EC7428D402E3456BA8C31C3C4E6B0F83A65C19BB3D4420C38533D284444C52140623EBE40D3BC2445A9BD8D4256BDA63436391542ADC068AE273F0BC461BF4BC25E3CB439E3C09146C9C461303FBFA6BEADC1734357C0EE415139633F8734C2273840DFBD1F455CBA32BD68BBFA385644D6C3AB308DC63C4135443F430BBEE5C4273961C471B9D8C4DD3CB3411CC1AA3588B959C2AEC1A03C434517C164C24CAC9FBBA036E9C435439040B8B28FBA28BC6B38DC42F2C21741024547BFFE46A6400C42CBBF1C3A4042063DB8ABC24140B8DC3DE344C6B5B3C467BB5B44C84111BA814113433EC5773C2CC32C3D2EC5BE3C"> : tensor<3x3x4x5xf16>
    return %0, %1 : tensor<2x3x9x10xf16>, tensor<3x3x4x5xf16>
  }
  func.func private @expected() -> tensor<2x3x6x6xf16> {
    %0 = stablehlo.constant dense<"0xE4D6ADD6A6CBA6C9D7CC11CA10552CD694C971500C4B6D4F9254CA5318591CD3B2442B494DD61146675147D76D4D6CD3E94B81D4FAD4865770D66E53F5D5AC58915260CD6FCB224C2B495055FED13AD7C3C7E85510D66DCF5851FEC61755F8D599D4ECC04DD1EE55D7502A5031CC04544351FBD118588E52514716D4E44629585DCD89C9A5D6E2B517523DD977557ED59DD2494802D6DB4D7A50B256F4BDD35134D0C9CBDB57014CCB4DB9D25853B5CE734E0950C053B34A3A4700D6585876530439DBD307C0985471D147D786D0C5D2DB596DD480D66D38AC514B517146905336D79553CFCECA52573DA74F3554D749545540508E5780D4D8D0FFD110D92C51AD4A55466658D6CA1A55D1D63F53DC4C05CEC152E256ABD243C73D52925025D86CC473D562543BC81353A1D2B6D4014B894D6D5598D46C4CE1CB0D56054D6F45594C5F5189C5395070D74E5075D7FDCD47D60455D156B7D55054F94C80585F4E5756064EDAD54150B1490BD402CDE95004481554CBD3F85276599A52B0D3DD5356578B4D9E54D84A2251DC5451CE05C72C479657FBCEA3D8B751A844A8507859D7449CCCD0510CD497525248D9D066D6"> : tensor<2x3x6x6xf16>
    return %0 : tensor<2x3x6x6xf16>
  }
}
