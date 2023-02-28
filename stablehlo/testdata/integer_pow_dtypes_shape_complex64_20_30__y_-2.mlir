// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x30xcomplex<f32>>
    %1 = call @expected() : () -> tensor<20x30xcomplex<f32>>
    %2 = stablehlo.multiply %0, %0 : tensor<20x30xcomplex<f32>>
    %3 = stablehlo.constant dense<(1.000000e+00,0.000000e+00)> : tensor<complex<f32>>
    %4 = stablehlo.broadcast_in_dim %3, dims = [] : (tensor<complex<f32>>) -> tensor<20x30xcomplex<f32>>
    %5 = stablehlo.divide %4, %2 : tensor<20x30xcomplex<f32>>
    %6 = stablehlo.custom_call @check.eq(%5, %1) : (tensor<20x30xcomplex<f32>>, tensor<20x30xcomplex<f32>>) -> tensor<i1>
    return %6 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x30xcomplex<f32>> {
    %0 = stablehlo.constant dense<"0xD937B2C02F5E9EBE9623103E92B6B3BF4C75B3BE7A2B4940067A67C0064569BFBC3FAD4067DC78BF62E28140BEC421BFC800DFBFBFAD89BFD850953F8612843F760156C055489540C3030B400F6D5840806D833F9930FB3E5EF8AE3F4C796CC0E4E844408DFADAC01564CA40BCB62B401EAC60C0B1FEABC03D922FC0F123963F27F7F0BA59A93CC0A93DFABF505BA43F2A0D0EC061B524C08EFACA3F1AF2524007E0A2BFBD0B87402372273F808B88BF727B8D3F4DA45F4085578A40AEFD3740603796C0332CD03F7665BABF81919AC061689C4088AD324062C43D4082621EC050912FC066186A4026AC7FC0E83F52407ECD3A3F8F198640F23524C03F045740FC4BA4C0880A773F867F11BF6A36BE3F99D9EFBF7C809940448243C0518281C07AA79EBFA925813F0E12713F49F215C0626B23C0B2BAC1C0BF24F03F086C5DC0AD4C27C0193709C01B9246404064B0C01ED0ADBE371F62BE65D54AC0EC75A4C01C0A60403BD3AB3BED30C13EEE4B58BF4BB96740295DC5BF25A35C4045B7103D2F09EEBF6BE95D3F3DA9973DD68E2DBF073622BF25421FC032D0CF3C6D4703C070B8A0407D27884011EC5440C6F8CB3F89B53E40A4A221C05474EDBE888E6CC0AA59C03F0921993F0B94BCBE4F5DEFBF452376C08BAA19C021EA57C0ECD52A4071020F4092C910C04849804008039D4013439FBFAAC9C9BF352B59C0BD3D0DC09E2D4BBFA2BB0640A9E555405549133F0BC2A53FEB8C9F3D7F214E3FBA2C9BC004ABB9C090C4DCBEEFC123400806663F8ADAA7BF97654C4066D7ACC0762B3F405B11B9BF63F286406407A8BF5EE05DC0AE97C3BF9013A23F9CC5ABBF63E146C00E1948C07AEC9C404990AABF5E7564C049B51240E45EF8BF043980407AF3ADC00338C4C06512A83F7B82923F9529464072F9133F745F27BE6C4B8AC017F58EBEEED3BFC071F3F03FF09B464003CC55BF9E8409C03961124019E0A8C09FB314C0080848C091C8BBBDC6B920C047978640604999C010DA15409D46F6BFAE1F0D4079C3824037ED6640F41A5FBF65D24440EDC69A3FC8423CC0B2FF06C0DC538B3E79767FC01A8B454090A2C1BF4049EE3F838CF0C0E3946EC012C6B43FAF491ABF0784B03FFB338BBFD41B15BFE9130640626898C068CC963F034AD4BFC012FABFEEAE1940BE68BBC06701D33FDE27CE3F951DC93F56544FC04E98D33FC954EBBF4C41373ED052BA40A4EA64C0DB43D93E2D401DC0FD6C1B3FF3E0394035D3843DFDFE41404ADC1840203A6E406D0F1040657C93BE70D158C0DA3B11BFC0738DBF37148FBFCD2219BF1DDA71C0EF3A2E40B4291E4156C5503E92302CC0564A3ABF162EE6BE172BA6BF3E0CA93F5191763E50681440444776408B4D994046D24BC07AFCA440C68822C0933D8540580A1D40AC1697BF7D1664C0490C3740C07B83BFBE496B40716695C035C1B640C35AF14093A131C09F3C7C3FF9370AC1CD699F3FE6BDE0C0CF96504006269E3FE6BAF23FB8BB683F64FF80BF933F5440C8FA6DBC994F12409F6DA0BFC4FA8E3F8CD8F63F0C41E5BF7DD406BEA7B2C74006D60640DD10AF3F04761CC01EB4A3BFEA80BDBFD6D55AC0162E843F29F1074061B1E9BF155F3F40C90E10407817E7403E273940B265D540DD5B13C038E705C1649EB63F0215CAC0814898C09CDE14BF95D20F409DA14A3D2FC1B040CEC0DF3F1FD1873F52C9F8BF5DE5873E0D01BD406761873F44612AC07E0C09C048BD95C04A70613F18AF273E565965C074C9A7BF27FF3C3F7D1A08BF40381BBF53B5A83FB679DDC0E78CA8BF8320F53EF284E03FC7BAB3BFBC108C3E034663401FEA9E3F2A2556BF38EB8FC0E99E9B3E7C6F8240A4C65BC053548B40FC3BE2BD322CB13E0D652840893939BE36D95EC08219043FE7BCD6BFFB97A840B6DD3BC0A2CDBE3F8AA811C0A180A0401F8FA5BDD2ED05C0170A36C0C4373DBFC6B8ED3F13B189400E649D3E03EF7AC0EF0809C080E37840E7B6F3400985CE401F5E0EC0F6B3CFBFFD92F1BC7D3D6540D54B8040FF593B4010AA9ABF744346C08CB25B3FC1CB8BBF212F8240AFAEB6C0590EC0BF9F041BC077C880C0EB667440990F803E2D445440B74BA6C0694D9A4036B48DC0D669F23F2C8E44C0E6B2E8BFC5281740E3C137BF319E4DC03ABC2EC01551173EF534123E1EE69FC085E760C065497240A8253D4077BDF6BF67298E3F593876BE0275C4BE4BD004C0CBE76DC0E0C13FC065242FC0C638FA3E2A0481C030A635C0AFA590400CF6AB4034E6823CF7F48140B39D54C0608E2EC0EB691AC0E686AABE935FAFC05B728340C831254096888C4066EC85C0517EB43E99E4FFBF924E11401AD75ABFA82A62BE8E6CAEBFC56065C05A0DA1BFDD63C7BCE25EF83F9F69133FB6E94DC0BECCA3BEA664C63E8A571AC04BA60C3F41DA20BFC35802400D7A95C0E8D74340EDC7E2BF29CA043F9D8ED03F51B57CBF9A25F83FE035D93FA55A193FCB22AE3F7E170E40D9F74EC06C35EB3FB4D84EBE9A44043F368436404E8C41C0A25131400C16A2407459BABFB08992BFAE081E4065A713BF9AACCC3F45012EC089B87840547C81BF3F1294BFAFE58E4006C88CBFC045F8BF8D04A33F3CF397C09A303C3F098F86BF99FB15C09F66EB3F270075BFF9714F40DB12FBBF6AFC3CBE91B2C4BFCF7801416D0B24C0E4D614BD0B2B61C0531E983E7473B43EFA17D7BF539D9440063EAD3F26D2EDC0C1694C40922202C06982183F91070440A08442BF76300DC0A4205B40B40330C084EF87BF788D10C050DCF53F8ED60BBE3ABA98BD915A0FBF0D700B40E18D633F7D901CC07A5F9D3F187B3B40DE90B43E1C2889BF521CF6BF4D0C283F144199BF43AC3240819D3D409ACC26401C9F4BBF54930940557539BE5779A5C00AFB35C0A0C9483F1CC3864009EB6B40472031C04F5D69BFC12F76BF638E88406B8B80BB62D0CB3F79C8503F1DF9634030AABC3D14F11A40B26BA340B3953FC099C982C0A53184C0FF1367C086D441BEF6F00140A799B740729944BF934DD740E5D1A4BE85DA0A4053D08AC0096672C07D305B3FCAB494C0EC8903BD13F6F6C0FF90A6C0BDE78A3FB90156404EFBAFBFC7241B40C5CA8CC0F8B448C047E5D3C0302EA9BFDABCC6402210D8BEEB0808409AFC843D3F1FE63E14E21C3F26D4C5BE6EFDE23F581FBABF5D8C3A3FABF383C057F9F83E91EA7C40D9837BC03451CE40B7CA61C0CC8B9FBE35BFABC04005493FC1488440F7A3A0BE1F457A4069F60540E08A8BC076149ABF950D00C0384443BE97589C3FF28F43C095FD88C06A84C43E5D376240E6D13540455AB83FCD1A1CC00F6854BED1FB7CC01BD836405681563CA4CE1F3F7D7B48BF5396B63F6871153E0E80AF3FCB8F09BF5594D1BFE039FB3FBB534A3E48FECA40DDA5E2BDCAE88D40A5B8CC40FB3EEEBEA37C1DC0843792BFBF54EFBEBC402940FE01FB3F64F5A8BD587573C0F377553F25F8933F43580E407DF9D74073C6623F9A3B86BF6BC93AC0723B8B401262864037D635C09F5668C04B6D26C06194FC3F926377BFA3985CC0B46D4FC0A740F3BF1949C03F4C40C6BF2A4DADC00E7B12C003C01640219713C030D0DDBF91F738C004DA8E40898FCBBFEAB299C0C14C85C02F878CC084A98B3E53F776BFFFFE41C02F124C40B2C17840099B9B3E2C98ECC015761FBFDC9D6DBEBE628FC01A3E154087BF7D3F1B2606406AA2A0BFC5D44F40561F15C04750B3BF71160F406C565FC009E9A43F4CAE98C01B226340655D2240278220C03A3C2F3F33BC4140127D8640B8B1443F9DA828C0E144243EA8CBCABFCC1462BFC2948B40EB3E91BF4F340D3E4A836E40ECB2A9C07C22BFBE053DA5C02BAB0940FAE1493FDD8F9940356C583FB48319C0B7F623BE202522BFF8EA99C01E5D7BC07A8A65BFE3EF16407223053F520606400C68FD3CCFC9DABFB9F1483EB43F2EC076506940C386EABFCC4DA7BE42457A40635DA13FE6E7DDBE4BBB9E40106BA83F6481374014285EBEFC691540B310D2BEF97342BF91C1B03EE3A2344060DCCA3F85DDB53F253A12406F331440649314C0891AF6BF25CB00BF3A7C903E4C7F3ABE3E1BB6400F22583FF52FB03F51CA143F360E41C03CD85DBFDA1B88C0BA9197401FC21340C68727C059C6B43F9A2878BF5F509B3F14491A3EA9C00C405F570E41264D4AC070C0B3BF3BC53DC052488440026E084063EA1B3F230794BFA42405405F10AB406DBFCFBE8CFED83ECE9183C0A2DD00BF48F38CC0B18CBEC033428EC006E368407AB13D4015C4F53E22ED2D40E2098EC0EE559140C15734C0B8EF5440E41206BFEA2A2440F6B55FC0201010BF2C737FBE276C1D40264DD240A05E5D3F0D59B0BFB137FCBF5E35294043649A40941EC5C036BB854005DF1AC1EA0F584095F5EFBFA15DAEBEBBEDA33F9B6D8340C69F61402FD5B43FFB0516C06E127D400C616C40F8A0E7C0831B08BDFFB175C0E12F6440963C623FBF4A24C0855E9DBE06B0123F9BB5D4BFCAA2D640BC1735BF053639BFB10486BF92598CBC2327D2BE77AEA6BF8EA535403006B23F01B7E7BE75598140AA61E23F21A3DDBFA8EA643FBC6529C0C01F373F2D5069C0DA125A3FF8A4593F54F974C0A940273F2EC10E40C7F53FC09E69BEBE167DC4B6ED7276C058180BC017FA7FC050C47E4032278D3F88723E4017BE08BF7753613F7466B6409DD48ABF3309F5C065F598BFFAFB9EBFCCC783C09D7736BF7C8448C08F7B31BF1CC9DCBE09A045C00B60A7BF3C519840835EDDBFB8F14D406C6E2A403432DA4046E206403707C7C0A9978FC0B5B4893F3FC7B73FFDF1F1BFC56842C029490BBEAA9E89BFE1C78D40A43A18401A3F81BD47E0CD3F67A2733F38BA2B3FB84FD33F9AD19FC0256DA5C0459B96BF12D2E03E57DBF33FEDBF0940A48D08BFA0984DC03DE8E9BF737936C083CFF2BED8AF4040C99B8CBE7EB249C0E5B5F83E5C398CC017B519C0A3800DC0BDF385C0AF1ED1C00CFE96406C089BC07B63A240F95A7FC000817EC06A3C63C06AC985C01B78CDBF00A9643DEF2B9540863767C032673AC0D8D438BFF5D5DE404407223F1038C13F6217CE3F144B9F40E0612BC0FCFF89407BBA04C03F8E953FA5B3933FC40105C07ADA693F2E982D40A9228FC0D3330FBF9F9454C0D6D276BEB59F81BF7A0F22C08841D8BF12755940B06126C07F5DB9C067E4F13F2804474030BAF33F8C3E4F3F1FE4623FA3CE8DBFF181723EF743933FEE560BBF8E17D040CF833CBF0F817EBFBBEA23BFE7B9933F944A02415F25F1BF2AAD224029AE77407C377A40BDA9A8BF976AA73F46350EC00B4141401E48593D4DF54340D9F786403277F240ECCD8240866D50BE88F068BFDDDF0EC0F1F979403A7A4AC0927699BF87B84DBD3E2E3740AC11AC3C39030640F81CE13F0D27814076410CC0D2D08FBE660E4B40C940C1BF28129C40E0512F40EF2A37C0349BE5BF1407363E0524BCBF749EA8C0C4C5F63FB7B837BDD49E87400C89F2BF5D72B23F0E1D2440295F2EC0D9E29E3F8E501AC0308DC3BFDF58973F41E7A33F114F61C08FD584C03C6221C0F7FD91C06F8125C0DAD1F8BEEBB591BEA71D123FF2AB533E8353C53FFA4D45C0731478400143223F30FD28BF517D463FE1C747BD570482401947FCBF1D5A6D40B84469C0018AE0BFC9B5583FACB232BF423715BF528F02C0547FBC3FA79FF73E5F27CBBF33BBB740873CA5BF972831C0ADC260403F4134C035B1D7402CD9A0BF99D252C0C89BA93E82C7A5C00CD3843F74326C409EFCA83F6065CF3E122AFCBED8AF9FBF5C208ABE12A5673ED8835F3F374F29C0A03912C02A0C4540DA7C883FB64A7C40EE120A3E1B7F8F3F072ADEC03025743F17AAB33FA86288BFCE0276C013580DBFC2E1F6BD8EC180C011C5F5BFD47735417D34B1BF6F03DCBDEDE7FA400B3712BF78BCB5BF543896BD8D9AC0401C14E7BF49AB2E40A2B53840C011F43EFE37503EC16148BF034C5B409D59FCC09609D440F78C8F400307FEBFDAA76FC085C119BF7023703EA57181C098599840F4AFA33F6E7E15C088AEC3BF25A3A7BFDD3F5EC06CB99BBDE5BA02413DFF143FC77CF5BF7A7174C088B915BE153526BF64CE02BFB2094F406779003F67DE9040CC5ACD3FD72903BD2C1C3940C3F26140316DB1BFB29179BFD868B9BFE7A164401E30CC3FE1747CC0E68A8FBFDEBABE3EE8923740BA340AC0AD19CEBD66337CBB051001C0A88B39BF836EF7BFE59DA0BFC72A5FC0585B8CBEECAB0B409FC360C0C2E00340AD454440BB940941FD96B13F840B03BDB990CA405E9EBCBE4A89C2404A35D03FDF7F903F52FF394040378440FE480740D1AB84BF94C2304054F7FDC0D39C3140AD1458C0C62F36BF57711F3FB913743F7CB8D9BF18D1AFBFF022983FAC5A013FDD762DC1DACE9F40440FA1C09E085A405E8E274093E1913E6EE046C04DF5E7BF800A9CBFA7571640986F4DBF6E0F433E8D3574C0BF57D83F5AFD0740056DD2C0B64B81BF51AEE33FAE4DB7BF163D53BDCA7B0740ED231A40A69E60C0D87CFC3F26021740503F12C07F057A3EE1D6FDBFBE7B0B40955489C092BE4F3F6E1EF63F9B73B1BE5CC7A4C091C40540602D953E41D34DC024D78BBFB1E900403F89CABF0457BFBF84E8A1BF814CD3C0FBD08F406F4112C05D11C140309FADC07FA112C0CCEBA8401514403E6DF231BF97A3104044EE30BF62CC7BC07A215EC07BF116C023AE2A40D6C233C09DD515C08FA948C043AE913FDE8361C0"> : tensor<20x30xcomplex<f32>>
    return %0 : tensor<20x30xcomplex<f32>>
  }
  func.func private @expected() -> tensor<20x30xcomplex<f32>> {
    %0 = stablehlo.constant dense<"0xF1D6023D9E4069BB3808FCBEE231CC3D5FB5C7BDCE65B43C3CA4813D04800BBD50D6FD3C40623C3CF640673DA096933C37E2DA3DD25E5ABE74334E3D4984D1BEC1BD1FBC807CEB3C72E4D2BC9E9966BD8E66F83E2CCD19BF255C48BDD0C12B3D7F2941BC0FB4593C6F3C713CEF9579BC24CB1FBCA502B6BC40F39E3D3E56A63D16AEEBBD7A8216B972B6943DC5C52B3E756950BC9165AFBD72113FBDE9396FBD15AE2FBD7B12E93C104D94BE84B6113FD67579BD895C2FBD8B166B3C08220CBDFB62023DE356CD3C2A1D06BD2EE6B1BCD657833C3BB4DEBCF96B443C0316873DBE775BBCB9193C3DD295EC3B213B163D8D0D55BD5A0899BC585371BC6A1F5D3DB5D60B3D16F7593CA1A496BE60F9863ECE17E3BCD25DD13C00AA2EBC883419BD08B2A23D1C46C43EEEDBE7BDA04ADE3D787084BC94E487BC824110BDDE9F5D3DC83E8C3CDAB6AFBDAA7154BC3508AF3CFC2E1E40E85CB2C03FC649BCE3C6C8BCA61FA73D9F2C80B9478D47BF6DA35E3F3B47373D04AF3E3DA843AC3DF7FFE1BAD1681C3EAA4A3A3E135B06C01FA5ED3E246308BE2F8C94BD794273BE7591C03BFC9D783B287EBABC28AA3C3D428B6ABD6A03303C3569843DEE018FBDACD891BC92DE783D8A3E87BE766A82BEB0C8D5BD37FDAE3C3F0633BD5F9C4B3C0864573DE326A0BAB388CA3D69B6A2BBE5F4C7BCB1F36BBD32EF76BE3EBDCA3C1C8464BD59F317BE9F8D053E7CD2A73D9B2DEEBCEB01173F5DE191BDD66A20BD12235B3CA558EF3C4C168FBB3A55D93D2A1CAEBD1C7C74BD3B7D713DBD9E643C5322B63C4FBD22BD96E9FC3C0F4F5FBD5F6B45BDBE38413DD87B7F3E2C1D75BD211E82BDB8684CBCB294DB3C561E55BD5DDF38BDA1FC953CF7EFDF3DEA98D4BB9295AB3C240EBE3CB59D2A3CB2BF8EBDD77D74BDBB1A17406EC4B93F0694583DA0D1E0BBB740AA3CD03E6D3C6384AB3D980C473DBA84CFBB448DCF3D1260A63CBAB9B5BCE11BD13D6979C4BBE4EFA1BCF842163D3305B13C2C61E33C079B81BC32EEEC3DC681883B2BC508BDF2A4AABD8752523D83EF8FBDCD658E3DF8F65A3E86CF653D64E8213C33B41B3D1B9F11BD7F322E3E43D80C3C544039BCA13E963E91C89C3EE6C79A3D036CA13E0B7F39BECD92DF3D4589163D7FA79E3C1283CABC42D919BEB99C91BC1F8A8F3C6B6C8F3BC6BC40BEB09F43BD7B21783D99F28DBCBC92263ECEF2F0BC5D34EDBAC079993D4EBE933CED750D3E3EE9943D506DF23DD751ADBB24A9803CA4B385BDEF14C93CFEB23FBD579EAEBD874A6FBCE363C1BEF2CE06BF5AB6B03E518404BFE9306F3C6B1C333D5174273C1F21DDB968B2E33DB4E484BD452CD5BE02C4A7BED1E8043FDF8548BEEF9DBDBCBB6933BDA49E3F3CC93FE43CFE27973CE59CC43CD2E8A93CD66719BD7A2769BD72792DBD0215AB3D3E168D3DBD9DD9BB4C83E13C998D46BB3F3230BC1241B73D5CDF943D66514E3C7B01733BE772303C05B7503C2184A1BDE2DB36BEFC5164BD013C0A3FD532BA3D9AC6503A2D09A23DB305FE3D0D2ACDBD30D632BE300B9D3EF4B939BD8530963CBBE764BCE38E88BD6968DE3DAE811BBDEF5884BE00B1853D64B6313DB3DD9C3C050C013E98C3A13C2A808CBDF8D6433C83E73ABCF286813C22194B3CCD7A563CF6A1963BCF70903B0AE27BBCAF3026BE355EB83D0D3806BD7BE119BA7808E23DE73D59BE832D803E03B18E3D4F64D53CA6E91DBCEC68963CC75FABBD234E283DD258833C177B9EBDA439E83B2A876A3EFA72C13E8EC54DBEDA25C3BF037B99BC36A0F23BA2E6C73EB980A73ED39C313D89EB453E168A9FBD50D145BC5A972B3E75BCD33E09BF473D7BFAD83B9AD1C33BD1180E3DADA4573DCF2F2F3BEB730CBE086016BDF58DA7BD99A40BBC117789BEFACC3A3EC8066D3C8A82BF3CAF205DBD6BA3FD3D60B0223DAADBA73A5B87C3BC07CC9CBDAC333ABE471A303E13DF593DB851FABBC8E2DD3C3CAA2CBD776003BCE77B35BC19768A3CA3A3583C8341C23E450262BC767F7EBBA6D00CBD07BF903D1E08903D3DF1A93DC6F74B3DE5CE47BD9139E73CFBBBCC3C133667BC4DD5ADBC940B24BD60A48A3D97EA11BCCD8B35BC267FC33CECEB013BAC70BE3CD5430DBDEB8F8C3D4300ECBC93DDDE3D6002ABBD92DB20BDBB2B083ED7886C3C5FA523BD5FC1153B6E8636BB0618193DA49C043D8089963D327E343FA0FDA33ED0B756BE146DA4BD05A2183C4F962FBDAEA2F83D0776373D804C633CD89C1EBD839F63BB90ADA3BC395678BD3424FAB908AE2C3CBB7459BDE529263E58113BBDD500C43B9D9FA73C179699BC4CE809BD80EF643DF05F1B3C439262BC70FDDD3D18A68F3FBB131FBF0B3950BD321839BD5C86213FD60CC8BC8B7E513EA35808BE2112C03D7B509ABC7E0023BED413573D5B1B44BED417B63F47AFD6BC0C27E73C091B233D7D0E8E3D1DE28EBE31784ABEF988FEBD21F92E3E321F763E978046BEA82689BD0C9106BE498B173D36587E3D82D018C0600C0D4065555EBB14A66C3DC39184BC28F2CEBCF4CB8C3D290E91BE59C60E3E58188D3DC21648BD05E8B33DFDC15D3DE1ADF73C254728BD17EABA3C8179D3BDFCBE30BE0AB912BD609CA93C629055BE9320123FA377DB3CE62AE03DA58B96BDCFC7423DF296813E64D444BDC1B060BC4E10B13B38C41B3E635B8DBB99F4A13D08665C3C310A9FBE7B900B3E5FA2133D9C12BCBCE6502C3C8CA9353C0307403EA72CF63D5540213ED16D093E2A13CCBC5AD4603D847AAE3DF65C9EBD52AE953CD3F1E53D60A1B2419DFF0AC2374731BE0526C33D6FCAE7BD2D11C23D37228EBD6FD190BD91D821BFFDF3EE3E5A47443E61B4173E52FC98BDD4CBA03D042C063C7A7582BDAAF813BEF4BFFD3DEC9D18BD30422BBBEE1ACA3D105B713D6E7F8A3B1E9D01BD91FEC13D7F588FBD295D41BD26A0B73CA6EFC9BED7B8FE3ACF168ABD1D7605BD82F42DBEA51F54BC4B6C643C78FBCB3CF10DA6B94391F2BC26CF9B3DDE0D03BC2BEFABBC9C1A8BBC790AAEBC0205A13BD3AF4BBE4A38773DEB43853BA0C4F4BCEE652BBDDAC1823CAE8889BCFD8212B94ACF043D0493673CECB95E3DC4695C3D9670ADBC6D36093DEC5F41BC40206CBCCB93B9BCC978253CC68449BE259AA63D9FD294C0D2ACAFBF1846523FF80DDC3F9899183D1DEF3E3E9A735BBD7220A03C37A97ABD2E8C7ABC0CAE03BC136D7F3C40BDA03DF0F164BC1E61053D33871F3C88956B3DDFDE0F3CD7EEE63C52402DBD4FCE2B3D405ACDBC0CEC783E5B873FBD810289BDB35D823D9E2E5A3D41C31D3C0C582B3C698442BD088A76BDDB80DF3D21FE81BD4FE3DABB5AE6FA3DFD2C93BA2B9F63BE6BD0783F5CDBF33EB2B3C9BD0639AD3E706AA03E66D1E0BC69331A3E04FCCABCC683CABAFEE24FBD5C1D263B4801C53C4B7C663B5597B33DC18AD4BD8A6005BEFCAE423DF26F843ED49BB23C0850753D94F3E13C674CBBBDED6105BE42CEAA3CC17DB6BB2A3EA4BDC38787BD41057E3A38E3DFBCB84139BCD0173BBD62EFCE3C2519B93DB58688BD732B26BD7FB00D3D16387DBDDAFAD6BB0BD95B3E7428A53CBBF3A9BCA678FF3A096EBC3D4AED29BD05159FBD134F0D3DC6A1E63CBE50653BCE9FC8BC7CF2513D3376D13B622AA5BD2DF669BD9468FDBB19EF1EBDD01995BCBB74C43A1D16DB3F4A89BDBF5536B83C5A7A033D03B6F1BD523913BECE1E7ABDC542633DF6F1813D0FB6F4BD5058C7BCEDA3583D8FE710BD01D2A83CFE4D8B3CA6A44BBDD381023E28F3993DF18141BC3DD110BDF234E5BD0012923D2FCEC5BEFAE2A13D74843EBD01E3A03C93383E3F32B33B3EF32104BC0176B73C913A17BD3FD9AFBB90DB143E662FFCBD5020223DACCF6BBC3F9D2F3E4768BCBC241828BD373434BC7D5F633DB50CDBBCE8481F3EFBAE93BD5A59693E5DA6DCBBAE76A83E5BCA9C3D2CAA60BC79B53D3DE5B28A3E3C63CCBDB0F3443D22B70DBD49B422BD9C35E53BF02F86BDCC019CBD981437BEDC4A093DC7533CBFCBA08FBF76D4F5BDEF33F4BC12C5C43C93AE60BE210EA6BA8382C1BD2CF5A73C6174DDBD968CC83FF0212440452DFCBCCF42013BBC0132BE0F08AFBE0D7BC9BD5545213D0B0E48BD9118AABC87C3B53C5169E8BC52387E3D967AC13D0481BBBD3708CF3E46C150BEB5E7E5BCC2990E3CF5F3E73B501771BDAC3293BD4397DB3C19421ABDD08DA9BE8F21F73E3678B7BCF348A8BC817201BEDCBA394023AB673D505C66BC53D3AEBB9BC98EBCF430C43B8250F33CD38DD73D7F650FBDDF8389BC75AD063D7FB37E3CAF76003DE3CDAB3DF3D8DD3CE9B682BC24DC4F3DA9D8E23FE64EFABFB7F77ABCA0775ABC794428BE6B43AE3E5855D7BCEA80B43DE33880BB89E8813CFD27CABB9F8ED63B0E35113DBB2A693DAB09FDBE73D0903E8E84A93B07320ABD226B7FBD58BEF13D2F82183BE6930BBDB5579C3CAEBD37B90D2D303B3ECF143DD2F8DABD7C09AB3DD773A7BFDE37FC3F1CB797BCAE2F203CA8E4B3BC7CFA79BF2456693FF96CF4BCE601E1BE0E7E9DBEFC3A7B3DA703A2BDDE7371BD50035B3C158A623B0C1D273E25A0D0BD3B209F3DF16289BD2B4DE03CCF49B23AB8BD30BF7D22803DF236B43C66BEA8BCBB618C3D955DE74098BF6EB9068BD83C8E5833BD65081C39D7A0003D913E9ABD168584BDA7FEDEBE1439563FC352E23CB5BB323C6EE7813C623AA6BB017738BD8ED0F4BC6BD8B2BDE6A02BBD66C7293FE63BACBF897A7D3D4DCB82BD50E8F43CCA08CD3CECA72F3C7BA266BDCCC7843CFB8035BC24ADAF3BF82A84BC08B2B2BD5AA998BEAA5B0DBD6F8A8FBDE31A53BFD22259BEBEFEB23C2C0007BDC400C5BEC9BBF73C47E97D3E5FD731BF54BFEDBC2D74B03C745D033DE0427CBC20DF70BEF786EABDEC26383E9E7FC23D253F193DE4E080BD91F3E73DFCB61EBDB25FDC3D5F29A23C2E11C03D7299F23C0781B03C20460ABDD011CEBCABF416BD70AF9E3B6A5E6F3C37B076BAA13EA63C51BADC38771301BDCA67B0BB915806BDDBFAC53EA697DC3C650EEB3B0F12E43C121DC93D7A7954BD32CEA43CC1A971BBF5A158BC0AC951BE8D4E8D3C61F1D53C2D5CDF3C6BBA0B3DA78F973BDAD8BDBE1E5A063EA664123E4F648ABC2CBA043D2F8DAABDC07CECBCE5E852BF85DCD4BE55B4293D6113CCBD33146A3C4AFF573DC533B23C0F1F823C0C0D0C3D573389BD1D6280BD44F130BF5807363F3819A33E3675C83E3F5CF43E116DBA3CC014AB3B7471973E82AE26BFD6AB68BC569B86BB8608EEBC50BFC33D9482B0B9E75707BDE20C0D3B0788943E1E5DADBC9F1D8B3D4842DABDEF1472BB4995E5BBD22C39BC1D53733DAB57C23B09FDFBBD2C58F6BD46AC063C56961E3DFB28313F91E76DBD4DF4F93D0FCEEABAE43ABD3C30E206BED984D33C0CDF223D4BBAC6BDA5DC8D3C37A701BD6B8EB13C5ABB36BB665C823DCB819A3E0B69773DE636EABCA7B08DBC2B87893EB3E34C3C4D76FD3CE3A00D3DDDB582BD28C3C9BD0EED953D2065AC3DF6B2563D2948E3BD707AD6BC3F03A8BE84A0B4BBE56708BD2162A0BC1C47FFBCDBCE093E8FC356BD845DBDBFA652FB3F0828CCBE0702DFBDB65616BCB0B2223D8C9146BDE1B5983F7368D23F409E543EC7ABF83CEFBE1D3DC13C283ADB76173D30F2273E694B533E54DD5C3E414B98BFAEB54B3D8989193E1C619ABE2C6F4F3E06C7D53C8A7E4A3C3B673FBC3A2D473DFEBD57BC7C6F5A3CD5CB75BD56785BBD9FC116BD2CDF9A3B07DB6DBD4A3D11BD8E47DE3E7C9396BEB2DBCFBE876AC2BEC500B43F5D35FE40900CD4BD39149D3D747AA1BCCA58853D6B1E54BD93A0F7BCF20F43BF39723EBEB3A1A03C72EBB33B3C4AB13DD7CC9E3E4350823D64E598BC70527CBD911F72BBC9D6E9BB6905233B492E033F87DBA3BDCF25833CE5AA193BB6F5FB3EAFD250BDF637AD3CA45D643CB2E867BB1E9981BDA3EB244043FD2BC02E5695BDF7F70F3DF7E2D43A6B1E183C51FFE43C3DECFB3CAC3F873D2120B2BC8CCF77BD83A3E63BD8DC113D3EE7A8BC5D59523D82D3F0BD1A4E5FBDDC5C44BD0F5B75BC30259239A1EC53BE6FAC0D3E03C68B3D3D7AABBB194CB03E9043B6BF5B1EB63D7898E7BC0EEF093D1B9BDFBC6EB8F4BD3E6C2D3BF8AB503D41B9413D28EEFCBDC2969BBEEE9E323D354147BDB1204F3DE61F00BDCBACECBDAE1EFABC4F295A3E6805A3BC9FCC7BBE600576BABB0835BE25F61DBE90DB65BDC40A3EBD50164DBEB865513DAC05F13C54A9573D1D3718BCB7CBF8BB8FC7043FFF0FC43C1D5FCA3C1D143D3B3736B33C05994EBC9A719BBDFE388EBDE687DE3C50361ABDDE3BB1BD5CD59A3D6D45353CFD6E103C56629D3DF1DD0ABDB29F9EBE1EC134BFC071343D5B6D51BEE5FBD43EDA09DDBE6278953B8ACAAE3B27D2243C0AE5CD3CDC30103E0F16FEBC81DF1B3D27BF89BDA950A8BD2515EF3D9516A83FEC20293F4A071E3DFC2A2E3D631A8BBC30C1483C29BEFABD6C2B523EC9B0F83E3E7B0FBDEF714CBC7889C5BDAF60033D7EDD573D4888423BAEB9BD3D29D478BEC8DB783D1D9BD0BC2BC10E3DB20124BEC96F28BE1F6418BDAADBA4BB602A5D3ED1877BBDB9CA8C3DF94458BD10D3133DCFA2173EDAC4303D91AE83BE5D66BC3BB4E76E3CAF6C93BC8662823C9AB0A43C3D45A9BC946F123DA2B826BB8C8017BE8ADDCD3D3E5371BD90F8AEBC9E4DAB3C3A4458BD394162BB5756883D97FA97BC053F80BD974872BD45BE2E3D"> : tensor<20x30xcomplex<f32>>
    return %0 : tensor<20x30xcomplex<f32>>
  }
}
