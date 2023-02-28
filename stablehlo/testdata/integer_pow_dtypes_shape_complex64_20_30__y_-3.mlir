// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x30xcomplex<f32>>
    %1 = call @expected() : () -> tensor<20x30xcomplex<f32>>
    %2 = stablehlo.multiply %0, %0 : tensor<20x30xcomplex<f32>>
    %3 = stablehlo.multiply %0, %2 : tensor<20x30xcomplex<f32>>
    %4 = stablehlo.constant dense<(1.000000e+00,0.000000e+00)> : tensor<complex<f32>>
    %5 = stablehlo.broadcast_in_dim %4, dims = [] : (tensor<complex<f32>>) -> tensor<20x30xcomplex<f32>>
    %6 = stablehlo.divide %5, %3 : tensor<20x30xcomplex<f32>>
    %7 = stablehlo.custom_call @check.eq(%6, %1) : (tensor<20x30xcomplex<f32>>, tensor<20x30xcomplex<f32>>) -> tensor<i1>
    return %7 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x30xcomplex<f32>> {
    %0 = stablehlo.constant dense<"0x41AC0540AB5590C042E0A5BF500000BF70E627C0DC4F4E40A41C58C0B84880C0C507E0BFE0C381BFB237B53FF33A82C0BF75A83F0956684073D96640FC1908BFFC6C3B40F349553EDD8A49C0D88F413FB56122407E8805403152793FBA5070C05EC5C63DC37AE4BE1060C4BF365B1C405B23D63F9E7219C06ECC0340A82807BFC3860B40D8DA1240D97F1C406F4995BF8132E5BFC18D53C0BE9E094099A62E403E22FABE212A36C0128DF6BFB3834840F019C9C02163CB403D848540A1B14FC0859D993FB4E80BC08906B6C0E2213340D2FC0D40F7BB0FC0C236B6409B08D23FFE0091C0A707B0BE78B797BFEF4BC03FD10B7FBF52D8A540C4CD96C0532E2B4059BD3EBE14663BC0038806C015CE24C073AA39BEE5FCE6BE9384B2BF6CE930C0FB1CBBBFE4ABE5C02B4A09C02686C8BED0CE3EC069FB4FC046D6BD40D9EF56C02012C1BFE81E0240DBAA8840C6AFC73FDC22A840AFFCD3BFCFE3D34069B9F840182204401BED81C06C91C0BEA853C13E9F68B240C6EB283F4C07ADBF331FAC3F8711AAC04955F4BF24804CC00C1FE33F3595C63FAD7275BF121BCC4099DEFFBF46486F3E4630633F2C1FD93F1CF0703F42514CBF394E86BFBBAA09403661633FD4CAB93F7DF78BC0DFA58E3FAAF1634096FAB1C07CDFE33F3079A14050055B3FBE0B834015135340FBCFAD3F12DD43409B05183F95E0FDBF09D22CBB5FE1293FFD8A21408ECF553F8C9E44C0530DA640B80E803F8335184086E0DFBC6AD5FDBF9B1383C0BC69E8BFABBF9C40FD2A583F37B31BC018EFCBBF7F7E9540EE539B40609AB43F3E16BCBF6D225F40D6539C40326F8E3F736280C04494B9406C41A0BFF6FB564086C67B40F3AAB43F3E876F3F60763ABD5FEB824061FA273F438616BFF17ECA3EA8CD73C0D6A625C0D9528FC0CA9E87C09C7637C05ADC08408BD13CBFFDBCA43F3C0399BFD8E8664089D1C53F81AFA5C08966B4C03915B2C0F3B3643FC9FAAF3FBF129DBE40EDA0402A49B740C64814C0199A833F95721840435F8AC031E8784086288840D9223A40D8B824C0BFF4614024B28E40B73DD1C0C6317340E76600C05E082A405E123FC029DDA6C07E1D32401F64B63FC4465A4054C5C3404A5678BF30BD13C04F64D23F06A3A23F944876BFF82C0340EF1B873F3584D7BE776A9CBFA5DC67C06E568440949B8140BC949EC0C78830C0B74D563E3A3D893FBE1A18404236D83F260027C0D9EB3FC0B4A50BC03F9BCCC0A13BB4BEBFBAAAC04EF09DC05725ADBFEFFA8B3E21AC23BEFA7D8E3F1C1B5340596B2DC0EEDC6CC01CC84E401F21DCBF26F1D9C0E6BF323D2FB37C3F6EF5FF40EAD0B9C0575B14BF6EFE99C0B4308740E5E8873F14D509BF6A4F19409DEC69C0F622B53F41EFF73F5F5B783D3256CEBFCF8297BFF4FACEBED6E88DC0C53A61BF62BED040812E9D402CCA61C0C6AA8E3FD5EF9F405B259BBF0FAB89C0F7591BC0ED682A3E6C9637402A47C4403103194039E7223D912B563F51A74840DD9980C051C1FFBFBD292F3FE3B9523FA4EB5D4004F4FBC070CD3840F810EF3F61475EBEE29FF8BF7128E53D08F0C8BFFD1B2240F8449DBF4BEBE43FE19DF73F9DA0FABFE5D544C07A5C67C07305A540986CA33FF4AA9740580093C05A682540C704BB40432D504002C3FFBFE3B46B408FE336BF69F1313F11B3053F0691A23F382ED0BD24AB31BF93BDD0BF5CDA2C4024981B40A6A6AEBFB7FAA83F1C708D40433CBBBEBFEF51C076F50440407D53C0EE6907C08955E7BFF380F4409E689EBF781A5FC0BC883D40E555233D9C91703E63F414C0BA5A7A40C029F8BF1317503F284682C018535DBDC71C233FAC6A75BD3FC530C0F37F083E2A2C38C0B40F9F40A9194F3F09F989BD63F8F13F5C32AEBFD4A650BFA905F4BF6CFBD4BE93B01EC0943963BF9899A0BF31595DBF3B92B4BF0EB63B402C6E63BF4B53313FD117CEBF95964FC0F98631BF81A880407591153E0A9390C0AF215640C4E59F400A0116C04721C73E265CB240DFB4CD3F1148ED3F427B46408CF1C53E6A897240C731C73F3DF4DBBD87BFA43F788F4F3F3236184090B1AABF25C42FC0305B5ABFB4DF19C0472394C093D0C6BDF5CFCDBF458EA2405EC328404B7A443D1AB39A3FDF67B73F796226BFEF0E9140B3673940B30A45C04BB45D40008B2FBDA9DFCC3F18834D4001C65840E5590EC0656B083F5F6F0EBF3B7489BF1940634003D8F8BF46B336BF6FDA72408B86DF3F0D5884C09BC8A8BF41DA89BF0A3E93C0389EDCC0185C24406327BD3F0C7B5BC07B296C40DCCB8940DCDDBAC0AA100DC0285554BF903677C007C723C0B16AF83E619FDEBF44E00A3FAE13AB3F92F55F40E79A64C032D9B6BFDDE308404B6FB340B09D91C0893714403C4B1940FD476D3F16A5A4C0470A57C0DD835C3F6973A63F1544984023B9B7BEF3374C40915DF93F623AA540413AB740ED9034BFF7EA4140379C893E34D2D1C0C7DD4C40E9C6B9BF96B7AD3F2133CE3E40EE7CC0B4A162C07ACA9AC032224CBFA4FCF6BFD2AF82BF20BA9DBF9E91913F6C3A3FC0992908BC49B6B73CFFF3153FAB7A3D4035B182BE40F0584025D579407170C63F958919407617833F0A9EB140FB4539C0BE7E86BE9D5EB6C058385540FC3D3240C6C736C04753C3C0A8626DC0F3B4C03F6F78D5BE2DC99D40267382C00387E840F3D9AD40FCF217415E8F5F40AEFE534010AB6DC029F0E1BF559003C0E5995440F3F502BF0D3B96C005167640768DE83E44604BC033BB8D402A493CC0A6A7A2BD2D7583BFABE324C0F99ECCC07795B2BF3FD7B0C092899EBFC2C993401854EBC00E782BC02C05BA406AB5BEC0C26F97408CDA95401FE6AAC0200D10BF8468D0BF9675C5404A12943F8F9967C070DDCABFD4D81E3FDAA7A9BFCB3D30BF6D963E40F41901C1BF3958BEC0317E3F30DE0E401C3F01409541E73FBA2D924000EC3FC0479E8D3F3FC9F73FA1F842C088B665C0DD3246C02445903F11773940423DB5C01D518EC06922BA3F9F79A2405EB5F7B92877EB3FE14056C06C9061402703F23F0FDE07BFDBFBB4BF25DDBEBF3E1921BF07B83AC048A50340267BC7C0BC4D40C068333C40619CC83FA9A0BAC03A61A9BFACAC25C0C388C73E261201C084CBBABED515ABBFDE139BBF8C910B404583943F992A52C00EFDAD4044191540351E23BFD63328C046D399BF1F990A3DFB26883E903C90BFB7630540FBD9863EA713AF3D65255A401253E0BFF46E11C051ABA9C0267425BFAE5EA53FDF0262C06D97DD3F8F589B3F8BB4083F058EF7BF447C53C0FFD88BC086845540908F2E40C385B9BF0272B33DF1655940DCC9474014DF163F306218C0B9F9213FFCE6C03FEB1B8AC0831AA93FE65D0FC011C3A5C0A06E863F8D5085C075652B408586A2C0EDBD1040174A234029C8903FF34989BFB34D31C07DF943C0461859BF5D56813F6B97E43F50456340E374963FA22CCA406EF8DC3EE0CA21C00D63D9C03385DD3EF1D46DC048BBA53FCDD7FFBF59F5D6BF0260223E828F73409F114E3FF8FADABFCBE7DFC0395C83C078BB783F32099B3F61F22AC0F85410C0B8DD8AC02C02B0BF6079493FFEDB0F409EA356C09ED6B0BF3FA5E2BEAD5DB43F1834EDBEF8E1A03FC974E2BF4FBA81403FE048C0305F213E3D7581BFFDC8C9403681EABF32397FBF23670B40F7E76640D546363FAB51BF3F18D1B63F5CF25DBF5D2677BF35326D40D0A280403FE725C0069C36C0C7C7384069B167409D6DA94008BEDC3FABEF8CBF89D1C7BD6EF1D23FF9E877C00752C4BF45B1E73F2FAD91C072A80540F38ED93F70683B3FDFE4B7BEF6E8C23EB2C0A43EB027AB4055F6B6C0D062A83DEBDD864049501A40AC8C56409596C13F5BF824403F0184BC934673C07DAC3140FE65A1BF84F292C05DC0B03FD3A61640051E25C017E28C40D00EBA3F23B48DBF3730024070CEADBFDBECF33DEC10CA3FB3C219C01A1A9C3FAF892CBFD706A9BEEE7ACAC0C22BC6BF744461C0B08170406139DEBF5E77883FA59574403EC19C409852FB3FBA1156BF533316404A9E6040E6B31C40405076BFBFC25F3F88C3AC3FF7336AC02B402DC06BEF69C028656ABF0C381A4070545F3E89DA5E4018945440A26344402DE229C0F51D134075933140F303EF3F7EA5A63F8A807EC07C490CC005DFCBBFE05F84BFB7BCA93F1331753FAE062940B7CCAFBF89E918C028ABC5C0A1B2EFBF3DF9E93FC3DA353F428D40C0446FDE40860FEE3FFBF29BBE7CFBC23ED1B129408DD00540AB5365BE7C1D413FA60C52403F4715C0C296BBBF627275401DFDBEBFF4CA55C0170B633F716B203F7808A33F9C99BE3F65FC023F1D6D44BF88480D3F4C18B53F7B70B83F1CBE953F40F7FD3F3B01B1BF8E1BA5C055EB59BF2CBDBFBE0F6127BF6B55AF3E7F759AC09666B5C0177784400D2E8FBE069FD83F7CEE90BFBE8DCBBF751632C0AAD2113F862B873F604F3FBFD8E36340E42A4CBFA507BCC0E8A604BE5EF207C01B5196408ED0A23FA21AE5BF1623E13E5C33823FC9E981BFE8DB4D4028E51640EC2C81BE205BD1C001D75DC019A31EC0CADE26BF96B916BFCD29DC3F9BE007C09EED074034811BBF3DEB14BFEACB04407D5266C05A186A406B70214008BF56C08826D2BF002606C05595573F8EF22D4097BF8EBF92DBFC3F977704BF9E1E374013199D3DD1820F408C17273E059C5240B37B41BFF87311BF5FE46F3FC3BC42C0C25A2CC0750290C0205CD8BFADCAFCBE74222BC05FFAAEC0C81B0F40F1EB9EBF752AA6BF1607BCBE0CEBBC3EF086AB40C1013BC069D360C0CA12D3C003BC85C026260A41CA78B43FAFFF75C0A8B83B3F0E5EF5BFAD408C4006D690C0EFD182BF5B250C3DA90C923FBD132C3FFA1A1AC09FA6033F18E802C0E4E1974084B654C0A2EA5A406AA82BC071541F3FF51E033FEFEA113EE7891F4016C30A40D242B5C0F6B18940A88CCCBEA17D4D402D6D56BB94A1AB40CFDDCBBFF8FDBFC0D1637EC05EE45940A363EF3F595BC4BD8A3AA53E9D566B40686CA33FEA5A8FBF2F8765C0310CE5BF1AB173C0F4290F40E121B3C076C74A4007FC69C02DFDBD3F620EC3BEC66FB940B25834C098628CBF072EBD3FED244F40DE2EA3BF9527D4BFC64314C0394CB3BFE78845409C6BC140D92881BFAD05254046044DBFCA6912C0A1F8ACBFD6959B40C36A8ABF33B61AC0FC05E5BF7F510FBE018299C0775CEA3F2367B7BE62F41F3F5DF395C004DB14401D41E2BF8C99323FF968A9BF02E1AD40988679C026778F3FFA0A143E05CA1140C341C7BEC9CF85401B57D4BF06FFB43FAEE78EC0A6C7B5400A20873FCAE678C06AB17DBF538AF8C04E83A8BFD864B53FA7B9A13FFBAE334063EF1A40C3CD7ABF1750EA3D80116BC0FD8FBE3E573D4BC02D5436BF5648BDBF40D6453F138A49C07E4050BDB03F20C0A7796C3E325B8C4029C3B040BE1BA83F851A31C0B33B28C090B5CEBD9F38AE3EC6D5983F133BF5C0F0FB8ABFA4E90EC0982AF33E05B16FC0230C803F236BC3BE4AA1293FD8AAF13E44FB4ABFF9A893C0D6DD2B401BBC20C03E25C33F77A2583FD24D13C0C63C8FBF929F97C0936DB7BF2CDC3C402958A3BF0C43ABBF31684EC0FBB09B4015161E4095CDDC3FFD5AA33ED32DE6BF3F77D4BE92FA8A3F89FE07BFC5CEC84039716D3F6FC14B409A676B3EA8817740CF67C4BE09F09FC0B55FB8C0B7871D3F79540F40F6D6F1BF78C0923FEB0BD9BF89F7D6BEC63442C0CEF52C3E7E5AD13F83DAABBE77612D4025084F40DAE095405B277540C95D4C4024693C3EB5B28F408E761340330C02C0578500C033629640868491BF2346A4BF4ADB6EBE8CB51DBF0778BDBF77347EBF611886BF42289A3F0F7AD4BD146B043F57AB703FAE292E3E0F0715C0311C3A403EA5DC3DB37B4CBFD47986BFE28F233FB3AE7BC05DC225C0985C6EBFCBC4D43FB140A0C01CDF004008EFF63FD6093B3FB7889C3FBC1C16C0F5F032C06B9D0740F5BC014093A03E3E8259C540379648C0937CCC3FEE60DBBF5DE28DBF9EEE99C075863440CB8E5E3F993D0DC0B13913C0A6A5DEC077EA11408D4C9640BA8786C02511C8C0276E623FAEF5A6BF6E398740FBC9C84016A78E3E0FAFCB40F871394013566F409BA93140CD6656C003A3BCBFF1B89DBF482F2EC0A8326E40E74B4A3F891FA63F560FC0BF4EE0534047BC6B40D3B16FBF6D74A53F0AC59EBEA172A2C0CF41163F3987A1C02CE21B40F26FEA4027BC243EBB6D38C001C4B13F985586C0C7D32240414AF3BFBEA3504000A76F4085E6F43F526CAD3EB78EE6BFFF1C86C02CB30C40806B763FC89E13C055F6A6C0DD4404419613D6BE5CCB2BBF9E5ACEBF8FF5F0BFCF4F6DC0A988C540141D343FB52146C0134A27404AB851BDE3165140A3D081C0D02D0140B56630BF5BC89EBF6EAB22C0B6E92940A44121C00E51DA3FDA2F4B40500B35407B2A234056BBB7400B24093FC8B0BC3E206A1C3FFC97F63E5E44293FC9DC0BC01B7489BFA45B053F587B24C051058B3F8635CCBFBA40FDBBAB52CBBFBECD02BE0E388AC0D9909ABF0645F83F18266240CB9E14C0819102C0710ED6C0E8BF8AC02ACBC03E568CCCC0C730CFBF1E68C64074F901404A2C9D406B548A409A799DBF22486A3FB8FC8FBD51E35F4064738F406C57C440A0BCB240C0DB633F4C2A0D40B69A1BC031D1C93E145A953FC7BE5C3F9A87684097D0933D74DBB13F32E33E4079F47C40D16BADC0969032400A8548BF0FB100C0482729C0E5D02A3E"> : tensor<20x30xcomplex<f32>>
    return %0 : tensor<20x30xcomplex<f32>>
  }
  func.func private @expected() -> tensor<20x30xcomplex<f32>> {
    %0 = stablehlo.constant dense<"0x509600BCFC3C0EBBB8B62BBE7AABAA3E06924A3C412AD2BB086BC43BCFC6653B07E3053AA47EF73D92CE2CBC2DCCDBBBBCE375BCD5360F3C5FFE983C59AF0F3C48321E3D7BDE08BC1560B7BC14A39CBC4C195BBC167ECBBC06A241BC7E2F4BBC524FC9C0827E06C1838C293DB9BD97BBF3881EBD4190263CDB879B3DFCBC913D4B27C4BC5923A8BCDE61403CA94A483D1FAD993C9DB7C8BAD072B1BC055223BC6305A63C8E6B14BD651CA43C2225DABA77F9833ABD257FBA88D531BBB246CB3B46C583BDD46888BBE7604BBABA227CBBA377BBBCE3B6B43C64CE513BC0DE6ABBCE172ABCDA481D3B25A3043EE55775BD4A7F703B89B5BB3BF8BE11B954E5CDBB75C3F53BAC3B1FBD3E84C53C1F2D4F3CD3B1FD40A04165C0E409083D1CACB9BBCA19BD3A026209BBE33AA9BDE5B04B3D8A55173C8A1AE93B403AA838ADCC4E3BCCA96D3DF952AABC713FAD3B9A3E17BC47B16E3B14739B3BAD7152BA74BDFFB94B2A2BBC3555DCBAB15B9640459894C0D8BBAD3B722E00BBFE41CF3DE08CD2BDE4F639BBFA699C3B225C86BA1193A7BC875872BC271F283E727D063BB5672D3B822667BF193E6D3F7769E53B8E170CBE6886CF3E8CCB253EAFB8FA3CAFE995BD203F09BC15AABFBBA6D378BC6088413CD8E644BB00D483BB550BD63B47036CBB8C6B49BBD7A7C9BB3A54CFBCAD7A083C22C8B0BD285294BD0D18273D13FE5A40727AFA3C215F32BDCE57953BF6041DB90ECB5DBDBC3BAF3C8E9AAD3BE02703BEEC8864BB15F52C3CE495E83B23BF82BB7D9CDF3B562F243D640120BB1F9D0EBBDD65B5BD428DA03DDC4B91BB05A3ACBA42AF24BCFF3F1CBCD61A7C3B6FDE3A3BE5DFC9BBAE3777BBBA741BBD33404FBE6276FF3955136F3C41D559BF2730983F5222B2BB4FDB8ABCCFB7EC3BDF3814370126CF3A9016EF3B1444403D008A943D0610ECBDDF89133E4D38BD3BC9E57DBC3B42E73A2CB6B23A2388A2BB453528BB7CDB903E2037603E29D2F5BA3BE0A4BA9F339DBC36E46EBD60EC07BC9D4303BAD01988BB5A404FBBDB821EBCCA71663CC342A1BB742617BB8ADAA437458117BBCA04CF3C186520BCEC09973BA4C951B88D76A13BD27A04BDF2853EBB6A8E0939028C723D4540C0BCD25133BDBB0FD2BD27C5AA3DB282B13CA237923EC7641E3F75CA723CAE4424BC5F5667BB2E4676BB714987B98969B33BA0ACD6BE6D70243F537D38BC54AB1EBD3B8C5A3CCC620E3C3847313B796DEABA5C5FA83ADD2FD2BBD2E4A9BB2ECFAF3B308903BFBED5FB4193DDA0BC8971593C29E0203C83ED583B02F3093BF62CA63C58654FBB8A2D7FB8DE5134BA1096E93A2D9A9DBBE4E9C13AC4FA0A3B974C4FBB2DE2C43DB5B6153F217E41BC5295043B37BB8CBD60D8BBBC40A4DBBC556372BE8F2490BE5359DA3E568F13BC5A8DC43B9C0C2CBA1CD4E0BAA67D44BC287E80BC1918B63B29B59D3BDE2D81B963DF073CD2EAEEBBA50D2A3D6838CA3AE8414EBB5F8A77BE61A7D73F6445E2BBEC53483B56A56EBDE9B8B5BD74F668BC61828A3C07665BBA3843C1BA73DA103E4B9B513D2FF908BED910BFBCC81A1A3D16A367BB40F6C23D68C4BABC62620DBD6159083D701C033C8F9F9E3BF01FA33B186D91BB3B6C19BBE185283BFB416EBB1DCF9E3AB379C0BAE2C2923CBC37823C2EB3283C8E100ABF3C1EB6BF2E78F03EA8FAEA3D9AE72B3E76E082BDE49348BCF4278ABCFFE0C83D02D3DDBD8715363CC026383B3B40093BE2E38ABCC9F5143B1950863C3CC9AD3A31ACCF3A15318A3CE07628BCDB871D3D73BBCBBAC039BEBC4AC398BD6B05153BF552413C6C46FFBB86203EBCAAD8753F62EF6C4014174A3B1ED741BD27B9BDBBD3AD29BD4015E33BB7C36EBBCF19813CE36D163EBC0C453CC71D803EC55CDCBD709DA53DAA64E6BC8A62403D6440893D23978C3E0997E73C0ED8D43BA4B1903E8ACD23BFBC75A93C775081BBE18CEC3B6143523CCA5E89BA248D30BC72B393BBC6A16EBA5F8086BD85A110BDC08F5F3B877E7ABBF880ADBCC6AA7CBA7903B2BB905C8D3C2604843EBD7A5D3D513D06BDFB7B90BEB7BFF33ADEE8493D3D33D5BC3D46073D21CAE43BFD4576BA4250303D8CFD70BEF6513B3A9F31ADBB2E6889BD6FA50F3FB601983DECAE7B3ED1E262BA548BD0BB9201073CD147BCBBB319A03C75A8783E7960F5BBA1F5D0BBAB5082BD3CF75DBD6F5B0F3FA4BD9DBD8843863AA766763C16A4163C1080713C67AF28BCCFB483BB5D08C13DA9AE373E60D0E13A322BB2397EA52E3935771DBDE903C83B974CA0BBE10422BB1EE2613AF7E013BDDD448A3D5AC3F13AF1E7213CC36FFDBD524FEEBDA72E9CBE1848093ED6EEBEBB6085B33BE31F6C3D3D3C3BBCB8FC9EBA5ECE1A3BC955A4BCEF8494BC92B869BBAD50C5BB443D8FBCCD3686BC21E7C3BBBA23BE3B7024233CC599E93CD429ACBBE6F6363B343F9F3B6661F53A246E0C3D60B118BCFD900BBA8F0E25BB941BA53DEB2ECABDF7CB9CBBDA5079BC9822903BE73CC23A6CAECF3D01412DBDF3B05A3E7AC3F13D7D64DEBC0B6A67BC10C17947D16D0A47F7CDA4BC314BF83C3486BA3B6448CB3C2A06BB3B575C48BCA8BEA23CC3F457BDE702093A5577843B0774423A99C8AEBB952DC6BBDDD82DBC090E4F3BB8785ABA6086CDBBFCD469BC246B073B7AE8023CD974E23A123B86384A2448BAC48218371E84BEBB2690DFBB42CA5FBBF0F4643CBCD5883C4339C9BA520D473B666313BC8572843C4D09C3BB4A7BC13B683EECBA562820BD0EF04F3B2D462E3DCF0CA1BCB9E03ABBAF700C3BDA598EBB149E5D3BA3E8C6BABC2232391980703BE8CE873AA5B97E3A546006BB701418BB9924CB3AA45B283EBF09D9BDA5F5603B71C60BBBBB6AADBB312E7B3CD3F79DBEB83FA6BDFEBFB43CFCCCDE3CFA7AF8BA34591C39D88285BD5B25AE3C59D0EEBC64B527BD5D6C89BAE0DCC53BEEBCB8BDAF1D9B3A14A3063C5E9AA13BC0E364BC1D34C6BC1C917BBB7E251ABA2091BABB6BE801BC6958FA3BCB200F36DCAE92BCE90695BAF589BF3A57F67EBCFAE4823E29D40CBEF2ECAFBD2CF3603EF432C13B597EADBC08342FBA7DD8403B02F4333B9742DCBCC84A70BBA51E3E3B8CC14DBD68E8C5BCC16ECCBD4B5E733D06D9CF3D3F150C3EB48EE13BAE2387BD6F477F3B521172B91F5B4A3D14BE503D31523EBC2AE8223D13ED99C152DC40425C6F993DD35ECE3B15C0DD41264E18C28E6A293BE5F48F3C31FE9F3BEA0AEEBAD51DA73E023D723DBE9F59BB5FE283BCBF350D3E65FBCFBE69EC913C6EFEA5395B2E143B28B4B6BB9E176A3BCF3B0A3D641A01BBB02CD03CAD82D83C9CAC87BC71E442BDE67D40BD190811BCC20CB7BB14C768BDAEE5CE3A9925B7BBB0A77ABB90ED993AD87D05BCD993EBBA555AB5BB21506C3C0DEC32BD72CE0B3DFF738BBC8CFDAFBC780FB93C17FAECBD2615463BA3CC333C842080BCFCAC7C3B3ABD51BA7CD9163B659EA5BA943AD5BBF91393BC4FD795BDBCA7393CB7E44CBE59D46DBD1AB2613C5CF322BC9F16E73ACFE603BB035227BCAF240CBC196B1BBDDAF53BBCF0D40A3C529694BA2C163ABB17BB80BEDBF773BC3A72463B1A7048BE4E72863E00C2353E31C17F3E746FC0BDDA40DF3CB6E73FBB2268DF3BF187D5BE9B7E55BF6E0F193B909F2D3BD00E8F3DDB71A63CFE5D893CB4C835BCF85998BD6AADAEBD3B23BE3EF8FF883EEEEA9DBBE7FA76BB161A653CDC2E2B3C42AB14BC2F398FBB3D705E3B37C799BB47EB36BF5BAD463E713D4DBC42699CBB81B0833D782C1DBD4B6310BB4A9CFABB3E085E3DC3BA17BE08FBAA40DA7B8FC003C298BA1D8CD13B9E18AFBB70DA71B9300FD938681C0FBC0D46C23BAB5C9DBCF3196F3DCE818F3A92A1463B3A0C15BC2480DA3B1A8BD2BBF57949BD93FD85BA7890F63B062319B9043D7ABDB2C71B3E87FA58BCC555893D323C67BD4C857B3E27CF06BC3AB04EBDC3D4F5BE0E421440314232BBC14F1C3BA18EB93BD54C98BB8D721D3C4960F1BD80DF79BB1C3CDDBA7E9C153D82FBC43D3C7855BCD1CA2ABB03B4C23CC9D04A3D616473BE6E5F16BD11AF673BF3C7233C90E362BC3CA54D3C8C528B3D03B59ABCE6B1C0BB761ADEBB8C1804BC5CB04E3C504899BCF06329BC10B4AFBC07F9A7BDD16026BABCB12E3C12DDBA3C0BAF133E1BD78CBDC8185FBED9AEA33B68EC193D41C4493BBDBDC9BAC6A71B3DF85E27BD3CB4B1BCC3DFD4BC9109F93AAF7FF8BA1B1BF840209671C0135232BC2031C1BCA811C83FE13DAA3F4A118CBB2506713CD175523CB9DED83B1B479F3CEA79CCBB9ECA58BE0D6C40BFDEC6E7BDC5BE8EBD5822A0BF71237B3E3B5083BE0C7E003EDB7F92BD256C0EBEEF3992BC0A178C3D361FCABBD4E4573BBB9A1540C4D0C5BC87F3F3BA5D580DBC74706F3A8DCA33BB5F70BF3D8DE6323E3512043EF2031B3DFEF212BDCE8ECBBCF63901BE2079E33E2317853CDC044F3C070CA1BB2CA5AA391AB3E43BC4DC0B3BFEC1B9BDE0DCD73CE5EB30BF1EB17F3E7176A93C4FDB813CEFD2913D272CC13C45B98CB92883203BD4692EBDF99D293D0A6B0E3EF02EBB3DD701D63C68C4D5BC55F28D3F3CADA13F3C8D64BC54E7CDB7A0E231BB056935BCE35C80BB06D8993C216E12BD44E4A1BD95387D3C589E143DD6E4AC3D452AA73DF81B2E3D7A7B60BB13F2AF3DBFD89BBCD4D8A53CAE5D853C421D423F773A48BD8F6F0A3C722E493CA7918BBBE4EB013C4031D43C5FEB2DBD5538FBBA9EFF91BB56FC043EDA98E83D2383A140353D9FC0EE42A93991A08F3B4D321C3BB1C580B9EFF6903A84B88039A5A54FBCAA9EEBBB7DB1D2BDB08F58BDC70142BB5424303BD3306EBFB5F3BFBD159F39BCD161DCBE9F865DBDE5EF21BDEDF5DE3BABD3223B2995DE3B052CCCBBA81318BDE4FDF7BCBF34924071D59AC05DC577BC0E6CBEBC3A71863A0A3529BB33882F3CBE5CE13C2B004737E460D43BED60403BE01343BB0786703BF964C2BBA0151A3E35EBBE3C8421A9BB664A9D3C0F66E8BDFFC22D3E219938BB753F7A3C8C1D8A398F2F3EBC1323CAB83D2A76BB447BD6BBC92D74BC4CF2823AA911A43B4AD182BCB1EC043D337CAEBCA405CD3B92A5CE3DD4E02C3DB865483BC60F4E3DDE254FBBCEFD003A6D982D3D4A75A83C779D733DF3EF18BDC342B93BFB34AF3B991B523D971686BCF24D2CBEEE6C243D5D3F5EBB5F0AD7BBB14D2B40B158C83C2BAAABBA6CCFE0BB10E07FBD2ED006BEDD22763B783C8D3BDBD623BC6EB436BC213282BCEE1CA93DB626733BE7AC543C92A44D3DDAE6A8BD670B1E3B3E2A90BA8EC032BCF44A2FBC44ED4A3ADF80FDBA77EDDC3DEED6B0BD7DFF05BDF112273CC157BA3C823C523DCA65F6BA415EA4BC66E12BBCDF6CEBBC95C7613EF0FF4DBD82CD9EBC4759B4BC21F77D3BDC2382BD2519F3BAA1F53E3C51E4883B47BC66BB8CB63F3C93C95F3CEC2E8841C9186841244D7BBAB245FBBAEEC1823D1D4462BC9A01E1BB517C8DBC8DA0BF3EDC3E393F622A06BF6C0FE4BF4E009C3B9E470BBC5D8B50BC86407F3C896D1C3C57E740BE3DC74EBC85D36E3D84E4ABBB2A64D03B9957273C0ADFE73CB6EAB13C62B212BC49B2813ABC14C7BBE7D4213ECBD8C5BDBA43FDBD52F6CC3DAEE3EC3DB3E40D3F3145683B37D3DABA5106F63CCF30D8BBBA79853C012CA33B8739F83AD619A03A3E8C6BBDFEBC623DF68AC63B7E53BDBD54600FBE04ADFF3D59E30FBDC7D2C1BB1FAB343E880EFB3D93323DBCC702D9BBAE220ABB7CD082BBCD9FF63C4E0DACBBB6E8963A580DFCBB76FEF33C8FCBFC3C1A76DB3B066BBD3BC9EFC5BE3BF56C3E9705663EEAD6BBBDE7A5813E57AC5C3E46240C3F24CD133E3FD14EBFA7B74C3D77AC8BBC5C159DBD4433253D776E93BB49E5CE3ED2F9243E24BCF0BBF66A65BCD17CC8BCB2F7283D63E7B6BB0D507FBB1D6CF9BC57DC0DBD05EEB0BEB8D37DBCE3FC913CF16D283CF7F2D5BCFD71F4BCBDCBC9B9ADEF8A3BD3CD6ABB49DFB9BC3C5E913C0615EE3D0DB8F43828EEBCBB58858ABD1F1F04BD5639083B1C95BFBA08F2E0BB238AC43AE607163B91BBF939DD7A7FBE2E1F613D352314BB3F3CF9B9C4A304BA94397B3BB61C0EBCEFEA74BBBD1A2EBCC289C03B93228F3D9BF4FA3DE77A1E3C897854BBE39591BE2F3CA3BC0B45A33C6CDBC53BD5095B3CE1BD4A3CA2D2A53ED37A8D3E7909E7BBF83926BB2CFBA3BA2D8DB5BB7A2F263B93632FB97BE4DDBB9908F4BC2F410D3A183D0ABCD46E983CDF2279B97DED063BD5BF59BC8607B0BDA2200DBEA1DD95BAA96C19BC662A73BD73EEC4BC68538B3A456404B9D9D10040B67E503E2ED4643D8E7C0D3DF2452F3B03E411B9ED0F9FBC829AC8BC0ED2643D125D573B8573CFBB1C334F3B4ABA683D9720B03D3A1F313D1B0516BC5C0859BC660A7E3C2445AEBC0A65003B54B72EBC08C56FBC6B45A43B804EBCBA37E12FC069DC21BE7921DEBF202812BFD22062BC7B048B3D4F4000BD937B3BBD61EF0ABED543FB3C05A76E3BB1737FBE84E28F3AD23F4ABC17DBAA3D22CF08BC769615BB277A553C5FA8143BE1C4F1BA601040BC3D464CBB132E28BBF8D01A3B7057093B87E43FBB730303BB1AD741BB18AEC13D218485BEFA58B83A0AE4BE3C99AD0DBB6B273DBAFD20A13BD95925BB0FCDB9BC07358A3C8536E3BE6A44993EE4794ABC45D9703CB3C96BBD36C7BB3E66CAFBBB357F42BBAFA526BA362E8FBB13EEB63D19A533BD5A9958BD3FCF25BC"> : tensor<20x30xcomplex<f32>>
    return %0 : tensor<20x30xcomplex<f32>>
  }
}
