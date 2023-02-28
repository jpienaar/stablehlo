// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x20xf32>
    %1 = call @expected() : () -> tensor<20x20xf32>
    %2 = stablehlo.rsqrt %0 : tensor<20x20xf32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xf32>, tensor<20x20xf32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x20xf32> {
    %0 = stablehlo.constant dense<"0x32A0D7C0CF721B3FF3CD2040739688BF5E4D8B3F4FE51440ADD9863FA9993FBFA96C84BE1FF9603F1F7953C03D88753EF55B43BE29BDADC06E5115C09240604045632ABF1FC2113E44E26E40804D8D40F4DF16401B5B6BC038C696BF08B25740F808BDC05BD05EC0E6B4E03F09E788BFF0818E4081FE8F3FB12AC7BF8FDD00404D5688C0B78DBE3FE810F4BFDD6B0A406A016EC0C1B246C0E352F9BE43317F3F6C421640AA5406C0A1CE0DBF051C143FBBE1343FE0B0D040D24F0C40BB13184022D6DE3F56DBDB3EA508213F98FA2CC075C4154038231640E06BF4BF765086BE86CFD13FF1B461C0547C4740F050653DC432C33F4C367AC0F2BBFBBF9BCADD3F2FAD4F3F2C2B72C0DD255140304297C0CD098D407575D03FE17679C0AD10CCC07C29F83F408ACA40A74BB840C5445F40694DB7BFFF0922403FD22840EBC59BBF2EBC1E402C81B3C033697640D175DA3FA9E09DC0DF2EFE40C3C6723E5EF68D3E76B64CC08527A3C0B829123FF4CD1F3EA839D9BF2C48943E78E5324011D534BD13D69BBF4C0002C071DEAEC0AFE9723F4FE340404DA651BE6C407D409B8117C0B2E64A40DD4437BFC842BB404D13D6C044963B3FA60ECC3F8D7515C08B7A9340DE3F98C0496BC6BFF2478CC0951B4DBF1AEA1C3DE8FE73BF0C6E5240A73C05C0033B4E40509890405EFAD3BF3F963AC0260FBC3FCBC531C0D7DC8D3F99DE81BF0A5B0ABF81A7864076AB8C40F579873FA94C3AC00E698AC039F7A33F8E552BC0628E203E73119B40E69632C099CBEFBF4CC707C0627285BF3CEF0240A913114010C7BE3F638207C06525C9BF4D95113F7100F03FD61C08BF78562040C9FBC9BF0C6CB0C0E6273EC04840EA40D4D61EC0F5351040D840A33F13C7873F642350BE8367A1C05F9601BF001BE9BFAC02853F66A09ABF0D9EE7BFB2C991409DA0F4BFEC4469C0350A33C0D7ACD4C0FCC35FBE3F588DC0D0A3553F9DF5C340C36F4040A0FA46C0D8B46540D61342BEB01D77C0EC1B50C077189B40F79DADC0B8508E40BF5935409367B540CE9E54408119633FD3D8C4BFC2F91540FA8CAB401B4CA1BF67DC4140599363C0831E8940CADF5540CECB3EBEA2101B402B68C53F66D15AC052D704BE33B9473F0364413E7633C7BFB89510C0F59126407CCDFBBFE270F8BF4B108FBF0F5F1CBC7002FB3E8A3A88C08B9C7F40ADA53CBF8D23EBBF489055C04ECA374033991FBF6CA3EC3F2CA52EBF9E732F40240E28C0582BDFBF1EE69340CC3D4440AA0EA8BE09B591BF4BD6C9BF691ED53EEC15A7BF0838C83E04E501BF61993440F51A71BFD12F833F4AD43D3F2C0A55C08EB6BABF5B007FC0AF7A44400B2B903F64FB7EBF1748B4C0A08C79C0E6A27FC0A7745CC0D7E0A63F3ED1D63F7DCC8BC0908E1F3F586B08C00484A63F0DE014C00D1A95C03FFDE13FBD79C840527D724051A3183FE785913FFBFACCBFBB49194059008040C145224072A73C3F055C73BF12D24ABE8939A2BFE9CA24BD86B013408F8E1BC01104A2C03C6B4DC00E07EA3E536590C0938CBB4033D4FFBFC83CC93F7389A240191BAFBFE7D2063EE4F902C03720F4BF56613FC0A52A0440E811314080F5014136A1A43D2601DCBF4A733640BE634C3F89E57DC00DAF2F40FD704B3D872A72405933C2BF889453C0646A7EC0F3BE25BF11BE1FC0F7F9D53FC372A7BF81D99BBEF018B9BFCE238CBE4B388EC00719A84058A0B9BF33788ABF96F3A6C098F04AC0DAF373C0002F7BC04A2C863FC59C7E3F0DAC18404508C9C096CA92C0EF6A9EBF71AACE3FE61685C0EE4EC0BF71ED04404D95594066F255C07EEE4C3F639E89C03E766040BF07A7BF8CBAABBE019F3DBF36EEBF3E871F52C0EE2F19C0248D033F80F599BFFFA236408A1008C03CE374C07B492FBF5844A8BFF9CA5DC0985C3540C3324440D18BCFC0C7153340B8B23B3F0B2B323E9C8EAD3F8463F73E4CC2C2C0D9A3283F0A50CCBEBA1E1240EF8478404F808840C097F8BFFFE87040517C94C0D45B8540C43021C0534657401224F3BFCB4CC840E180ABBF0DDE43C0EFBB144052BDF2BF43F97BBF45445F403CA0F7BD94533C40A8D2B94071886DC0C499F2BF30CCCD3F08F584BFEFBA94C05D91EBBF476816BE5B8003C092B6BC3F3EDDB140B461BBBFA2B6E6BF278B1CC0AF7951C0E59EB53DA1B1ABC008AEECBF7A1B4FBF1D1B33C0B744FE3F7EC941408F735EC0341B8FC0DE447A402299A5C0516F9640EF92CABF4D8C6640"> : tensor<20x20xf32>
    return %0 : tensor<20x20xf32>
  }
  func.func private @expected() -> tensor<20x20xf32> {
    %0 = stablehlo.constant dense<"0x0000C0FF0943A43FCB80213F0000C0FF2765753F62D6273FB769793F0000C0FF0000C0FF9F8A883F0000C0FF36B302400000C0FF0000C0FF0000C0FFC2C2083F0000C0FF58A229409E81043FDEA6F33EA7BB263F0000C0FF0000C0FF75720B3F0000C0FF0000C0FF9A36413F0000C0FFA29EF23E305D713F0000C0FF1369343F0000C0FFA0D0513F0000C0FF62122E3F0000C0FF0000C0FF0000C0FFCE33803FF612273F0000C0FF0000C0FF4848A83FC146983F7E7DC83E2AE52C3F9912263FBB05423F2D55C33F5A63A13F0000C0FF2A59273F5124273F0000C0FF0000C0FF5BF4473F0000C0FF8500113F093E8740BB4D4F3F0000C0FF0000C0FF9B7A423F231D8E3F0000C0FFEF9C0D3F0000C0FF51E1F33E0F9A483F0000C0FF0000C0FF14DB373F0283CB3EF658D53ECB0F093F0000C0FFFEE2203F309F1D3F0000C0FF6C8D223F0000C0FF7F77023FC3F4433F0000C0FF47AAB53E93700340C815F33F0000C0FF0000C0FF3066A93FF40122400000C0FF47D9ED3F791E193F0000C0FF0000C0FF0000C0FF0000C0FF2067833F0A76133F0000C0FF53B1003F0000C0FFC4C60F3F0000C0FFCCA6D33E0000C0FFB487953FF7C04A3F0000C0FFDF7EEE3E0000C0FF0000C0FF0000C0FF0000C0FF247EA3400000C0FF562E0D3F0000C0FF749C0E3FAFDCF03E0000C0FF0000C0FFAC33533F0000C0FFA62B733F0000C0FF0000C0FF2A98F93E0A33F43E01D6783F0000C0FF0000C0FFFA2F623F0000C0FFC0A021400796E83E0000C0FF0000C0FF0000C0FF0000C0FFB5FA323F39082A3F14B1513F0000C0FF0000C0FF74BCA93F8EF43A3F0000C0FFEDBC213F0000C0FF0000C0FF0000C0FF763CBD3E0000C0FFBA8A2A3F2EAE623F4E8F783F0000C0FF0000C0FF0000C0FF0000C0FFCC217B3F0000C0FF0000C0FFE6DFEF3E0000C0FF0000C0FF0000C0FF0000C0FF0000C0FF0000C0FFC81D8C3F92E6CE3E49A2133F0000C0FF9D20073F0000C0FF0000C0FF0000C0FFC490E83E0000C0FF93C8F23E5614183F700AD73EAE730C3F95E6873F0000C0FF6A3B273F6A21DD3E0000C0FF2E17133F0000C0FF4157F73E220A0C3F0000C0FF0077243F06244E3F0000C0FF0000C0FF6CEA903FF04413400000C0FF0000C0FFF0AE1E3F0000C0FF0000C0FF0000C0FF0000C0FF5ACFB63F0000C0FFE418003F0000C0FF0000C0FF0000C0FF1211173F0000C0FF7A473C3F0000C0FF689D1A3F0000C0FF0000C0FF1228EE3E1A32123F0000C0FF0000C0FF0000C0FF8465C63F0000C0FF23B0CC3F0000C0FF3F65183F0000C0FF1BDF7C3FF3A4943F0000C0FF0000C0FF0000C0FF721B123FE537713F0000C0FF0000C0FF0000C0FF0000C0FF0000C0FF7334603F529C453F0000C0FF1F22A23F0000C0FFE772603F0000C0FF0000C0FF0BAA403F948ECC3E7984033F69C4A53FBE17703F0000C0FF556A253FA8FFFF3E5BC5203F491B953F0000C0FF0000C0FF0000C0FF0000C0FF7B85283F0000C0FF0000C0FF0000C0FF9753BD3F0000C0FF247DD33E0000C0FF5C2B4C3FED2DE33E0000C0FF006130400000C0FF0000C0FF0000C0FFA624323F1DE8193F5BA6B33E16BB61400000C0FFD19E173F80408F3F0000C0FF3E831A3FDD958F40F39A033F0000C0FF0000C0FF0000C0FF0000C0FF0000C0FFA0FF453F0000C0FF0000C0FF0000C0FF0000C0FF0000C0FFDF63DF3E0000C0FF0000C0FF0000C0FF0000C0FF0000C0FF0000C0FFAB0A7A3F2B59803FABBF253F0000C0FF0000C0FF0000C0FF5B78493F0000C0FF0000C0FFEEA1313F42D70A3F0000C0FFF90F8F3F0000C0FF68B2083F0000C0FF0000C0FF0000C0FF9B0FD13F0000C0FF0000C0FF2B8FB23F0000C0FF038B173F0000C0FF0000C0FF0000C0FF0000C0FF0000C0FF2513183F3736123F0000C0FFD109193F5E7C953F806E194042D95B3F9624B83F0000C0FFDEB49D3F0000C0FF8F6C293F86E9013F6DE6F73E0000C0FFA8F2033F0000C0FFCBCDFA3E0000C0FF53950B3F0000C0FF86A5CC3E0000C0FF0000C0FFB8ED273F0000C0FF0000C0FFF20F093F0000C0FF793C153F0978D43E0000C0FF0000C0FF07E5493F0000C0FF0000C0FF0000C0FF0000C0FF0000C0FFE7D5523F9F2BD93E0000C0FF0000C0FF0000C0FF0000C0FFAEE956400000C0FF0000C0FF0000C0FF0000C0FF79A2353F5C1E133F0000C0FF0000C0FF0F75013F0000C0FF0224EC3E0000C0FF69E1063F"> : tensor<20x20xf32>
    return %0 : tensor<20x20xf32>
  }
}
