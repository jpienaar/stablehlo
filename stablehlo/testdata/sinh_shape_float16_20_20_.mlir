// RUN: echo "skipping CHLO test (see #1233 for details)"

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x20xf16>
    %1 = call @expected() : () -> tensor<20x20xf16>
    %2 = chlo.sinh %0 : tensor<20x20xf16> -> tensor<20x20xf16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xf16>, tensor<20x20xf16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x20xf16> {
    %0 = stablehlo.constant dense<"0xA84317467E35C0B7BCC56A30D0467BC148C274C4B13EFB4133C43E42B439F53E3FC24AC64AC5FAC476BD53352F42AE3F62C39F3F8B322F3F02BE483EBA42673441424BC47C3942BD72C0F3C58FC32743EDC33BC27D2F88C11BBC983ED5C2A9BEDAB434442FB46F4880439A434B3F7C3D0E3BA7BCAFB60139A93668B9D1BBF03D9E401640A6C320C30540A6C3A3B73B433BC4C1C47BC9FFC022BAD3B8EBBBB7BD34C19E406C4378C486C145C5E540553EE13EC840CB3C42C1B83DB5C4DC3F7734C245854547B8F7BEC83E7143AC4198B832BC75BB26C426C561B702B01C4734C30A38353AB42C70BE21C21143E6BF7543D745483706B5B0384C44C7C12D44F9C7EC3B08B4E0C06242E3AD72BF5D390A3BF5C41139EF38D7BAD8B9E03413C4553AF340E23C38C598C416449744302E2EC21A3A7E3EBCBFB9443FC14B401C451D3D37C5CC33B3435946B2311242C3BC90BAF2354B3A6C46CBC4F3BA223EC83DE13EB5C21AB744C577BE92B25236A342C7423B4043C53AC050C185407FC3A84141C0373808433ABFBC417B3903C55AB2104260401FB624C839404DBDF62B4DC40E3C063E8647F04088C5CFBF15C071C2EC27BABC9CC4D8B8B63DC62C27C0CDBC894240C034BACF41B7B9234157C42DC67C297042594113B591AD453A12C1F0377146A8C25BC105B0F1BCE7C11F36A63D14BDCDC4183DE03CE5451DC0C1BB0D433CC2FEC1B9C0C6BCD8B8C1401B3312C4483E35C3804290B818BE0B239839E7C4D844BE472AC5473912414F418B36EEBE0234E23BF34002B8CEC2FB407736A83AD741B53CE7C107AAECC4E6C49BC4D9BFA1BFEBC599C0444776C021C584459A3C96437CC0D2C3603C97371D32F63C23442EC49A41B9454CC42536933CB141AA3F264375BFAAC036C27DBB3E45A9C4DA3E08C395BC92C372B9EB43323CCAC61FC34DC55FBC29BBD6B92B320537823DCEBF16B6B341EC368FC621BF71C400B777361CBCE1BC2A376A3FD5B798B7193F863C50386C44A4BD1B4186404FC203B77C4254C2B62878C408C53C3FC14110BCD04052BDEF4219C52DC06BB531BD0945C0B7F1C639449040E345DBC14CC649BFE1AC44BCF0C41246C7C4E2AB72BD6842BCB43AC6"> : tensor<20x20xf16>
    return %0 : tensor<20x20xf16>
  }
  func.func private @expected() -> tensor<20x20xf16> {
    %0 = stablehlo.constant dense<"0xBF4DE55A9A3507B8D5D86E301A5FB7C7C5C95ED12441F6482AD0A849333A8441ABC935DC31D688D453BF6C357E49AC4202CD93429732DC4145C09A40364B7534B14993D0ED39E8BE90C4FED978CD774C93CEA0C9812FEAC7DDBC02419BCB19C1EDB42E503BB4EE6A504D974D08425F3F013CC6BDE1B65639DB36D4B98FBC3040FB449543B9CD67CC5443B9CDEEB7A44C4CD040D307F70AC6C0BA1FB9A3BCDEBFB5C6FB441C4D74D1E2C713D6BC45AA4067416A45063EE5C6E03FEBD2FE428634F358CC577CB887C14441294D3F48DAB802BD4BBCEACF61D5A5B705B0C76094CC3638D93AB52CCDC058C9474C11C3334D5F5989371BB5F63897507AC81150AAE5A43C13B4AEC5124AE5AD47C2C639FC3B71D469394139B4BB61BAF33459CF043BE545303EC6D52ED26F4F2852322E7BC9B63ADF40C5C20753DAC638442C55A03EC0D5E033DF4D765CBA313049F8BD53BB1536F63ACE5C8AD3DBBB6B400240674124CB56B70CD6D6C09EB27C36E54A664B164406D614C416C7BD444DCD374823C46A38334CEDC16248EB39B1D465B22B49664446B6B7E71244FFBEF72B9CD0C93C49403B63DD45E4D7E7C292C340CAEC27E8BD47D225B9DC3FC72CD9C30ABE8D4A20C4D8BA8D4837BA7C46CBD084DB7C293D4A374729B593ADEE3A45C62238E75CF6CA3EC708B04CBEC5C84636B93F8EBE9AD3963E2D3EAC59B1C383BC3E4CA2C9FDC841C5FDBD25B957452A3352CF9A4096CC704AD0B85FC00B23103A35D4EF53806477D5AB3945461347BA367AC10D349C3CE5452DB880CBFE45A436743B9F48DF3DC5C808AA4AD431D440D2F9C296C2CFD9EEC4966199C447D5C457B03D8C4DA7C43CCE4D3DE1372732563ED34F15D01948C75897D04C36A33D4A48A642744C4CC21AC592C951BCE9559AD25D4133CCA7BD81CDE0B98C4E023DF0DE65CC44D64BBD14BC5EBA35323F376C3FE5C23CB64E48243783DDC6C14ED13AB7A436DFBC2FBE68373A4213B8E2B7BA418D3D86383451B4BF6246BF44D9C93DB7634AE8C9B62874D1C9D4F0416D48CCBC804509BF004C1DD5F2C386B5C7BECE5407B80AE04350D844A159A8C83EDC05C2E2AC1FBD5BD4C35A6CD3E3AB4ABF244ACEB4E8DB"> : tensor<20x20xf16>
    return %0 : tensor<20x20xf16>
  }
}
