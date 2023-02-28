// RUN: echo "skipping CHLO test (see #1233 for details)"

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x20xcomplex<f32>>
    %1 = call @expected() : () -> tensor<20x20xcomplex<f32>>
    %2 = chlo.sinh %0 : tensor<20x20xcomplex<f32>> -> tensor<20x20xcomplex<f32>>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xcomplex<f32>>, tensor<20x20xcomplex<f32>>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x20xcomplex<f32>> {
    %0 = stablehlo.constant dense<"0xA3AE5AC0B7DB1940963B8CC00D8EBF3E502BAABF4328F540657CC63F3FA8B5BF3EFEAEBEEE4C4C4038BE44C005AF83BFA8E41FBF7BD993BDFFF83CC0BEA816C0427429408A12373F9C36BC3FCD4F42C00F82C0BE286540BFA578AEBFB1B70140D7B6F53F05FD0EC0682C79C0F02C0D407464B4BF6AB45B401FE96EC0DC679DC0864CB4BED5EA8E3F0C7EE0BFD3C2A8C0D14D2540842E1C3EA07713C009087EC0A6CBC63E8B2C5CC0F05FB3BFF541883DB4BCDB3FFE036B3EABE6813F09BF1540046ABBBE92325CC0DF57483F4A60E1BFB5EFD5BD48AEB63C119BEABF2DF894BFFD8124BDFB09993B6D7E62BE20BC22C07DE4A4BF5290FCBD82799940B75141C0C63CD8C09B7339C0ABA6D3BFC468AABF01FB74407E2BB8C0C1C028C02EAB523F0000193FC453B8BFE0F0F6BF050457405B0387C07303A9BEE8432DBE697CC13F26D78BBE461F97C0A1F68B4042EF49BF182EEE3F9B07B4C04DB117BFC04F2CC0BE58B83F2277BCBF29F85B3E9EA411C041A5143F10B3BC403F910DBF58250FC09789803F9FFC9CC0771BCB3FDF7F113F97CB8A40F5D51440EDF56F3F88A9B93ED60912C027C7A93F4B3108407AA7883FF83501C030D9014096465C400AB9A0C0194EFF40C97E5A4095C6953F6E38EABF00A986C0C63111BF9482ACBF068434C0633EF6BEA01B04407B6EFA3F1C5B8D3F57189D40BCD49CC0E730ECBF9BE05A4093BE82BF5F347740F6C4503F5AAE50BCE33028406A0208C0720351401F11B03F16798C3D8A0D493FAE9AC93F510CDB3FE06C1540839DC43F0D2EA63E88638540DA43A8BECC3FFB3E74B725C0A8F96A40FB664A407EB6C7BE29EBB9BFFC643A40EC37A0BE8FAEAEBE6ACC6FC0AC9409409C564DBF3C607EC09001BE40131217BFB79D9340C8A2B9BF410333C08A2E5A40046D1140A4B6B04037751F4002BBC3C0083429C0048110C117DE6840927C9CC0E718833F46215BC03B219FBE6C0D95C0DD479540D6B59540A6D7734033CCDC4040F0563F071EBF3F4DD45E4075F3964086BD79C0F0733DBE40120C40F5A31F3FA0D4F240764DD2BE7B0E90C0DBC96B3FE382BE405B3699C0888E1E4088CD193F347B7ABFF89524C0481DDF409A983B4045D22940947B05405583A6403AF47940DAFC4E4018C168C0254F8D3F173C583F80948EBF3CB3FEBFEDE7594006617A407DF685C0C672893ED9B50C40F40B924099E38DBFC744233F27BF9BC0BB9C9FBFFB4D32BFFB3DDF400A6F2E4036E52440505374C08D5A893F71FAE7BF1158F7BF53C33BBF32EE80C04BD6B8C03123693F0FC0484036AFC2C02DDC9C4089D88F3B80B52340B1AF9A3F79BCCAC081BFEE3F063F8DC09C458A405DC1AE3F03A3713FA6B2C9BF49E2A0405D3817C0151EB2C0469B75BDC534BD407762C7BFD43E0CC07A71963F9D3B513E8C199D4025C65CC0BFB428C072638DC0E1278D4077B265BF3B508B3FD71C51C09E9AD53FB6BD7CC083C0853ED1A6D23FEF13F7BE4FF99F3FAB163FC01BBF18C0EB818FC0CE979DC077F7723F3D7206BFD9E988C014CEB8406697273F641429C0CC07D63F53609B3EB5FD473E483919C0259B1BC0300B51C0AD8FE4C0DAC0E63FFCDA18400D6A0CBE128098BF73CC2BC0DEB288C0256F843FD9C932BFD71D92BF8D1E6AC04EDDFB3F949E4CC051DBFFBFA1501CBF4DDFA53E29712E4058E4DB3E5EB5D73FEC1046C03EA180BF83B386C0600D23BF359A0F40A25A2040287E72BF3B7B02406886B7BDADEF75C0C877F4BF086C40BFDF386440598202BEB068A3BFB033FCC090E58DC0745F273E77043D409E47923F2E2D13C028C7463E50F7AB3F01B304C08F0BD7BF630157BF2CF27A3FB4C742C02D1F1B3D00250DC06E45B040DBA90E4033E71D40A11D45C025D8293D300DC3C0AAC3383E2CFC8B3E4F4E21C02EB5003FC40681C06C4678BF97E5BBBFC7BBFDBF181D613FDABD46C0D8F2A53F1ECB953F877F2BC0254AD83FE9BE7C406833D9C040FAF3BFE8D8193F671DC9BFE7E0D53F2CE1CF3F4BB468BFAF0896C0180D56BFBE9B5BBFC91B9F40C8568640CC66B3BFA3530A40110B55BF17BCED3FC17A80BE54AB0CC088B6B7BF666AAD3E237D93C0E0DADA3FA3601D40DA1D66C0A5AEE03F245A84BCB68C9E3E5280DB40FC6B48C0F627DC407417C9C0DE066C407AFE77BF7857EA3F8F7084C0C30EFF3FE1FF6E3FA78CF33F8672B43F53879140EE384EBF69B84E3E38FE41C01F980640BD872BBE6B007A40BCCC6A40486A3A405688F7BE24E04C405FD294C0A0DE513FAB57BCBE9147D3405B5B69BF24317ABF3B3083BF17FCF4BF5E5EBC40B89FC83F6145D4BD04D530C084B068405299CFBFA386C4BFBA6306C01E7C6A40A89FCB3E3F8CA3BF62D96EC054AFC2BF4C58C03FD99342C0638D2D3F07CADEC019F090BF554C34C0C22EA5BF513D703D3F5E59C0FBE290BFE0E6F93FC224083F59382EC02ECC85402E4F89BEEB1D5DC0D73EDD3FE7F290BF03FB2140AB6703C0D5C94BC03FE757C08FB314C074ED8DBF1964E3BF821D05C05580A13F4CD138BFEBC439C0EE3283BE6A02C4BF45096EBF061665C0F1257CC070AEAE408A643540F168294090A4033FDCBB2D4025D29CC04C20074042122CC04A21943FAE1C3DBE38C4EB3EB6F375BEDF15E6C0EEB1973F8FFBBCC0075C9840959FA740AA958DBF714041402FDAD5BF69C1DE3FDD54C43E3995A1408A6C423F420889BF298D37C0DB6513406664953F726DEABFD884BCBF09C1A6BFB4B981401C7207C1A0CCB63F9E26EC3F446D6A40664988BFC9C1CEC04ADDA9C084FA65C036958ABF03CF47BCDF13FEBF3A5753C01DEF38C08AD716C0964E79C012F817C060A7BBBF22965F3ED11BEABF8CF135404C7413C0ADE0EABF3E92A2BFA6F3BB40B23FD73F066B883F085C2C408D6025C094E28BC07A0F4A40C53B27C05BF9EE3F8965EFBF8B1136BF9F276540F18FC540D94858C03F3D92BFFEFE9BBF6539143FA06F913F351B9DC044C327C06DDCA6C041F1794012AF6FC05B62DA3F49BBB7C0493B993E7C345EC068164040111DEDBF877C90BFC6724DC020EFAD3F23D2B6BEA26760BE4731E73FF97330C02E26A440A6E00F40E5E5CEBF98E7E0C04AD191C0CC0EA640D2F333C0C1CD893F3F0036BF21A5B13F4E3EAAC09DAF8ABFF257B240509ABA405D509B404B5B9EC0337A43C0D684AC3FB6C687C0BCBD9F4017583CC044311E403B38B33FB0EC8240706CBB3F24457D3DFB35954020FEFA3FDD621940DB955ABD2C26D0BFE6E5FC40586FEFC0D795753F95B9813FBC8EDBBC01B2E7C0695E44C0B67A624041360B406689953EC7CE17409AA1A540553BB6BFFD7191BF09E46B40E58D1F3E5FF16C40648487C0880AB9C0AFD80DC0A1A2C6BFB6A3B0C09A962BC0C1B0C1BF6A5830C01D31A0406C83983FD42B813E2F9B91BF218536C099CF64BFBA0A04408095383F25134A3F89C40A40E8614D4061E788C0735DC9BB46B539C0CDC72540E6C73CC032618E3FC7855B4006348D3F879ACD3E59DD9DBFA839B04014C7943F85F0AABF02D8F5BF4B35CA3F21F617C032FAB9C070E15AC077B429C097076AC07C3D9EC0B576EF40CA41EF3F87688D409F4512C057CCC9BF3C7720BFA347893F5DA475BF1F2FABBEA6ACCB3F71A235C020A848C0D44715401F30893F80516CC0EB039B40CF850FC04B0D943F4CD51A41047487409C822BC03812B34017486E3EE289C1BE40506DC082D2923F294986C0C394F0BFB0700DC01CEF0DC0E6278C403EA9633EE7A4C53D6F44C03F688ED0C0A0798FBCEB0B0840EBF988C03E9C5CBF2B45C13F60A88CC0669192C0F58CB540617E273FC37996C0DD26FBBD047E1D400C4FB73FC4C4853F700E4BBD086A48405DEDE2BFFE37FD3DBD28953F23574C3D857381BF73DB0E4057048040332FDD3F3F3A4A40A1AE9C40D27833BF47C1EDBF19E6AC403F31A33E6C9E43C09C7EE33FE2F6DF3FDC91DABF47E1B8C07B78A6409AFC62C0EF7D6740E8315D40467DDEBF03AAF23FEF9269407DDAE0BC803A26C04D258D3F27C17CBE78B4FA3EFA295E408F0B84C0A44EAA408D0CA93EE31318C047731B3FA7E782C01D031CBF4F3C5040A9A865BF03E7FFBE7683D0C0A813AB3E649A044080FE92BF788482BF1A3040BFDAC5923EDD7A3B409B421FBE76228D3F4B54B9BFF327F43FBE52C8BF558F8240615EC23F58FC5540F9D937C0ED9AAD40F947913F80E8563F9333C6BFA14FA5BFF71B8DC0CF5474BF8B65673EC3FEACBFB524C6BF2B0F50C01BAE043F9892C33F66FDAD400D879B4030142B408A1638C02BE06EC08F982DC085CD4D40CB6AEA3E56093040ECB62440A65100409C16874001B916C0E51D1340AD5885BFAEF4B5403C6F0AC0333DD740867894BF849B00C055DBFCBF653848407A56A73F157A9DC052BEC0BFF2F6823F8EDB5E3FEBAEF43FB87894BF1AEF1840FD76903E346C7B3FBDCA96BF243921BF797418C0B46C1D3E4AA1E23D8F038E4029FB4AC0"> : tensor<20x20xcomplex<f32>>
    return %0 : tensor<20x20xcomplex<f32>>
  }
  func.func private @expected() -> tensor<20x20xcomplex<f32>> {
    %0 = stablehlo.constant dense<"0xEC3E3441C720244116F214C2AEFD6941F865ACBE39FEFD3F7012AE3EF4D81BC01331B23E53665BBD8027B2C0288F14C1B20C2ABFBE7BB1BD35B0D740A4CCD9C008BDA94091E69440672503C0A4EA76BEA7FD8FBE244A3BBF37E14D3FCC42EF3FE97803C0E09C2FC0D4CD684132179E41EFF2EB3F96721FBF0F1689C0E7C0A341AE8421BE2673743FDBECBEBF5B2C2140DF1BD0405B6D813FBCB25640715B6E40A0CEC2BECA21A23E2A96F3BF739B123EC2D82740B250273F635155BFCD8E8F3F2620B73EF607A13E553C27BEC131A6BFB945D6BDC6A9B73CEB529ABF746A3CC0DE8C24BD7129993BB29B3C3E1CDA13BFEFCED4BF0EC275BEF04870C21BBBE9C0C4BCD043A5CACFC2A8D518BF966328C07EBF9E41094C3941C73597C0C6AFA440AE3DA93D6F4196BF4A8A5240B59F42BFA59500C2584F30C1DEC424BCFF9B813F717638BB11CC843F8AA1DF41813BE1C114EC1E40B4B90040ACC7103F774403BF3873483EEFFA0DC020A00FBE688247BF0B8F113F585CE2BE1FF4B73EA7E368BF1DA0683EA073C23F139DFC3F746DAF3F5C9FD1C1E2F3DE418557813F24B6053FAF1B96BFE7A499400B82FF3F9FC46E40D65DD13F16EF5B40796F984005436E41EA95AFC41431C4C361F7BEBEC98CDABF3CC4E2C1508290C1EBF3D93FB7F125BF7A58723EDC0C7C3F0D8DC73F3A3D4E401D404B4164238542EDE33D408E2F64BFF666683FDA8A84BF2FAC683F9EFF8CBC880268C0E556BDC0587422407CEE4D415CD2463D5C70353F28C9A5BEB79F1F40C1EC353E9CAEA640CF0C2FBEA3AF66BF371897BE1C6FFE3ED4DDB64086AA58C0C0872E41300690C0B5C8FB3F4B14033FC07599BEE3C4B3BE846B3941B7008E416F69193F7EB57D3F51791D43BBEED2C251DAC140552148C2FB12FC40A3330BC0B5715E40425958C0154BBD408E16813F12D5CE40E45E2DC0E225574013DA9541951A95BFA436E03E0BF08C3C6608863F6790E6BF823B54C223439341E90551414CB3953D7A4CAF3F51A9A03DAD2E82C19695C2C175C991C0C6E0644007D52840CE5E62447B2DC5C3DB31DAC1039F0F423E5C684176FF3F43FE179C40D2FA58407E2F763F1DB351BF926502C406C9DE422EB25EC0ADC4C640E15B83C254B17BC29B6932C1DF4FC1407629643FFF34A03FA58E0D3F4548C5BF18A12CC118F527C192A4FDC1A89D0B417C7F28BF4C5E90C02ED28ABF0408803FA560A5C1DC6376C2CD8514BF56E04C3F5A60CDC00B5983401AAD2DC1B4F99F41A0F7863F5F343CC01D77013FFB5B7E3FFBC3C5C2CCC4FE422F3D3441F82A124089888642A634973ED0891140B84CC2404ABDA34288FE864371067C413CB818C26F78893FEE3DD83F42A537BF315F19C007E97DC06E5161403C1465BD54B7B9BE8ED9A83FE21601C0E2A6B73F624CB83EF42A81C24662A4411CC4004095D6D640E276CD41F2C400C29E29A7BF3461543E5F68E2BF9B11FE3F2202A2BC6605843F550922BE9AE1873F4029E6403CA7D9C0647715C1AE522D424D3C733F19A13EBF4F0DFCC1D7638CC1FCD41DBFDFE815BF12D41C4007CF523F129C13BED95A31BF672DB3405F80363FEB5C114376D819445C3DAB40DF3E40BF4795AB3F372D4BBFEC6192C13971F6413B38A1BE93F191BFD1BDEF40E12F8F414637A240425832C18A901DBF5253C23E8920DD40E34A4C40397B26C08BA905BEAFF5113F04B4AD3F774BD93E662D723F30606340D42CA0C068A9704028F5B2BE9731F8408511B0C17056403F529D08BFF6C417BDFDFE76BFFDB3B543C8199F44962625BE1C24423E401D70BF8DEBA4BF2450343DEE207E3F0870DA3E507980C0BA4B06BFBB13923F105127C152CACB3E3CFA4CC06A934DC0388F65C0B9CD3B40E4892DC1A460E73E1F4B5AC3BA481F42E78366BE91981ABF03D5A8BEC3B1603F1B6EEDBD4D0BC0BFCA5011C08B5736404B1141C019342C41D9DDA6BFDC8D49BF618AE7BFDB8D01C0F9E011430456D1C3EF418AB97ED197BF20CE0BBE55EA2F40E2E3CA3CA192B83FC1E51CBF23B084BF34FF0DC23C577BC2CDF7873F0201E53F20CD863E75CFA73F2C62183ECBD755BFE233EFBFBBC73C3F2488DE4009DB4642DCE9A6C0724C2540A2933340FE2245BD2715873E233A123F9E5217C1A15ECE40E5FB6443CA3C0BC36468943E206CBA3FBE664D4174F5E4419066B3BE8DB1B13F138CA1BE7DF908C0EF9A60BF25CF893E76D9A7406C2B0F415FB6F83D26B933BF769F98C11E648E40836A003F3E7F88BD78D00EC20F06194212E2B6BE28B7AB3E3E5815BFDF5599BF0A21D13E0396BDBF16C11D3F3B133443B897C53D3742BEBEDFAC77BFDBA197C155048F3FCF3606C0A4C48F4107E6F140C5F6AF3FBDC8893F21D817BE1D1719403AFF01C16952D240592560C3C601EFC3669213C0F21101C1139E68BDD743813E8A77043F0261CB3FFA4902BFECADEEBEBF5AFC4187C20AC198EA1E408D5C7A41DACF913FFA677B3F900A7540DFB82C3EB9631F4108952AC1D4378D3EEE8CD2BFE76099BF03CC77408F93433F0C289ABE2A7F27BC5B1F84BF7703783FE6F31E3F3C938BC1A50597C1DDD4EEC07FAF81400D59FABE36B3F03EAF4B0A423A736642734C3CC01F89D840E9602ABECF69E73E83FF18BE867B4FBFFE6BB03FA7BE283F9EABEA4132364AC27AFEAA3FCC02513EC06BDD3EA69B2D404812053E8DC981BFB3F4CC3E8E4B92BF64AEBB40CE1AD240376FBFBED9EAD9BF16130CBF77A80DC0DC4284C1ECCBBCC1703708BF91DE0740260A1741147388C1A78933C35F628443414D08C19A8B80C1BBD3A03B095F6ABF503A52411A1959C0161E7440E951694084920EBFAA78ACC07F2966BD63707DBF742CB7C075C3CCC0AF7967BFEA5C44C048479DC1A7A73043908E93BFB23C343F56FC0C40C9EFC840C41422C114FFBDC01B736EBF4A834AC0B40E333F147E09BF094069C38F336242728FF8BED478CFBF85E7833EF51C883F50446B4227D006C288D1844287657EC281923640E0CAA7415BDB14C3C2B837427CD27E41E3261040BC3CAABFCDF13CC0B28B26C05D234241C443B6BEBCF46CBEC7B12FC05B1496BFDEC253C2A8AB8342EA81E3BF861AE3BF5EEDAEC1A84F29C284A57BC0AF37EB4088E20FBEE0089F3F136C3FC2AB9DB4C2BDDBEC4233EB65C287087041EC48794260BE15C0D5D22541DE9F19C178DB05C29247ED4037F8BC4091D98DBFA1F1DFBF0BBA02407921103E2E1FA1C150F94342FC13AE40734397BE358EF53D05CA28409FF2FEC36ED03544D50B993F8A212BBD69E02D449E5F4CC22C5C1CC142CB6241CFDB59BED0C9393F00844F414110AFC2A3FE983F89B763BF28AD07BE31C709BF5345F2C1FB9C844177F7AFBD7E7F94C0E69EDF429CE25DC20C170040279165BFA91DDD4159B38A423639DB3DF1C76FBF4207ADC0A0B9D8C0BC203A4064F4284052B4FBBE4F8B8C3F6158A6C065F933415999C33BF25073BE3240D0C027ABA3BF6E70A6BF8A6EF5BE8BFB9D3F2660273F82778FBF94F5A6BFC22EAC3EA274DABF76FAF43CCE175F4020D697C04D7E1D40478E5741966AE6C029C58EC0E4DC964199AD82C37C6D54448298D9C19BD5FAC19011F0BF9B63BDBFE78F3D3F291DABBFE7C7E33B6A31873FDA2F0841873F5EBD1B4E1C40A21E92405DC428C00F489FC18DCBEFBF537E8B4090E765C5BF15DDC55284B3C0D1B694C0B0765F3EF819C2BE2E0A06C1D3C19441467E2141D348FDC131B42D405B906BC08FB31B4248D60C410D71D93B094B803FCD2CA9C3FAA5BDC0CA44DDBF00FA7640345172BD6F36B23F1BEBAA4024CA20421AEFE6427F1FB142CABD5AC272B7D7C04DCA4D3F97FBBA407C499F3F5123A2BD83D712C0E5DF33C19948483D860A6D3FF6FCD83CB13D59BF979340C0546864C06D6D2EC0B69558BD9C784C42569D2CC2FDE2FEBFA9E421C0A85EA5BE91E1B6BD64DE02BF258C3F402F5515C0799DB03F27F7A6C2BE310F4296808DC1906FB8C0B843613F85CA314095AC99419D3107BF45CB40C0BECBC0407F5361BECD2DF83ED2390EC116B15641FEBEC142ABCE04425C378CC0B93C4640150AC4C17CEC88C163000141131522C111BF01BFDE3785BE817327BE582C6D3F40163EBF4036BDBFE7274ABF1585BB3E6E7F1341C112BABF453B283E4967D4BFF1B89B3CAE4C5CC067CAC53F4353EC41D5225AC1621071C06CAE3F42EBD4CD42405EAC3C60C5AFBF3358003F790CEF3F07FA89BF990DAB3E544D28BDEEDF03C09E1F33C183EACC404256BA3F4A34E7BFF24866C2DE1AE9417F1AEB4085B49E40B955EF408C590FBFEF5FE0BE19F4D73E5D812FC07575BF406D74C0C16DFBC0C129411F408EFA8AC06B88A4C2478DF4C2B98C26433225BFC36793B83FE95E5FC057F73D4087BD304163838EC0DBE088C267D2473F41BD993F6C1DA93F3FC44AC0F73BA640DC06C43F54E9E03E5D05B4BF2A9AF93E026554BF2C141D3E82D8E43DAE1929C2145CA23F"> : tensor<20x20xcomplex<f32>>
    return %0 : tensor<20x20xcomplex<f32>>
  }
}
