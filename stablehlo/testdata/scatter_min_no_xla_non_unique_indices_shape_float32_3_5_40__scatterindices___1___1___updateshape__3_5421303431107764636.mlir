// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<1> : tensor<2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<3x5x40xf32>, tensor<3x5x2xf32>)
    %2 = call @expected() : () -> tensor<3x5x40xf32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f32>, %arg1: tensor<f32>):
      %5 = stablehlo.minimum %arg0, %arg1 : tensor<f32>
      stablehlo.return %5 : tensor<f32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [2], scatter_dims_to_operand_dims = [2], index_vector_dim = 1>} : (tensor<3x5x40xf32>, tensor<2x1xi32>, tensor<3x5x2xf32>) -> tensor<3x5x40xf32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<3x5x40xf32>, tensor<3x5x40xf32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<3x5x40xf32>, tensor<3x5x2xf32>) {
    %0 = stablehlo.constant dense<"0x656A89BE632C8FBFEBBD0B40DCB099C00D703D3FD40973BF21213DC08859BABFDE84E44066B3A3BFA98E3E4055A7F2BB31A7B93E225977C0C83EB43F8A8C283FB148753FD20E8A40A5975DBF5B95B93E1AA4174034C53640575431C05D5C19C01F86ABBFAF23F43F5BF1E6BF69FA9F3FDD39F4BE4CF19840E60BC63F9D1B10C06AA5CEBFCF7A0740D14F7CC0DAFD9C40E30562C05D6F97BF54EB91C0F016B03EC23DB43F469622BD3101494037C330C0995626403434A63E54DD42408EEC183EF94409404AF8C4BFF06E8DC07035424068F02F3FF92525C070F54740DA74273F48BBF93ECA5A44BF45BE96409BE9243D9B7A1140561A84C0CBCC19C0CE9E873F3D46D0BF0AC1184090E24B402B43893FD403DEBFA3D08940CED541C0D69DE83FCCA9C53E4A7F0AC0622F9340BBED174090DE17C0937919C0F74A48C019A2B7401F52EEBEE921ADC0F91C613F71AC25C07E87D2C087DCF63E5B758E3FA4C75A40676E7F3DC8E8434028861DC0F7F0313FA4C330C0822F65C0790667409EEC49BFEA309BBFF31E14C0992194C08716303E7DD49040757871C0195A99BF798A4A40D87E893F961863C0BB933C3F448851BF59E1293FDEBC18BFA4BE91C01248B8C0B0CD8FC0B38FEF3F0EAE3FC047227CBFC6739940BF48F83FE2DD3EC0E7FDAD3F85780E3F51E631BFDEE685BF5B02A3BFDA46DA3F76A88140D17FA34005B10F402C59D33F075B9C3FF8020BC0C5F2BE3F9ACBDABFF1FB8540334818BFF48922406E65F63EB08C68C0ECAA1AC0093FF6BF47B3BDC016BE643FC80B2F3F7B57CB40DCF208C0FB2A1E40F1F5A840A40EB840ABADA8BE437FBEC0087B35BF1D9EFDBF542C533EC979C03F25A5B23F5FDC8E4076E40A3F8961AE404B5B31400DF21FC03E46FF3FC898B0BFA109163F8A53E2BFBCE29C3E6DCB5A3FF64705C09C4FDF3F4B8279BFC55D8DC0C415C33E3DEB12BFC3B77C3FD10A0040BEF9E1BF4F06C0BEA745DEBF9C0A603F154D553F340BBABFB850BA3F2D00773F8053B63EE32ED03F68D405C08C7C6EC0BC4428C0312FB83E2995ACBFCF3081407AD102BF88CCAE3FC39CBBBDFAA5CF3FEAE6DFC0E3016EC0D1EEC3C0AE168B3E1706B1BE28161F40FD1CBFC0FC840AC02497BF3FC81B12C0EC7D97C0B4C1B7BF139560402F4187406569F43FC22C6E3F6477D1C06B3283C045191DC0D4C6F5BE3A54B5406FE25FBF7A44FB3FF887BBC0DDA302BF5AA17C408A6A95BDEE4E8D40D71EDC3E0F0AE73F8354AD3EB54CD53FF3A6AE3FAD3771C077A1E7BFAA89F9BF7B568E40292A31C0FBE1524044343A3F400F34403F4F0DBF413EEC3D1026FCBFAD81703F4E34BC3F992910BF492483C09A0BA8C0DA486C40ACD0A1C0E2208640389542408230913FBEED09C08197F0BEEFEBD34007D30C40206D623F49559ABF0FAE6A40BA862A40954833C0F36DDD3DA378CBBF45981740D8AB0CBF125DA8C011EA6A3F1AA91040696689C05DFFC8C0FC108ABF84C946409901973F0565453E21617B401E8CB33F66C52B407A7AEBBFB89B5FC0B18F5ABFC21017407AF8BABC81A659C02E3391C0E016C3BF99E38A3F42183F40FABC003F4099F6BF64ABCBBF1E7635C0E27DE6BF09035C4053CDB9BF7E59673FB34A8BBF257397C070F5B3BFDE4C0AC0E5F82D4045FC41BFCF8E9F3FA13B10BFD84CBBBF729D7440DE9704C03C2DDABECCBF6640EB79544008F3673EECD35F3F24519F409B1B5A3F56CF57C00F2827C0015E414067ECB9BF1A9263C0215AB43FEBBD2A404C650740888B34C0ADAF2CBFBA21C43FEA9DF6BEE0C8303ECBFA8140A0FDC43FC25FC1BF2EBBA9BF6ACB693F978038C054B48C3F8E2BA23F03CB183F65F68AC06B222BC0C85700BFC4892A40128385BE2D5E30405B2E38C00C3D96BF720819BED1B371C05A7933BEE221CE3F0295693FE452593E19FB10407CAC9A40B5BF1E3F235847C0AEF2E9BFDAAB913F69F13340CB6207C0B0D09FC0AAAC8440FCCA58405E5D1A4035AE2240518B9C40C01905BFC97FC8C0BBF015BF159EA0C06CC82540E6392840F8ED5F3F454645BFE4E48DBFF6EB61407E0CAA40E9A4034009380CC02E50F8C02334E9BF755182BF5FA2E540985CB0406BFBC4BFAC59BABFB67EDE3F9A9C15C08EACA8C060275D40727370407163183F9919803F8CCC013F0E4BF63E1AE946BF3FD97CC0C90E9D3F10F40DC08D71F2BDF887AA3F574D1CC023B0A4409406A1C04452C43F56BEB8BFB69A85BF2A384FBE4D6CE9BF567B07BF41DAAFC0F8E233403C4EB43ECF2D0CC036DADEBE8515C6BF0EE1C5C099190C40555D86C0162780C0B3562040D50B17401EBAE6BF21E42E40355B86BD7954F7BF251A9E3FD507683F25AF1440E8AE98C064855B401BAFD13FA4E1D1C0A6E22E3E6B5C6540D57D39C0A17543407C912B3FE5B119C001671BC0FC94DC3FB145F4BFA365FDBF6A84A1C0178EC7409D0A1141E5678FBEDC50203FC98FF5BDA031323FF11EAC3F153D1E40F4DE63C0958475BE2878B9BFA57D3D400BF0F9BF9513D03F7AC28540EA6CB6C0A32170BE9A7134BFEB0C08404DFBC340A37E3B3E251F6FBF156D1F40AC3A873F1F151CC09F015EBFA13E16BF2313F33FAEBF4A40FA918F40B1401C40BDBBD340B31C76407FAECE40FDEAB1C01D8B96BE577C3CC0D0982CBFA3E157C0CA529E3F0D6E19C063488040437E8F3C3C5C6F40C9BCFCBFD94013407EBB36C0E3179B40AE51F73EDCDD0F40451FA2C065691F40957B39BF24824D3EA37E2CC0E296DABFD9AF28BF65CCBC3CBAC6A03F6AE11640EC53BCBE13916DBFB72904BFDBF356401BB1ABBF2CB071C05BC5E54003ADDBBEFB63D4BFA92EABBEA5BD783F70B5104009B3A7C0086D51C08A32153F0537AEC0643380BF123232C0A9A983BF4005BD3EADC284406B95ACBFC1E78FC0963E88403E0383BE8CB961BF445E93C09A5391C09FFBACBDA73D37BF259F4EBFAFC319C03727914006FEB4BF326A424092B7253F0E350C40519DC6406FB5E03F5C5990C0A79384407E3DE9BFD06194C0B3B08040C6F482C0CD12B13F9AFDEC3EF93702C09F09143F8EC167BF1A45B53F2FFA6C40FF0986C04BED0E415576F3C08D9712BFCD568D4032A8D43F774C48C00F3F4CBF04B7B7409FD29D402DC3E33F9B97A9403B538040D4894DBDC4432AC03F7E4040CD000E3F9DB7FCBF3DBB5A408F4812C09366A6BFEB69813E37B2E3BEE8022640C65B1D3FCD4CEE3F5633F13E204212BFD3C01D4095E424C04846763F3AC99C40E0EB57C0A26BB9BF51DD5140494D01C0EF2FCA3F2D205EC06BC411C051DBD0C078D16ABFDFECFC3F342FB4C07B591040AAE7A6C0799041405A82AF4090217540E81E983D23046DBF6302EBBF"> : tensor<3x5x40xf32>
    %1 = stablehlo.constant dense<[[[0.0133626182, 1.23966289], [1.39573503, 4.04096842], [-0.321425676, -1.748505], [-4.340260e+00, -1.54294896], [1.31796038, -0.0656365156]], [[0.678246737, 2.54354262], [1.63820326, -1.85314262], [-1.6033529, -1.02530086], [0.0108135315, -0.192303717], [-6.84337282, -3.87284899]], [[-0.071916163, 3.8922534], [-6.077280e+00, -0.853002369], [-1.50686359, 2.20099068], [0.878074228, 0.181841582], [0.794774771, 0.613622069]]]> : tensor<3x5x2xf32>
    return %0, %1 : tensor<3x5x40xf32>, tensor<3x5x2xf32>
  }
  func.func private @expected() -> tensor<3x5x40xf32> {
    %0 = stablehlo.constant dense<"0x656A89BE632C8FBFEBBD0B40DCB099C00D703D3FD40973BF21213DC08859BABFDE84E44066B3A3BFA98E3E4055A7F2BB31A7B93E225977C0C83EB43F8A8C283FB148753FD20E8A40A5975DBF5B95B93E1AA4174034C53640575431C05D5C19C01F86ABBFAF23F43F5BF1E6BF69FA9F3FDD39F4BE4CF19840E60BC63F9D1B10C06AA5CEBFCF7A0740D14F7CC0DAFD9C40E30562C05D6F97BF54EB91C0F016B03EC23DB43F469622BD3101494037C330C0995626403434A63E54DD42408EEC183EF94409404AF8C4BFF06E8DC07035424068F02F3FF92525C070F54740DA74273F48BBF93ECA5A44BF45BE96409BE9243D9B7A1140561A84C0CBCC19C0CE9E873F3D46D0BF0AC1184090E24B402B43893FD403DEBFA3D08940CED541C0D69DE83FCCA9C53E4A7F0AC0622F9340BBED174090DE17C0937919C0F74A48C019A2B7401F52EEBEE921ADC0F91C613F71AC25C07E87D2C087DCF63E5B758E3FA4C75A40676E7F3DC8E8434028861DC0F7F0313FA4C330C0822F65C0790667409EEC49BFEA309BBFF31E14C0992194C08716303E7DD49040757871C0195A99BF798A4A40D87E893F961863C0BB933C3F448851BF59E1293FDEBC18BFA4BE91C01248B8C0B0CD8FC0B38FEF3F0EAE3FC047227CBFC6739940BF48F83FE2DD3EC0E7FDAD3F85780E3F69E38AC0DEE685BF5B02A3BFDA46DA3F76A88140D17FA34005B10F402C59D33F075B9C3FF8020BC0C5F2BE3F9ACBDABFF1FB8540334818BFF48922406E65F63EB08C68C0ECAA1AC0093FF6BF47B3BDC016BE643FC80B2F3F7B57CB40DCF208C0FB2A1E40F1F5A840A40EB840ABADA8BE437FBEC0087B35BF1D9EFDBF542C533EC979C03F25A5B23F5FDC8E4076E40A3F8961AE404B5B31400DF21FC03E46FF3FC898B0BFA109163F8A53E2BFBCE29C3E6DCB5A3FF64705C09C4FDF3F4B8279BFC55D8DC0C415C33E3DEB12BFC3B77C3FD10A0040BEF9E1BF4F06C0BEA745DEBF9C0A603F154D553F340BBABFB850BA3F2D00773F8053B63EE32ED03F68D405C08C7C6EC0BC4428C0312FB83E2995ACBFCF3081407AD102BF88CCAE3FC39CBBBDFAA5CF3FEAE6DFC0E3016EC0D1EEC3C0AE168B3E1706B1BE28161F40FD1CBFC0FC840AC02497BF3FC81B12C0EC7D97C0B4C1B7BF139560402F4187406569F43FC22C6E3F6477D1C06B3283C045191DC0D4C6F5BE3A54B5406FE25FBF7A44FB3FF887BBC0DDA302BF5AA17C408A6A95BDEE4E8D40D71EDC3E0F0AE73F8354AD3EB54CD53FF3A6AE3FAD3771C077A1E7BFAA89F9BF7B568E40292A31C0FBE1524044343A3F400F34403F4F0DBF413EEC3D1026FCBFAD81703F4E34BC3F992910BF492483C09A0BA8C0DA486C40ACD0A1C0E2208640389542408230913FBEED09C08197F0BEEFEBD34007D30C40206D623F49559ABF0FAE6A40BA862A40954833C0F36DDD3DA378CBBF45981740D8AB0CBF125DA8C011EA6A3F1AA91040696689C05DFFC8C0FC108ABF84C946409901973F0565453E21617B401E8CB33F66C52B407A7AEBBFB89B5FC0B18F5ABFC21017407AF8BABC81A659C02E3391C0E016C3BFAB3ACDBF42183F40FABC003F4099F6BF64ABCBBF1E7635C0E27DE6BF09035C4053CDB9BF7E59673FB34A8BBF257397C070F5B3BFDE4C0AC0E5F82D4045FC41BFCF8E9F3FA13B10BFD84CBBBF729D7440DE9704C03C2DDABECCBF6640EB79544008F3673EECD35F3F24519F409B1B5A3F56CF57C00F2827C0015E414067ECB9BF1A9263C0215AB43FEBBD2A404C650740888B34C0ADAF2CBFBA21C43FEA9DF6BE44EB44BECBFA8140A0FDC43FC25FC1BF2EBBA9BF6ACB693F978038C054B48C3F8E2BA23F03CB183F65F68AC06B222BC0C85700BFC4892A40128385BE2D5E30405B2E38C00C3D96BF720819BED1B371C05A7933BEE221CE3F0295693FE452593E19FB10407CAC9A40B5BF1E3F235847C0AEF2E9BFDAAB913F69F13340CB6207C0B0D09FC0AAAC8440FCCA58405E5D1A4035AE2240518B9C40C01905BFC97FC8C0E9FCDAC0159EA0C06CC82540E6392840F8ED5F3F454645BFE4E48DBFF6EB61407E0CAA40E9A4034009380CC02E50F8C02334E9BF755182BF5FA2E540985CB0406BFBC4BFAC59BABFB67EDE3F9A9C15C08EACA8C060275D40727370407163183F9919803F8CCC013F0E4BF63E1AE946BF3FD97CC0C90E9D3F10F40DC08D71F2BDF887AA3F574D1CC023B0A4409406A1C04452C43F56BEB8BFB69A85BF2A384FBE4D6CE9BF567B07BF41DAAFC0F8E233403C4EB43ECF2D0CC036DADEBE8515C6BF0EE1C5C099190C40555D86C0162780C0B3562040D50B17401EBAE6BF21E42E40355B86BD7954F7BF251A9E3FD507683F25AF1440E8AE98C064855B401BAFD13FA4E1D1C0A6E22E3E6B5C6540D57D39C0A17543407C912B3FE5B119C001671BC0FC94DC3FB145F4BFA365FDBF6A84A1C0178EC7409D0A1141E5678FBEDC50203F1479C2C0A031323FF11EAC3F153D1E40F4DE63C0958475BE2878B9BFA57D3D400BF0F9BF9513D03F7AC28540EA6CB6C0A32170BE9A7134BFEB0C08404DFBC340A37E3B3E251F6FBF156D1F40AC3A873F1F151CC09F015EBFA13E16BF2313F33FAEBF4A40FA918F40B1401C40BDBBD340B31C76407FAECE40FDEAB1C01D8B96BE577C3CC0D0982CBFA3E157C0CA529E3F0D6E19C063488040437E8F3C3C5C6F40C9BCFCBFD94013407EBB36C0E3179B40AE51F73EDCDD0F40451FA2C065691F40957B39BF24824D3EA37E2CC0E296DABFD9AF28BF65CCBC3CBAC6A03F6AE11640EC53BCBE13916DBFB72904BFDBF356401BB1ABBF2CB071C05BC5E54003ADDBBEFB63D4BFA92EABBEA5BD783F70B5104009B3A7C0086D51C08A32153F0537AEC0643380BF123232C0A9A983BF4005BD3EADC284406B95ACBFC1E78FC0963E88403E0383BE8CB961BF445E93C09A5391C09FFBACBDA73D37BF259F4EBFAFC319C03727914006FEB4BF326A424092B7253F0E350C40519DC6406FB5E03F5C5990C0A79384407E3DE9BFD06194C0B3B08040C6F482C0CD12B13F9AFDEC3EF93702C09F09143F8EC167BF1A45B53F2FFA6C40FF0986C04BED0E415576F3C08D9712BFCD568D4032A8D43F774C48C00F3F4CBF04B7B7409FD29D402DC3E33F9B97A94056161D3FD4894DBDC4432AC03F7E4040CD000E3F9DB7FCBF3DBB5A408F4812C09366A6BFEB69813E37B2E3BEE8022640C65B1D3FCD4CEE3F5633F13E204212BFD3C01D4095E424C04846763F3AC99C40E0EB57C0A26BB9BF51DD5140494D01C0EF2FCA3F2D205EC06BC411C051DBD0C078D16ABFDFECFC3F342FB4C07B591040AAE7A6C0799041405A82AF4090217540E81E983D23046DBF6302EBBF"> : tensor<3x5x40xf32>
    return %0 : tensor<3x5x40xf32>
  }
}

