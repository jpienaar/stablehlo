// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<1> : tensor<2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<3x5x40xf16>, tensor<3x5x2xf16>)
    %2 = call @expected() : () -> tensor<3x5x40xf16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f16>, %arg1: tensor<f16>):
      %5 = stablehlo.multiply %arg0, %arg1 : tensor<f16>
      stablehlo.return %5 : tensor<f16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [2], scatter_dims_to_operand_dims = [2], index_vector_dim = 1>} : (tensor<3x5x40xf16>, tensor<2x1xi32>, tensor<3x5x2xf16>) -> tensor<3x5x40xf16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<3x5x40xf16>, tensor<3x5x40xf16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<3x5x40xf16>, tensor<3x5x2xf16>) {
    %0 = stablehlo.constant dense<"0x1D3F1C3C5DB42CC406B8DCC590B4BDC162C4FD4012BD43BD19BD56C40CC6773E5FBA7E454841683D6646223813C527C77244F6414AC04E4111C4AABC0DBF00BD0742BBC22BC1763F42B04844043D2C434EC1903088C4B631A8C87FBBDDBD40BC1E3D033A363C2145C8421EC0FA38F3C092C5D5C1173108BDEFBC10BB5CBF5B3426452AC70E40B5BE77BF86C1C44209BC5B3BE442C842E64467BC714566352F4493BF014028C0B5C0D8C2213A15BB253CA83EA8C56C395DBF03B2D5C4BFB4BB3CEEC403BD01AD9FBD23C2593A68460241F7B5D0C0DEBE62B1BB42AAC3B9C59C36D6C33D47473A163CDC430B46D1C0A9C64BC084C2613A1944B74043C5AEBE9B40C545273A0740F84343316CC4DD3699C1C9C103414ABE63366E39043EC1C4FA3F88C1F2403BC30E43C9BC4BB2EDC07FB59EC4C2BA913ADFC50B431B4899395DB507BBBC4525BEAABC26BFACB9584360C833C0802B06B41C405AC24E3E0DC102BEAAC0B5BA263CBEBE15C3E1BA00C5A6C24BBF9846A8C5D2C33F414F46A1B47945CEC6EB3E3E41EF41C63406C659C1143789C1EAC40AC4DE2C664439C1093C7E421DC658C1FF219B43243CA53C6EC3783E27B9BB447AC750C5F2B4F6390FC42EBAF5BC8F413A3CE240AF40A7B6BEC1B4C00646EC3FA3C30843F5AE414106C336BD133FAC44D6C022410DAC713E50BC2B409B46EEC528423BC0E4433043D8431543093E943F453D1FC87440A03EFC3C66C1E536B545B442DD3B4243C6C4D2BE513B2EC388BC90C01E4027B817BDB5C001407336FAC407C8CABC14C07841E4B923BFA1BD933BDE33103CC23D28BF6ABEACAE583C76B97CC1B3C2CFBD19424441B5BB28C5473F24C37A40663DC1B277BEBF474B3F7FBE44C4D73C5FC0E7427B3E51C2E1416A429DB9B0427F44A542CDBB993B98C532420DC3882E2F37A1BF6334414077C0FFC0A543FB40ADC442C41C3ED041D54338441F3583C6B5BD7D439FB7DA440939FAC3273B59C39D42BBC52A43863EDA414935F84009B885C4303A5DB1EE400ABE9AA3EAC01FB786BF2541F047FB444EC462413DBDDBC45BBC80C1B1B85D3C4E44B1B8BAC1FA42063C4FC275434041DA412437293E63C7CE3D60C593448EC07EB590BDF6BDF8C310336843BF448634583E1F441CC0D03EB4BF204047BC39C10DC3C742334399C12E3C15BB614552475C41B5C696C015B68A321DB6B6370EC19C4300C0EAC0263E7A3FD0B9EFC4E6BEF039263DB342F234083D4C44F6C0863F0DC11E461F40BBC103407D3E784327BD62BE2543DC40F9A9D936F83ED8BD0E42534155C587C5C643D0C5513671BE49C0493F9F40D23DC9C4C43BBF3B0FBC9FC248C22F44C9BC063DB1C00BC45F40A03CE1C2A7C2E93A4346EB44993906B969C58DC10B3DDD388B40D23E6BC228C54F3D503BF441192C25C4C142CE433F380CBDC8BB0635CFC3CDB945BE254671BDAABC51387A4170C3774359387EB9844463405B37DBBE8A404BC31B42A0418FBEBB38E3C307C2133C2B39133C853487B2A5C01141D53C593E274552C0AB44383DE53654BC21C022BDF844924721C1D9348A3D94C129B69B3F28BE1B3581B99E30363EE4B071C040363DBC93C47BBD3AC378C069415EC4E83C45C053C1B1BAFE410EC70CC2E940523FBCBCFB3D1A422045F6C109BD8FB99C43F0BCEF4109C47CB0ACC5"> : tensor<3x5x40xf16>
    %1 = stablehlo.constant dense<[[[6.359380e+00, 3.098140e-01], [-1.364750e-01, 1.598630e+00], [1.240230e+00, 4.117190e+00], [4.324340e-02, -4.242190e+00], [1.312500e+00, 2.398440e+00]], [[1.675780e+00, 2.552730e+00], [-2.644040e-01, 1.134770e+00], [-1.824220e+00, 2.253910e+00], [9.702140e-01, 7.751460e-02], [6.382810e+00, -1.437500e+00]], [[-3.544920e+00, -2.789060e+00], [4.269530e+00, -2.865230e+00], [2.486330e+00, -2.861330e+00], [-3.381350e-01, -1.334960e+00], [-1.918950e+00, 4.199220e+00]]]> : tensor<3x5x2xf16>
    return %0, %1 : tensor<3x5x40xf16>, tensor<3x5x2xf16>
  }
  func.func private @expected() -> tensor<3x5x40xf16> {
    %0 = stablehlo.constant dense<"0x1D3F0D405DB42CC406B8DCC590B4BDC162C4FD4012BD43BD19BD56C40CC6773E5FBA7E454841683D6646223813C527C77244F6414AC04E4111C4AABC0DBF00BD0742BBC22BC1763F42B04844043D2C434EC1F6A788C4B631A8C87FBBDDBD40BC1E3D033A363C2145C8421EC0FA38F3C092C5D5C1173108BDEFBC10BB5CBF5B3426452AC70E40B5BE77BF86C1C44209BC5B3BE442C842E64467BC714566352F4493BF1C4928C0B5C0D8C2213A15BB253CA83EA8C56C395DBF03B2D5C4BFB4BB3CEEC403BD01AD9FBD23C2593A68460241F7B5D0C0DEBE62B1BB42AAC3B9C59C36D6C33D47473A163CDC430B46D1C0A9C64BC0C838613A1944B74043C5AEBE9B40C545273A0740F84343316CC4DD3699C1C9C103414ABE63366E39043EC1C4FA3F88C1F2403BC30E43C9BC4BB2EDC07FB59EC4C2BA913ADFC50B431B4899395DB507BB834C25BEAABC26BFACB9584360C833C0802B06B41C405AC24E3E0DC102BEAAC0B5BA263CBEBE15C3E1BA00C5A6C24BBF9846A8C5D2C33F414F46A1B47945CEC6EB3E3E41EF41C63406C659C1143789C141CD0AC4DE2C664439C1093C7E421DC658C1FF219B43243CA53C6EC3783E27B9BB447AC750C5F2B4F6390FC42EBAF5BC8F413A3CE240AF40A7B6BEC1B4C00646EC3FA3C30843F5AE414106C336BD133F9BBDD6C022410DAC713E50BC2B409B46EEC528423BC0E4433043D8431543093E943F453D1FC87440A03EFC3C66C1E536B545B442DD3B4243C6C4D2BE513B2EC388BC90C01E4027B817BDB5C0014073361E4D07C8CABC14C07841E4B923BFA1BD933BDE33103CC23D28BF6ABEACAE583C76B97CC1B3C2CFBD19424441B5BB28C5473F24C37A40663DC1B277BEBF474B3F7FBE44C4D73C5FC0E7427B3E51C2E141B8339DB9B0427F44A542CDBB993B98C532420DC3882E2F37A1BF6334414077C0FFC0A543FB40ADC442C41C3ED041D54338441F3583C6B5BD7D439FB7DA440939FAC3273B59C39D42BBC52A43863EDA410FC2F84009B885C4303A5DB1EE400ABE9AA3EAC01FB786BF2541F047FB444EC462413DBDDBC45BBC80C1B1B85D3C4E44B1B8BAC1FA42063C4FC275434041DA412437293E63C7CE3D60C593448EC07EB5E0CAF6BDF8C310336843BF448634583E1F441CC0D03EB4BF204047BC39C10DC3C742334399C12E3C15BB614552475C41B5C696C015B68A321DB6B6370EC19C4300C0EAC0263E7A3FD0B9EFC4E6BEF039E0CBB342F234083D4C44F6C0863F0DC11E461F40BBC103407D3E784327BD62BE2543DC40F9A9D936F83ED8BD0E42534155C587C5C643D0C5513671BE49C0493F9F40D23DC9C4C43BBF3B0FBC9FC248C270CFC9BC063DB1C00BC45F40A03CE1C2A7C2E93A4346EB44993906B969C58DC10B3DDD388B40D23E6BC228C54F3D503BF441192C25C4C142CE433F380CBDC8BB0635CFC3CDB945BE254671BDAABC5138F23C70C3774359387EB9844463405B37DBBE8A404BC31B42A0418FBEBB38E3C307C2133C2B39133C853487B2A5C01141D53C593E274552C0AB44383DE53654BC21C022BDF844924721C1D9348A3D94C134429B3F28BE1B3581B99E30363EE4B071C040363DBC93C47BBD3AC378C069415EC4E83C45C053C1B1BAFE410EC70CC2E940523FBCBCFB3D1A422045F6C109BD8FB99C43F0BCEF4109C47CB0ACC5"> : tensor<3x5x40xf16>
    return %0 : tensor<3x5x40xf16>
  }
}

