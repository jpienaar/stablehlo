// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<1x20xf32>, tensor<20x20xf32>)
    %1 = call @expected() : () -> tensor<20x20xf32>
    %2 = stablehlo.broadcast_in_dim %0#0, dims = [0, 1] : (tensor<1x20xf32>) -> tensor<20x20xf32>
    %3 = stablehlo.multiply %2, %0#1 : tensor<20x20xf32>
    %4 = stablehlo.custom_call @check.eq(%3, %1) : (tensor<20x20xf32>, tensor<20x20xf32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1x20xf32>, tensor<20x20xf32>) {
    %0 = stablehlo.constant dense<[[0.508456588, -2.72562289, 0.890797555, 3.9900794, 1.49061656, -4.04238844, 5.16283846, 5.39239454, 1.1640538, 3.72014785, 0.739089548, -4.04786682, -0.677442729, -2.34983659, 1.91133344, 4.39299631, 1.66829884, 0.706630885, -0.10670419, -6.579970e+00]]> : tensor<1x20xf32>
    %1 = stablehlo.constant dense<"0x9A40153D58E091BF705255402DFC48C0E69CFF3EB23A87C068D8BFBC5EE2D5C072E12F3F65C5C5BFD48B5DBEDF44864017318D40E2FB8140584C3F40783126BF943AB2403EDE9CBF1496A13FBEF02B3DED2642BF60206F40CCFC8DC0A6D399BFF00BD2C0CA717C405BA5A2BBAE2C924063FFD3BFE8BE9E40A3568BBE5F73844075CC8ABF8B89A4C0415BB9BF71DE97BF74AA32404E0D6AC08CB68A409963CEBD9366C73F5F972340D2202BC0E097973F13C5693F69152A40CB898F40B94C94C0F9AB824089C65040F62601BFF6A72E3F4EF514C0141B2BC0EC702B40743FCF3FD0051B3F297A77BFBD548ABE0E3C3C4006F845C018DAE2BE83BFDDBF679472C0BE875A405B9A984050098740C1D8394085AD1BC087C94EC0D9AC37404D5E883F1D1179C0441801BF8D28B04030082B3E72465940ADF9D7BF3D88DDBF60C611C0640F8A40389091BF548ABABFC1D058C089D9823F30A812C04743F63FB68CA4C0EE6F05C07D879B3F2C9661C089BB4F3E01C06EBF293E22C02CC687BFDE37C340B93A2B40CEE5C1BE0B78C1BF7E6847BFDA28003FC16C8B3FFB9E0BC06C7D723E0F2C8DBFBED76A400EE682C0C5F605BF4BD0C6C0718287C0A31987406A16A6C026168540CC9011C0FBE03840FFDA1840EC697C3FD531D23F19CC1A406D2B14C0AB24AC3F7E333040837AA34043AA2640EBFA5F40CB48BC4094DCE7BF64532BBFC4271B40EA291C402BEC30C002D2FB3F5288C63F9C0B9CC09E4EBFBE016F233FDBA2A5400E67AAC0274B38C028152F405507C8BFC97DC6C06E461DBF6B66B8BFAAD7523FFAA67CBF90280041588BDA4067DA4B40ACAB23401780D6BE4C4E81C02B7AC5BF8E1A4ABEFC95C7BE4589E83F5574C83F442E8CBF3258F8BE5DE93240C6E65FBF4346824058F315C0076EDF3FE06481C04CA6F7BF7BB9B04076CAA4BF3D9F18BD6AC1B83FDA6A4DC078410F3F37D78CC0B72E9D3F55C48840251DB7BF0BDCABBF8222004019485EC06B8B68C0C0A792C02ED3BBC0100DDEBEECDEB04029EF2B401F72C23E66DE89BF6268AE3FB666BF3F2574B6404DD9684078762FBFC6BF02C0D305BABF66A91B40B8A81A40A18886C03B668FBFDDE857BE29BC603FAD4EE63FDEA864BF36C0DBBF4141BBBF96F5CDBF7704A7C080CE85BF8519A13F4EDBDDBF7D99D5BFC1BE8FC076C9F6BF1F5E79C01DA594C0E70583C01E6C1A3E659545BFB2B3B3BEEB3508BE150CCFBF1ACD95BF5C0B7040DDCC9C3D2BE47F40A8A5A4404F82FA3F2CE9B9C0EC035AC0D2B6214094251A4073344B40AA1F14C023A7CF4047D45440A41835407246043F79C48FBF2372C13FCBC648BFEAD55DC075E5713F946049C0D0F70FC02C3D844069AB93BFA1BAEBC0670B14409C0E5F3EE8859ABF7EA7F0BFE8CB8AC0E90D353F5DCC81C0E85588C0D96498C069A3EB3FCC76024045AFBDBF0AD1EC3EDFA720C0CE0177BFD2E21E40938C9C400C8B3FC048F67F40FEF88DBFEBBF88C0637ABA3F68B3DD4007C3D03F3395A1409DEA744069D61340A42630C1EFE2F6400295A83FDC85F53F389E823F90021FC167C40040D5ABCF3FCE06A740024173C0BB3E4F408625CE40E38C0DBFC3970FC08323D6C0846DCFBF0B59B63F9C7EAF3FE3E78B406D7C34BFAE6C06C0958D6D3FFAA808C0F7058BBCD1A6A73F7B592E409906F9BFEEAEE9BF3F5E82BEDD3D56406EF37240051AEB3FACC11540F48EDC3F3CDB40C020D594C0E401CEBE0F810C40FF08823FBD0F12C05615C43FEB0E9EBE3F7580BDC292A4BFE264CDBF7DDE64C04ED67BC0E613B9C04BC2423F07556B3FA4270D3E740D0F4065328C3F120023BFA01890C0E96670BF51AD1A407F3D93BF243EAEBFD6F96FC00549B040D90E74C02005F53F2C35E63F5E0CA0C0ED8BD93F69DCABBFD2FED74069FD87BE50947CC0693131C026C933C0D4BBC2C06F1AFB3E01311BC0DB04833EC86D03BE32538240CBF02A40AAF796BDE3928F40B0C37240B1236BBFAF2EABC034BD023F226C9E40661E84BFA2BD23C06CE4F53EE8D38C40F9778740D743E73F40698C3FD4B4203F9D1679C0C5AF903F6ADD1840450F6740F637CC3F507209C00D9CBF3CB4F7D4BF8F278F40A147A14078DE81C026C4D440C6B165C07C1F21C0FB7672BFEC83F7BF804471BEC6F55CC07B30AD3FC0F52840DC662C401E2923C0A74970C09B56C340C1521FBF359FD03FB7EE87402733FEBEF9DED8BEA24357C08E2D46C02654ED3E916A7CC0"> : tensor<20x20xf32>
    return %0, %1 : tensor<1x20xf32>, tensor<20x20xf32>
  }
  func.func private @expected() -> tensor<20x20xf32> {
    %0 = stablehlo.constant dense<"0xD5C6973C4DCD4640D8063E40917C48C1AA823E3F8EA98841DB9DF7BD252B10C20ABC4C3F35EFB7C013BE23BE33E087C1754C3FC072B818C13DD1B640868536C062AB14411CB25DBF79EF09BE9B6B8DBE8F6FC5BE30F122C1D7F67CC0FB7199C0AC8C1CC1A31E7FC1BCEDD1BCC40EC541D0C6F6BFAFA3934197F74DBE210986C1690E3C3F5F514141962331C036CAA6C0B40895406B6325C0FDD1ECBE15C1293FEFC54A3FB0F1DEC0CA7018C0A0379740083BAE3FD3E22BC12644B94131ECC7C1E51B9840412B4241FAE8BEBE04BF30C043D2C93F0A09C9402FD7A3401A9CE340E64F813F02E02EBF002BEC3C7ED29AC12F51C9BF05949A3F5C88C5BF62FA71C156DFA24059389AC1F24AAE41288A7A41A43735C0DB5140C19EC0074010008AC081BA284003AD973F46592841F2D53B3F6E3DB540649D98BF781B3D3E72CC6F4129650C401B604640702BA6BF184758C1FB0BC33F0C36144148ED1E4144D4DDC1FF531BC0E0A590408CBA26C0EB3752BF4DBD213F3F9FBE403AC101C0F365D641B5D48E409B0389BECC26253E3103A440C153823E7E023EC085BFF8BF76E3713FF86ED2BFD6546DC1C0F3A8C1BB9834C0066EE7C0C90E7CC1C4B347403813A841265134C01707AB40BBAEB04095DF2741018DD23FB087943FDF2384BEE9BC7341020E2F3F0221F0C055A09140714026412CEFA6409547BEC10EA215C1C9F666C0F29B3440F03C1141F8C202C074D5FEC0917E86BF2D57374169D336BFA67D3340512A0A41CCD270C0B5519D3E3B0190C169694BBFCE408741AD190CBF57F1B7C082249D3F63547F40546A2542454F1342C84B6D403E381841F4889EBE6CDA82418EC7853F9374ED3ED2BC3EBFF761FF407D352740B01C46BFC6FE533D732793C137B0E3BE1E8A31C15A9305C02BE0DE407DE0C0C02346FA409D19E4418327DEC006A931BD58D4AB4064D217C054F810C0B0D23E4034AD38C01FB40241C81AC9C0465B0FC08816B53F3FBFBD3E5E44BF41BC2215C04FF87F4171CDC5BEA06EB041DD248040A081C4BFD2F2B1C06D1EEB4023CDDE3F4DB0A9419C182C40FF8F31406B26B13FC18F5A40BEC29440ABDA29414371E0C02AA94ABFC54EB83CFCD7B8C0DB336A3F5BCF1B40E5C0C3BF5DCABAC0D18019C08FC9A8419DB4ACC0A32DD940652001C0CEA7C6C0267B54C07DBDF940ACEE28404DA52E41C26DFAC01C98293F71D0A4BF44F77DBE438C683CA84B2A41B55518BF4F9123C162AD8B3DB3417F41FA6CF540E829FDC0F7F4EFC1FDF392C1743E3C40BA5C0F41C52F164070E5154145AC8CC0930EFAC05211AD4066451140DCD8EFBFDFB1883FBC63AB3D7E75B641D0FCF53E39380941113F00C036E98341641EDCBF213AEE411F153F41FA59963F88DFB3BF3FD1DFC0852A4DC0913837C0A0DC2F40E32E204148A311C1116501412DA759407B0986BF91274ABD852384414A2FFBBE1C88D8C01D748B406F113FC148C5BE40257A8F400E81B0C10E64FB402C090141FE27C2402CD96E40E9D877C18D4DC8BF85F6CE41F1F06B412525B94083CD4C40F598383F7DBC873F32D253C1002F533F30A063C1A5B058C026BB4E418BA41941E50C0F402E5639C10E5710C20575F1BF1897A940CAB4813F7C948DC1B489F43E16F09D408405E33F381616C1B2EEE7BC86EF6C3FA3D494BEA0D24C41BAA26DBFCEAA313F90D83E402D59724124392F40F15717C1A3560E41A6FE81C1C23FADC03098BFBFB6B0CF3F5B9783C086E5C53FC56166C0100D17BF31148DBE594709C0472391BFCE5EC33E9522CF413E353CC0BAB504C020A2513F05CE0C3F8B3C5540BBAE8DC0D26252C08141C2C1A1EB8BBFF8DA0F41BDA559BFEE53B040E8912240E91E4FC1F53CE9C0E88B064112074040AE3062C07FB439BEE25A0D4108A65B401D54393F40FF60C0E8C030C1EDFE85C01DCCC441FA0C22409E3651C15C83983EA477F4BEC7A4404077FC2CC1288B4C3DFDAF28C17A00E840EE1E81C0ABCA0EC1BFC4B83E133C07BF9755D9409882A6BF6A8DA7BFE6E57A40F62187411D5D2C402AE68DC0DD6C4F40D8E5A7C1496CA83F862B0E4116C62A4094A9CEC06C39BA3F272061BDAA864BC026389D410D880641F78937C0D69F35BF3DECBC411CD9A3BF853725406D7CDCBF51AB70BFF0AEA4C05206AFC008145A41256A684180ED3DC0F8795FC15C5F9040D63A214053548DBFA6B51FC128EE72BFA92DEEBF0090B3C0E6090CC07C974ABD879CCF41"> : tensor<20x20xf32>
    return %0 : tensor<20x20xf32>
  }
}
