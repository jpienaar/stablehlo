// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x20xbf16>
    %1 = call @expected() : () -> tensor<20x20xbf16>
    %2 = stablehlo.exponential %0 : tensor<20x20xbf16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xbf16>, tensor<20x20xbf16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x20xbf16> {
    %0 = stablehlo.constant dense<"0x93C01B408540D1C0F5BF83C04040D83F1340A3BF18C036C0EE3FA03F48C0D640A24051C026C0E2BC074017C03240064028C087C0B33E213C51C014408D40DB3D1CBF75BF77BF1D402C40AB40CF3F3A406BC088BFBE3D2DBFBCBF27BF65C05A4060C0E13EF53E4D40FABD77BF6DC0D4BF8E3EE23F5740A1405ABF2340E6BF99C012BDCEBFDD4000401BC0B4C03C3FBD3FF03E073E03409BBFC0BEAC40C6407D40CC403C3EB6402440F33F42C018C1223F60400140ECC0263FC1404D403FBF4A3DC03F0D404EC0173F0FC014C04DBEB5BF6C3F743FBA402D3F8440763FDE3F343F08400D402B40F1BF294004C0DC3F8E3F1EC086BE2D4083BF2ABD193FA43F693E03C0E93F0D40BCC0A83EF43F1340A73FE9BFA6BFCC3E2E406840D0BE47408A400C3F6D401BC09D3F5DC08A3F55C0663ECD3FCCC0213FFA3E8BC08E3C25403ABFFFBF0CBFDE3F4FC08FC07A408C3E65BFEE3EAFBFAEC09C406C4001C1CEBF8C3E1BC0464044C02C3ED1BF874045C0723F40BFD43F2DBF513F4EBF464017BF3C4065BF504013BF7F3FF43FB43F52BE0D4102C0A5C087BFF3BF734028BF72C0A9BF953F973F38BF3CC06F402EC0E2BD0EC1943F59C093403740D2BDFA3F27BE5EBF253E8ABFADC0E33F8C402DBFA7BF6C3FD53EDC3F6EBE5E3F4D3F9F4090404D401DC06640AA3FA23FB73FD0BF03C0A2BFB4C0F7C0294025C0D13F07C093BDD03DE0BF864044BFE3BF253F4FBF033F6D3FDBBFA3C029405B3FB24021401A3DA2BEC33FB4BE29C0143F82BE533FF3C08CC02A3F403FE4BF46BE85C0C5BF67BF0D3E943FB33EC83F57BF51C0B640AF3F10C01B3F0640C5C056C038C0B1C0F6BF0A402040FA3F9F3F8B3FAEC01C403D3FFC3D8FC0453F2340B0BE044053C0993F98C0E3C0C2BF2F4046BF27408FC00BBF7D3E20C0D03F3CC0A0BD723EA3C0BD3F2C3FF4BD09401FC074BFABC050BF29408D3FA13F1F40D2C096C02EBFB5BEF33F39404640C23E43C0EE40A3C097407F3FC440AE400B40D13FE13EC5C03F3FAB400E40973FCF3FD03E0AC0193F44BF58BF4BC04FBF4140024040C0BD40A73E4C40273F01C089C04A405DBF7DC0BDC002C0F2BF81C0D13F50C0C73F4D40EC3ECB3E7040"> : tensor<20x20xbf16>
    return %0 : tensor<20x20xbf16>
  }
  func.func private @expected() -> tensor<20x20xbf16> {
    %0 = stablehlo.constant dense<"0x263C34417F42BF3A173E893CA141AD401F418F3EBE3D6E3DCD405F40343D49441E431C3D993D793F0441C13D81410241943D713CB63F813F1C3D2241A4428E3F0B3FC53EC33E3A416B415143A1409241D03CB13E8C3F023F6C3E053FE53CF141F73CC73FCF3FC541633FC33ECA3C433EA93FBB40E6411943DA3E4C412A3E093C773F4D3E7A44EC40B63D6C3B05408C40CD3F923FF840993E303F5843F343504213449A3F94434F41D640463D9D38F13F0442F040243AF53FD043C541F33E863F8F401141243DE73FDB3DCB3D523F793E21402640A743FC3F77422740B54001400641114167411C3E6041023EB2404240AD3D453F6F41B83E763FE93F6640A13F043EC6401141383BB23FD7401F416C40263E8C3EBF3F734116422B3FB3419542DD3F2242B63D5A40023D3C40133DA03F9F40DF3AF03FD13F553C823F5341F83E0C3E143FB540213D3C3C4742A83FD13ECC3F823E8F3B03432042A5394D3EA83FB63DB041403D973F483E88423D3D2540F23EA840023F1140E53EB0410E3F9741D13ECE41103F2D40D7408340513FD245063EBD3BB23E193E3242053FBB3C893E4D405040FA3E593D2742873D653F13394B400A3DC6428C41673FE240593FD73E963FAE3E933BBD409F42023F8B3E2140C23FB2404B3F18400F401043B442C541B03D11427240634086404A3E043E903E6C3BE93960419B3DA440F83D6E3F8E3F323E8442EE3E2E3EF43FE43ED63F2240393EC93B6041174082434641853F3B3F9340343F923DE43F473F1240043A4E3CF93F07402C3E533F803C5C3ED03E933F4B40B63F9940DD3E1C3D94437B40D83DEB3F02410B3B113D673D823B163E0A414341E2405E403E408F3B37410640913F3C3C0A404C41363FFC40183D53400E3C5A3A613E7641EC3E59413C3C153FA43FA83DA340593D6D3FA23FC93B8C40FB3F633F0841AB3DC53E9D3BE33E6041414061404041B93A173C023F343FD6409041B041BB3F433DD444C93BE0422D40E54366430C41A440C73F0B3B0740514313415040A140C03FED3DE93FEE3EDC3E2C3DE43EA341F4404C3DB843B13FC241F63F083E633CBC41D83E9D3C323B063E1B3E913CA4401F3D9740C541CB3FBE3F2A42"> : tensor<20x20xbf16>
    return %0 : tensor<20x20xbf16>
  }
}
