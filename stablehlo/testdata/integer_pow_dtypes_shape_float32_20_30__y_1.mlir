// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x30xf32>
    %1 = call @expected() : () -> tensor<20x30xf32>
    %2 = stablehlo.custom_call @check.eq(%0, %1) : (tensor<20x30xf32>, tensor<20x30xf32>) -> tensor<i1>
    return %2 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x30xf32> {
    %0 = stablehlo.constant dense<"0x309D6FBE4FF036C004F2C2C0CB9476BDA50DDA3F51ACAD4094E85440B3201040284FE83FC58CD33FBAAC913FE9FB5140DA4F164065A73340CD5847401C56A8405F0235409B6357BF7AB0103F64A9254010931F3F46E58C3FE921D23FA5A7DD3FD3DFE9409E729CBE3DB3B83FAF7F4AC066E610C022AD6FC07D3A8B3F76F35FC061A7DEC01865383FD5E63040593F923F473EBEBFDB832CBFC0AD06C057FD72409BD06140CCD872BFFD766EBF83CE29C0EBA2FC3FA1E4B7400D85A14007E60F3FD047D03E8952F0BF80721AC039FB0FC0ACB57EC0930EA6404EFCB240E42BDDC0756583C0A4C76940D553B13D9489873F7522D7401E7538C033FF734018EAEE3E08A3AAC0E47A26C06F1430C0F377BEC0C2E4D93FF900953F84D40E40535408409D71ACC0DD8F8DBF951F413FE616B640DFD8E4BF360DCD404144FFBF002EB93FCE675940D629CB3E12F083BF93870EC0BA4207C0335E09C0A85996409E4752C093A42540C2814D4089F382C08531CC3F6D6F243F74039CBF12F20040724F58C03FF14CBE8A2385C07DA528BF33EC8CBF113C8D3FE2C80DBDA54894BF9457A6C0BF50B63F234CEABFC51C4F3D071F7FC030543F3FA88982BE37D822C09BD0C0BF8E3DF3BF091B3CBF73612F406D823EBE481A61C07C32CCC0BE4C863F69DC303F1F1280408052DABF227D8B4021EB46C086276EBFFCD87EBF449033408D4587BFFC503340603D35BF3E7358C0D7E69B4099FC23C028469840EB176CBDE7C451406C64C4BE48B8A6BF0D320540669C8E3F36DAAE40296D463FE5150DC00D0A2941074001404AFE49BE018D91402532933EA5186DC0051D9C3F32580840F8D789C07F548B400D86CF3E663F6F40B20686BF79DA9840CC5932BD74511AC191CA9F3F349942405EB24540D08008403EE1313D1D7F02C06B47034052E6CDBE04F9F33F9C5BABBEAC91ED3E3BC410C063416E40585283C0B8C1CFBFE151AFBFE54E5CC00F0553BF45ABB63FD50E9A3FA86A0A3F12D11740324D6CBEEF0532BE2F0425C03A6653C0468D2FC09C4C0ABF2B28FC3F5559993F60150040DAC994C04A03C6BF370F35C07A769D40C0C2713F87BF953E818D06BF2A9C84BFFB45BC3E701389BF7F205040D2A43EC05B3455C0BCE08FBF6322F23F998F9BBEED70B53FCBAD974057DF80C0B9170FC0F22E813F5E5FEE3E00540D409DF16E3E8ABB274018E715BF61858540B421FF3D73A3AD40B1D55940EF5E404043F907C0779996C06553A43F27E7CF3F262354C00D6022BE4C1D3ABFF537C53F14F3CF3FC2BF403D1DF61CBFAAC880409711BDBF3C85F8BE626DA9406A59FBC0274CD63FA8A88940E97B92409069FABEF8E8B03F18E650C0C65690BF0CEB5AC02CB39C3EBF6CA93F9A5A1940CA37673CA8442A40F1DAA2BF5DA99CBF4E809E4084F7E33F1A5D6CC0D916363C170DABC0E4FE7C4097375D3D9EFB28402EE2D53FC81A6DC055EBAD406F8497C0A80D014092B8B23F5ABE77C0EABE4AC0C28887406206AAC0C0916F40E2F057C065AE84C0E84BE1BF5E0FF33F0931FFBF1418B03FCF6346C0165C16C09B03E9C048154F3FC48A4CBD4A1DC3BFAD3B743F96DBC63FA12B1E4004F5ABBF652B094099D8C4C092F6E73F85E4A83E11991840C2ACD3BF18AE16BF16D67DBFE9FC3CC0C8AD6140D8EE913F626984409E04E8BFA8C6E8BD3F9440BF96E67EBE2AB55F3EBE93C640211008BF72F342400CBD8FBEFB7B15C07203BE3F484F75C06CCEB73F88976B402FC1A6408012A5BFB094994046894C4098ACD6C027D0B2BFF49DEB3FDD2848C07B37F73EE0FC18C0E3DA94C042807FC05D7A1C40DABF3FC09CF94DC0B0B1FCBEC643953FD7EA2E40A6D2C6BFED5FB43FD53DA73D6991C6BE8EDE7DBE20E590C08D4F3440F03ED1BF179B1E3FC44B07C03B4DC0C06F45B5C0C9849F3F92848940EF4A50C02B26394057610F4004D497BEA46876C042446EC0D6899CC077B6103E1BA498BED81697C0FBB0463F3AB7A34045AEA1C07154C340FD901240564EA4BF0B790BC0B817E540EAE189C02A219640786144407C24F0C032F257BFD57928BE6FBFE13F3910BA3F65060DC0A07DA43F703FA9C093F9ABBF4C8DC0BE107FF1BF07B3CDBFFDB558C02C3F973F9D8EA0BED5E60AC086FBC0BF0F71FEBF4C6D4AC010796FBE7A65EF3DB97104BF501583C0B8F80C3FEE558B40EDD1B23FB31D71404AE0BF3F854D023F87FC25C08F19CDC0A7B888BF56E0E4C046BF58C02FB00A40D0660AC079706640C7A402C0B6D4E0BFDE41C3407CF39DC01FF0A2C0AF10F94011B592BF6728D9BE5D0625405F7307C03B1CD23FD75C17BF1186103FD5903040D57B8EBF3A861AC0846728401365C73FF91F8AC04172EC3E1B3419C0501011BF98FC27BE6C1D23C014EA48C0F35A95C0DA3F193F734DB2BF575AF1BF01638C3E61DA453DA38A22403AA83A40E8BEC3407B45FBBF674B0B407644DBBF275F8E4069F9533F3BC5A3C093B9C0BDEF721BBEC518D93FC12D064047FBB440D76D77C056316F3F293DB63FC390114023E151C06343823F11D71340572B0BC0D90694C06D279A3FE9B4E23FFA7428C027DA0C3FABF688C0598BE1BD33B6503F54E886C003F776C0EC28E3BF9DC29B409CAA2FC0BA8E5F3EA89DB240BF93B140B2809D408F2CA9BF8D1A5F3FC6378D3E6EE0CA3F42B1D2BEADF27CC02F8028409BBB163E35EDAF3F7F7DC4BF684A06401CC40C3E83BFB7BF6696673F055174BF5EBFD6C0B43181C0FAF780403CA4113F1DB8A1C0C22EC53F2E2913C05FBB5DBE9A58A8C01C634A40FAD41140465E7F40A6E005BEDB7C10C02712CC3FE3C347BFDAC48EBF828321406CB7A3C01E740FBFBBD586BEA3A98E405DCB96C0EACFACBF362BACC0C3AAD0BEC16642BF0C3F74403F669040D88D083FADDA91C0D16BB93FE044F140FDFDF9BE054517BFC8EEBDC0555B08BFD36FCE40BE21453F0CDCD13F027E1C3FFE9675C0FDF1573F4D5851C06D580AC0814EE3BF402CBA4072FE8DC0B4C9A33F2FB253C0EECC4BC0FFAAA6C0F05CDA3F96F026C0B7E6543B09B4F2BFF2F18EC0273984BF34EBE83F40756E4057DA30BF1D738AC0BB7822C080F028C0DC85E6BFC087F43F36357F3F6566E8BE3EC0FE3EBF8202BF2070A840030907C0079C243F9FF4CB3EEEA45B3F04C985C0A1423CC01BAE9A405555314073DE08400FCA32C023FE8240343FB740C830CD3F413B484070B1C3401A079940DE1E93BFC2BD44C0517390C0E3909DC09923AE408919FC3D6E093C3F1B4B9E403A639540AAE300409C5382C06C9A7ABF338D48C0CB6A4CC056449F3F627CBE3F3312E0C013F11CC0C362D03F4B205A3F70F371405B073D402044153D24933E3F7FFAB240"> : tensor<20x30xf32>
    return %0 : tensor<20x30xf32>
  }
  func.func private @expected() -> tensor<20x30xf32> {
    %0 = stablehlo.constant dense<"0x309D6FBE4FF036C004F2C2C0CB9476BDA50DDA3F51ACAD4094E85440B3201040284FE83FC58CD33FBAAC913FE9FB5140DA4F164065A73340CD5847401C56A8405F0235409B6357BF7AB0103F64A9254010931F3F46E58C3FE921D23FA5A7DD3FD3DFE9409E729CBE3DB3B83FAF7F4AC066E610C022AD6FC07D3A8B3F76F35FC061A7DEC01865383FD5E63040593F923F473EBEBFDB832CBFC0AD06C057FD72409BD06140CCD872BFFD766EBF83CE29C0EBA2FC3FA1E4B7400D85A14007E60F3FD047D03E8952F0BF80721AC039FB0FC0ACB57EC0930EA6404EFCB240E42BDDC0756583C0A4C76940D553B13D9489873F7522D7401E7538C033FF734018EAEE3E08A3AAC0E47A26C06F1430C0F377BEC0C2E4D93FF900953F84D40E40535408409D71ACC0DD8F8DBF951F413FE616B640DFD8E4BF360DCD404144FFBF002EB93FCE675940D629CB3E12F083BF93870EC0BA4207C0335E09C0A85996409E4752C093A42540C2814D4089F382C08531CC3F6D6F243F74039CBF12F20040724F58C03FF14CBE8A2385C07DA528BF33EC8CBF113C8D3FE2C80DBDA54894BF9457A6C0BF50B63F234CEABFC51C4F3D071F7FC030543F3FA88982BE37D822C09BD0C0BF8E3DF3BF091B3CBF73612F406D823EBE481A61C07C32CCC0BE4C863F69DC303F1F1280408052DABF227D8B4021EB46C086276EBFFCD87EBF449033408D4587BFFC503340603D35BF3E7358C0D7E69B4099FC23C028469840EB176CBDE7C451406C64C4BE48B8A6BF0D320540669C8E3F36DAAE40296D463FE5150DC00D0A2941074001404AFE49BE018D91402532933EA5186DC0051D9C3F32580840F8D789C07F548B400D86CF3E663F6F40B20686BF79DA9840CC5932BD74511AC191CA9F3F349942405EB24540D08008403EE1313D1D7F02C06B47034052E6CDBE04F9F33F9C5BABBEAC91ED3E3BC410C063416E40585283C0B8C1CFBFE151AFBFE54E5CC00F0553BF45ABB63FD50E9A3FA86A0A3F12D11740324D6CBEEF0532BE2F0425C03A6653C0468D2FC09C4C0ABF2B28FC3F5559993F60150040DAC994C04A03C6BF370F35C07A769D40C0C2713F87BF953E818D06BF2A9C84BFFB45BC3E701389BF7F205040D2A43EC05B3455C0BCE08FBF6322F23F998F9BBEED70B53FCBAD974057DF80C0B9170FC0F22E813F5E5FEE3E00540D409DF16E3E8ABB274018E715BF61858540B421FF3D73A3AD40B1D55940EF5E404043F907C0779996C06553A43F27E7CF3F262354C00D6022BE4C1D3ABFF537C53F14F3CF3FC2BF403D1DF61CBFAAC880409711BDBF3C85F8BE626DA9406A59FBC0274CD63FA8A88940E97B92409069FABEF8E8B03F18E650C0C65690BF0CEB5AC02CB39C3EBF6CA93F9A5A1940CA37673CA8442A40F1DAA2BF5DA99CBF4E809E4084F7E33F1A5D6CC0D916363C170DABC0E4FE7C4097375D3D9EFB28402EE2D53FC81A6DC055EBAD406F8497C0A80D014092B8B23F5ABE77C0EABE4AC0C28887406206AAC0C0916F40E2F057C065AE84C0E84BE1BF5E0FF33F0931FFBF1418B03FCF6346C0165C16C09B03E9C048154F3FC48A4CBD4A1DC3BFAD3B743F96DBC63FA12B1E4004F5ABBF652B094099D8C4C092F6E73F85E4A83E11991840C2ACD3BF18AE16BF16D67DBFE9FC3CC0C8AD6140D8EE913F626984409E04E8BFA8C6E8BD3F9440BF96E67EBE2AB55F3EBE93C640211008BF72F342400CBD8FBEFB7B15C07203BE3F484F75C06CCEB73F88976B402FC1A6408012A5BFB094994046894C4098ACD6C027D0B2BFF49DEB3FDD2848C07B37F73EE0FC18C0E3DA94C042807FC05D7A1C40DABF3FC09CF94DC0B0B1FCBEC643953FD7EA2E40A6D2C6BFED5FB43FD53DA73D6991C6BE8EDE7DBE20E590C08D4F3440F03ED1BF179B1E3FC44B07C03B4DC0C06F45B5C0C9849F3F92848940EF4A50C02B26394057610F4004D497BEA46876C042446EC0D6899CC077B6103E1BA498BED81697C0FBB0463F3AB7A34045AEA1C07154C340FD901240564EA4BF0B790BC0B817E540EAE189C02A219640786144407C24F0C032F257BFD57928BE6FBFE13F3910BA3F65060DC0A07DA43F703FA9C093F9ABBF4C8DC0BE107FF1BF07B3CDBFFDB558C02C3F973F9D8EA0BED5E60AC086FBC0BF0F71FEBF4C6D4AC010796FBE7A65EF3DB97104BF501583C0B8F80C3FEE558B40EDD1B23FB31D71404AE0BF3F854D023F87FC25C08F19CDC0A7B888BF56E0E4C046BF58C02FB00A40D0660AC079706640C7A402C0B6D4E0BFDE41C3407CF39DC01FF0A2C0AF10F94011B592BF6728D9BE5D0625405F7307C03B1CD23FD75C17BF1186103FD5903040D57B8EBF3A861AC0846728401365C73FF91F8AC04172EC3E1B3419C0501011BF98FC27BE6C1D23C014EA48C0F35A95C0DA3F193F734DB2BF575AF1BF01638C3E61DA453DA38A22403AA83A40E8BEC3407B45FBBF674B0B407644DBBF275F8E4069F9533F3BC5A3C093B9C0BDEF721BBEC518D93FC12D064047FBB440D76D77C056316F3F293DB63FC390114023E151C06343823F11D71340572B0BC0D90694C06D279A3FE9B4E23FFA7428C027DA0C3FABF688C0598BE1BD33B6503F54E886C003F776C0EC28E3BF9DC29B409CAA2FC0BA8E5F3EA89DB240BF93B140B2809D408F2CA9BF8D1A5F3FC6378D3E6EE0CA3F42B1D2BEADF27CC02F8028409BBB163E35EDAF3F7F7DC4BF684A06401CC40C3E83BFB7BF6696673F055174BF5EBFD6C0B43181C0FAF780403CA4113F1DB8A1C0C22EC53F2E2913C05FBB5DBE9A58A8C01C634A40FAD41140465E7F40A6E005BEDB7C10C02712CC3FE3C347BFDAC48EBF828321406CB7A3C01E740FBFBBD586BEA3A98E405DCB96C0EACFACBF362BACC0C3AAD0BEC16642BF0C3F74403F669040D88D083FADDA91C0D16BB93FE044F140FDFDF9BE054517BFC8EEBDC0555B08BFD36FCE40BE21453F0CDCD13F027E1C3FFE9675C0FDF1573F4D5851C06D580AC0814EE3BF402CBA4072FE8DC0B4C9A33F2FB253C0EECC4BC0FFAAA6C0F05CDA3F96F026C0B7E6543B09B4F2BFF2F18EC0273984BF34EBE83F40756E4057DA30BF1D738AC0BB7822C080F028C0DC85E6BFC087F43F36357F3F6566E8BE3EC0FE3EBF8202BF2070A840030907C0079C243F9FF4CB3EEEA45B3F04C985C0A1423CC01BAE9A405555314073DE08400FCA32C023FE8240343FB740C830CD3F413B484070B1C3401A079940DE1E93BFC2BD44C0517390C0E3909DC09923AE408919FC3D6E093C3F1B4B9E403A639540AAE300409C5382C06C9A7ABF338D48C0CB6A4CC056449F3F627CBE3F3312E0C013F11CC0C362D03F4B205A3F70F371405B073D402044153D24933E3F7FFAB240"> : tensor<20x30xf32>
    return %0 : tensor<20x30xf32>
  }
}
