// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<2x3x9x10xf32>, tensor<3x3x4x5xf32>)
    %1 = call @expected() : () -> tensor<2x3x6x6xf32>
    %2 = stablehlo.convolution(%0#0, %0#1) dim_numbers = [b, f, 0, 1]x[o, i, 0, 1]->[b, f, 0, 1], window = {} {batch_group_count = 1 : i64, feature_group_count = 1 : i64, precision_config = [#stablehlo<precision HIGHEST>, #stablehlo<precision HIGHEST>]} : (tensor<2x3x9x10xf32>, tensor<3x3x4x5xf32>) -> tensor<2x3x6x6xf32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<2x3x6x6xf32>, tensor<2x3x6x6xf32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<2x3x9x10xf32>, tensor<3x3x4x5xf32>) {
    %0 = stablehlo.constant dense<"0xAE384540D8CC3CC06C47F93FAE97BA3FC2C1A6BF21E21740B85C4BBFAA844F3FF9630640A6FE36C02E2B1EBF12BC533F544179BFFC6E81C0B9E58040D641D7BC20EECF3F6EA33B40A9EB2F3D1826164054C44FC00ACB33C060AAD5BF416A3140C256093EFC64583FB86C40C0AA12F1BFEECDEA3EEE75624038C8843F751AB9C0FE51ECBFF9148EBFC7988D40167770404109A53F6A1E34C06AFB2140D29C164096488DC0CA9BBBBE0A913DBF25061240916904406BC7BF3FF81D923EDD3E623E20C92040C475D540D47F15BEAA1F8F40B6BA3340C2EBFDBE5A6C02407063F23F3AEC9FBFC69E3D40D5EB02C001949BC0E2FAC5BF2B02F6BE915236C0B355A4BEA9060040FB43A4C000934A3FCE5D13403674E53F4EB003409174E3C0E8E3AA3FFFE7F3BF9B3852402F177FBEF34C14C0F4926640CFAF91C0AAB1FEBFDEECA6BEA04B04C0519A1C3FF5FA12BF4C6F6E3FE2DF5A408112913F6D7C6840D2019BBF7385713F59BA5340AD717B3D68D2F43F256D843F0D8182BED704543F37EE93BF69CCA03E7ED16940E8569740BB253940F27CA7C005CDF6BFD5DE59BF9C6A09C0284F6AC0309626C0E6CC36BF7BC16F40EBE7244085739BC00DDDEEBF404E3E3F06DD8240898C2B4069E3DF402305EE3F880ED0C0FE27A23E46715CBE999A0B40F6D07C40500BB6C08F00CE3F1637563E21CAAABE5DCD0BC01FE08D40BA25C2BFD95D34400593FEBFC4EB9640F5C26840521517C0FE3CCDBE4D4BC8BF8C5D66405A3F0040859E82C0B938CEBF0C4ECE3FE76D363EAAE09EC01070AB3DBEAECD3EF0E98FBF4848833E5E4B15C09F28F040B04BABC0BACE1DC0208F21BE06CC584042628EBF02F862C0281EFB3F3F625940C91D2D40D80553405407A0C04E2659C05A1CE240555B85BFA6DA4840602957C0322BCEBFCF698F407090BCC0D6FF2D40B75523406BF978C015763440EC1046405F445BC065635B40AA6DF3BF5B2C3A40F7D4703F5B113F3FBF0EEBBE79F5B340D9336D3FD7825ABF107A50407C4F70BEC11D2840AC29C3BF17050941E811A4C0E1AF85C0A29423BFBC67DDC0CE8706BE948D8CC0FAF93CC0E44C63C05E9AC8BFB1AF853D93F29FC0EC0294409F3D99C07D2D2D40DD3B28404F9F3AC0EFD5233F6FD73ABF648EA3BFE2BD33BFE3B129401AF505409BAA58C05C7AA4BE314747BE5A7AA33F3B02BCBD821896C05D9E75C0120BD1BF6EE4E240DC2CF83F88EE5A406158903FC08F1ABF30B978BFEF2A4ABF28D66540F177C44041881D408988D0BF97F37BC0789A5EBF814307C06846403FBFE8ABBF9ED5934051E69BBE65A6F3BD0B0DDE3F239D2840FC9322C0D39A51C0043A92BF64458F4048D9EDBF1549BD3E2CEED2BF29A88FC0E0C569BF31D77540E0A06F3F815130C03881B5BE92BC803FC193EF40B5CA1BC0DACB6DBE889B0C400D9CA7BF7BB8A43F1BC289C0B77FAA3F3D5C67401938643FF22B11C0416480401BEEA63FC70F57403380813F1E9C3A408C3F8940C296343F9AE596C0A41FED40CD349DC0AB6509419E516FBF5AF21D3FF0EE99C0B20810BE25663840AF21F53EE0E733BF63ACF0C0D1CB5940B3678F3F50FE9FC0176404C136214CC0148DB7409D1F1D4052CA87BEFBD93140D00B963FA7AE78C021ABCABF686055C025FC3840F0289540CF446640FCEC864092B91DBF535841C0B57A75C01C1F98C05AE3C040B12D8240D6613B40EE3059BFF458803F6BBDE73F40AED93D04CD5CC05A6571BD84CA7E3FD729DCBF3E9D513FC50E86405E1455C095AEEEBF16CC423FEE7428C0113A1E40AB815140C34A5FBEE8615540CB4C3A407C10753F36C86BBF9A71623FAD4C45C06F2555C0DE9D62C0A2647F3F1480FABFD3449B3F06C41BC0A4910FC0B52287BF88C19D3F7176E73F1140093FB8A8A53EA43A75405EB27540301419C08F5BF03E04877B40DE753340347B9E3D38ED973EFC247E408209D83FAD8ECDBF876B603E1232ECBFD2E738C0FCAA5440479133409A4EBB3E54B4C0BF5DF4CEC04D4B16C07BBA004009F2D33E8DE5E33F96D315C05A86FD4084F277BE9113D8BF0E47C33FDC3BF7BF8F118FC0E7FA90C052ABF8BFC925A43F04BB8DC0EBD077C0A6A537C0655F49405F88853F0C78853F11209CC0B7E68D406DB80EBF61384EBF1D1653C038576F40B0BB8A3D2454FA3ECA3756C0DE412DBDC9E6EE3F619D2AC029669EC0E8F7C5BF0B0567407DDF1DBF49A32AC04F5A0F3F9734AC3F56EAC9402779A33FC0631FC0681B8C3F477EEB3F8DBF2DC0D8AF3EC0BB4F7C3F57AE53BECBAE2340DBA898BFC6DD51C0497D16C04D7F15C0915604C1677B7EBF7DC654405ED0EA3F2AB733407AFA393F70BE2240AF7B89BF3613E33F37E4013F5CCE76C0DFF1F7BF41A720BF36A1DEBF65128C40EA2995404852B73EE39749C0AB0100BF091A51C02C65DE3E8A6CD140298D1CC08399173FF6FA863F589F3AC03F59FC3FC2EB74BF1E285FC07BD653C0F46692BFEECC4EC0CCE359406ECF973F46758140E86C864092376C40CBE5C5C020F593BF8301D43F821720BEE51427C04296CA400A87C3BF4F664BC0A5FC82BE08D48340884D903E13139C40B562744038ED323EB6B6713F925BAF40A2FEA93EEB5BA8BE441CD4C080B380C00C167F3DC7010340E4BA3A40065D9FC0421EDD3F604CAB3F8D0BDAC019308DBF16AE0A40F44A2EC0A5621D40818DFEBF19AE13C0575543C07FC0A83FC48AB0BF3754FCBFEE6EA8BF13F57D40DBDD4BBEC74366C0B17B51402BCC2E405481D23F800716403FAAC73FA74A4A40F6B1D4BD830DA03F900EE44092B68D3EE5180DBF6563123F3257133E27C60D4063E3C740796126BF0739CABF3476B8BFE0E31A3EF1DED13E90A4E5BFDF04A43FCA6E9C3F623CA7403A72A24068DEBB3F050AD2C07770AE40D2425FC0DFD6A140BFA5CD3F89E848BE660DCBBFA8A273BFD371EBC0B2651B40F497DCC0183251C07484BF40F236DB3E96DC3F40687BBA3F5DD697BCB53F58401DAFCB3D54035C404DCEBDC066F45F408C49BBC0"> : tensor<2x3x9x10xf32>
    %1 = stablehlo.constant dense<"0xB8369040581F33BFC74CF7BFE159893F010F3340328927C0212C823D4E48183F283483BF5C86C8C00016D13F0C0002C0BD2F6940D725B7BFD32DA63F1927A440358066BF713E24C0598AB5C025C10A40F75F1CC068B2B23FAB92863F09F2BD3E69CEC63EA1A288C0CA298140E0D195BF16598E3F51982440EE8D02406759D8BF212141C0AE243EC0CBB30F4029ACB1C0C2E3C4BE5F76B340D21FB4BF8EDC613EDBF9DB3F43050740F89F00C1BF803BBFE20351C0912E9C40992662BFD9FDA5C00D610CBF3E2D32C0C248D63FA5E26AC08306E43F1A8A6AC0CD3B22BFBEB1C63F184ACABFAA05164019030B40312CC540B25563C04C0A85C064A612C0A7E07BBFB3A30FC006CC7DC0B7890FBF36DBB5BEF9F37240834732C023EA16C043F74240817AE73EA8A71940F94442401460C5BF700B61C04A5E93BFE63DB0C03C6C9240EF6E3840D76607BE2A59E3BEEFEE0B3F1237F03FC923D5BEAB228F4028790E404CAFCCBFA5792DBF5E0C96C048E4B13FF3FA7840DBC2D73E4CF8264085D27EBECB448BBFAE1B1EBF7EE60FC02CC47F3F2F96B2BF5E59863F833FD33FE257603D38300C3FC9341D3FF85814C0C62A9040929F9040914FEF3F07DC8BC07FEC69BFD1E1B440E21C45C0FDF518407A170F3F5FF0CFBFC5DCA93F700415C07BFC3F40E32C0B40E35CAC3FEAB7D03DFCC52BC086DD34BE79A4154138CEB2BF342BDF3F1A534CBE2D7A0640E82F1340197D0B3F3564B9409E72DE3F784B57C039EFC73F1A6A594044F9C2C0D13D31BF732358403C5283C05E99E33E6065F4BF63F149C0269B073F5FCAF83F1C0C5C40FB1112C031E009C0AC3D8540D16D62C099607BBF18D25440F09668C0BD07AEC04424B5407D7A13BF7498C53F87C1A23F85881DBEFA7EBEC032C20CC0D8441DC012EBDABEF49F9D3D0FE2F1C0357884BFCAA2E240D515C53E9A37CEBF0C7B0B4090BDA03B2A0AD2BFC0D676C014893AC027E4A440C882A3BEE974C8BF97D3A5BE5AF884C0"> : tensor<3x3x4x5xf32>
    return %0, %1 : tensor<2x3x9x10xf32>, tensor<3x3x4x5xf32>
  }
  func.func private @expected() -> tensor<2x3x6x6xf32> {
    %0 = stablehlo.constant dense<"0xE80894C225871EC266842BC3BC153E423CFDEA416DD32143CAE2B4427D849442FE7B41427E944A427509ACC114439EC27D80D8C16648B842C2D61CC162432042AEF0E4C24031D83FE08D01C2E76FB6C2F0F5304154520C418661B0C1774899C203000CC358F700C20D2270C2C62E2EC1E60CC9C1BB2038421698B1C1535CBC42A03DB4416DDBE741E19D3642901D5EC2B0233EC1AAA19641E8D2ECC13D7E6DC2856CAAC2A8ACB5C1DDBEFEC16D69A84200026B407CC35CC1C8C0D3C09813E341174239C2177756412EAC4AC132506942170C02C2FA55F441FA1E80429E373B42E71D814260915F41FB3377C21BC858C250B8EB3F82DC3AC2806D6441E0C7BA40066020C26CB14F4263282E41D14D6EC272D90FC3C4CF0B4164F6D3C150776442B4FB1D41F3337BC2DC1E0B4294ADA1C106D8B4C2E424F5C21A0BDB413E548941E85049407B07BB42D4AE864257AD9B4214744BC256641DC328A1EDC200601441F4D80443246F8A427BCA4CC23474814260F7024263AE0942130490424369D8424D6D25C2D0D2D5BEFBA7D842FAD3DEC284536DC277568E42C97C4542602DAE4060C1AEC2301FFF40246F3EC21B51A0423BABBCC265D72F420848274186FE7DC2CF9244425E4605439C81B641005646BE10509FC11BCFB2C254DA2043FAAE994220113EBFD65BC2411027FD4146FAB54290177841D6F499C1C8C96841D0381A4207520CC1B81B3C42AC68DBC1869FB641EDAFDFC2243CE5C1EDEE864020351CC36EFB88C15278894246D09142E175D2C07383C3C12A4B5DC235C40C430E0D8941E5168642C0CEF5C163EC3AC219B82B4156C25741EC6B4EC107680A42EB888CC118159142011D124268F00D4200F4FA4154084341EDB20A42AE69F8C0C16D95C23080BFC234B564C292518C4253380942A47BCA4163BA2E42C0D057BF88E3A8C2F9DF61428D20D9C2DA539E417CAA1BC2696C5041BECA1FC28A35224298A5FF41000AC9426F0FF3C2FB148BC13CD2F8C104E07142F4D17DC3129ADEC2BF64B842DEFD6B423F0727C33658B0C2AA31DA410ABD4142E6CB4242907A0BC37D63BAC217B245C203C7E0C2851EC3C2B1FB5942DA59A94156F1A742003001C22792DBC2EA091342F9139D42877C05411D3B8742DC066A419DD3BF42C432CCC21272A64170AB9F3F9A1992C2D21E05C2A563BB42106DF54112D59C429FC78AC2F09DD8C2"> : tensor<2x3x6x6xf32>
    return %0 : tensor<2x3x6x6xf32>
  }
}

