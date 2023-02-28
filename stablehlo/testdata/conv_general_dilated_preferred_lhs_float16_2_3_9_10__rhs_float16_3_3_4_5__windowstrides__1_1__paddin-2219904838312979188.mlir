// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<2x3x9x10xf16>, tensor<3x3x4x5xf16>)
    %1 = call @expected() : () -> tensor<2x3x6x6xf32>
    %2 = stablehlo.convolution(%0#0, %0#1) dim_numbers = [b, f, 0, 1]x[o, i, 0, 1]->[b, f, 0, 1], window = {} {batch_group_count = 1 : i64, feature_group_count = 1 : i64} : (tensor<2x3x9x10xf16>, tensor<3x3x4x5xf16>) -> tensor<2x3x6x6xf32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<2x3x6x6xf32>, tensor<2x3x6x6xf32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<2x3x9x10xf16>, tensor<3x3x4x5xf16>) {
    %0 = stablehlo.constant dense<"0xA84037395A4099BBDCC24845013EF74127C06C3EDF41C6C1F4281C30FDC4F4BD2C398132514371BFA24087B1C4C0BDC1C0BC89C6AEC5E9486EC07344B2C4D5B80C4725407943743D153990B50C467AC24DBE1F341A4266BA19C033354BB581BD9A3E60BEF1C2D73DCB2C9E44742AAA3C35450C4002B8E3B97BC41ABCAD371FC6713D4B4332BCBE42D539CDC665B8CA4279C232BE1EBF6631ECC4B1BF08B8413622BCB2C063BEE2C05638F140053DD3C045C533C7EFBD74B990449245ABC4E2C200346DC0F2B9F842C4C25CC4B93DC43C9A3C3ABAFAC0453A023906C124C3D539792B4040F6B6793800B722C0DF42C036E1B99ABEA2467F414FC12D3B443374C1FFC52E3EE4BDE4C56B3E5B4106C54939413B23BD263D244081341D3C6F43FABCE2B853BDCB44BFBCB6329ABB8CBAC63E2BC05AC41F449D430D3D2530EFC79DC17745E03CF23E45BC17484E37BD3EE7BBB9C08EC2B6C088450D43524212BD18C55A3CDB322A44D9439FBF7BBB9E4339C279C0204519C5EF44D6C06133E2382BBE323480C4BB44CFBF10C12936E4BF2335B0B832B4B93F39BCE33C0EBB1CB55F3E7EC5A03A3ABF2041E7B458BA623858C30643A93C9144373DBFC44FB8453FCC39E244FFBEF04639BB4748A6C547462F3760A9333A50BC28C3573F14B6044497BC8A3D3D439CBD323C7AB5D9C496C2BC423B40DE3D08C1EA40AC3DA93EEA4147C2113AB947C22DFEAC343F88C5B5C492BE87B4CAC1F0B54B36AEC108450CC024408AB6F0C13040E84651B5EC3A7EC6904401ABCB3DBA401D42A0BF4FC50F2F0E44C2C431BA95C2E2BEAE2F3CC07B402C42C9C4BA294943D6C01BC442367B4095C5EEBCC9414C3A7A40C838DEBEE046E3C4ED2FCC4674B50ABB3644C8307CC51238C4C4CF3D373CEEBF81C017BD8047604350C4F73ACCC5B640223C1F42474443BBE5C200BDAB3FC8B6D13C8BBF1FB6E844F13B533EA443C3330237F540523CF543F0BF6AC253467CBBCAC03443793957C1C3C170BD68BB03C882BF2C3C34BACD3DB3BFE1BB8FBA9AC221C53A441D46D341A43471B92FBF51B7EF41AB40C8373036AF3D80BD3EC4F33F11C67A43E6BC473FE13C3045EEC072AD0EC3D43CA0B8E6C160C50BC1603EDD448F451446C4BB203F26B8073FDD3E7447A93C024116BA45BE013D13AAE3B90C3CB9B65B26DA45C5429CC41139453E0535E8BA8CB9F6C3D2C4C8C129B2C23A1CC5A1C294AE8A362E30D1C18DC1A242D6418BB94EC657478C45EFBFCDC4884223C41DAADF410D4585C2A544C143E7C1B330A63E99C2C9465CC1EA39743F5DC1C7C2EAC6DF3FCCC28DB8213BDC3F99C768BEF6437ABE98C2AA3C84B55A40673C3CB8003F6F3ED133DF402DC0812DE040953ED03A7EB935BF83B7A1C323424DBB3D417E44B841E5C0F1C1F2B4E2BA0B35A542523DB34131B75CC0123E65C5A946E944A2BB25B1BAC520C8DEB9003D8CC0D7BEFA3DDFBF1BC0983F7F46973D12C0A1B850BE06401D41E7C09DC17D3F413A1531"> : tensor<2x3x9x10xf16>
    %1 = stablehlo.constant dense<"0x3E3CBE3D3CC28E40B7BD434186BD13BD87B77DC169C05BC40342CEABACBAE64331C185C3C2C4813B4E462D4212BFAD4357BC784497C12B4141C03340883FF5BFBF3C5F40A1426E44453D72C0B1B914418136CD2A8142D83CB9BC1645B5AD76BE3FC49FBC4EB685395D383C448B3FBCC067BC5E3F0F3C20BFBEA6FEBCA2C47B41B642BDC14E37829E35414C3DF840CBC685C04D3C1DBF69443CC1C7430B469634C0B972385238D53D6247B4C480BB54C0D2C4FC3D6A43E33D2446A33BA0BEEE35AF4380415B3C59B7F03AC134AD4572AAA1C585C3F5BCA340159F784275BCBB3967C1303E2536F4BBF24550C48040CAB9BF44CAC424C1414063BF899EA23E3EBDB641EB32ADC0E0BDF3BF0D2ACA37D3BA5936AEB53BBC29C367450C4008C8D4C0B7BC4839C340ECB8E63A22C0DCC2B6BF2ABE6644DB40D03FD7C208BCC9BDDDB866BC2144B8C4B5B543A1D23D2541B4BD0DBE7241333CD73C39C635BC1F386D3F3F3E6DC084BE0A46"> : tensor<3x3x4x5xf16>
    return %0, %1 : tensor<2x3x9x10xf16>, tensor<3x3x4x5xf16>
  }
  func.func private @expected() -> tensor<2x3x6x6xf32> {
    %0 = stablehlo.constant dense<"0xEF2513C28B0EE6C2A0A2F942E27F69C1D0BEF9C1AC37F941A2C157C2C41981C24A5697423E06D5C162463CC23CCFED40483582C2C0AB8DC1BA1F1942169BDF41CAF451C222E9E0C1108F6DC27896ABC05C1A3441C08582C28623E8C1C0BB36C092D48B426E2A6DC197A299423E5690C100545DC1355FA841B329EC41220CB4424089B0429C3636C19ACCCAC1FE792A4236663B424252C641F0FABB42FF13BC41945219C1603DA9423E4AF9C1B13FB9C2883D91C01CCC4A421E716BC2B8AD93421B02E5418DFDD640F847A2C2626DCF42DEC5C442BFF0C74210D7E1C1BC42B8BF295E70C1C27C87C2812F5742603024C21F9D08C3A6FD31C1BA7D7442273E04C206D020429A518842D20B21427CAB124120409E42D89638422F214DC2F01F21C1668D99C2E20D97C28482E2427EFE8A42D51B2AC1F9C256C1224FDE4156AFBCC2E6C25AC27C28D3421608E1C1F4DAEAC2CCBCAFC110A2B9C0FC97804120882F40850788427BBE39C29AD1B5C2BED600C36A78B6422F7A2742BC2F78C212E880427F072641233448C2EFE80643061D0B43A8B600C3EE4782C21809C2C2A487DFC0CF8D13C215E6D24231A68FC2E75535C2A5F66AC20E3696C00EFBE341B14FAAC2006EA641A416A4412C2EE140B246BBC2781614412811F642D03CADBF9A455942544362C1FC340C43E6DCC0C146995CC203FF2CC1FA2716C29EEF8EC24A930BC2102B7A42B54FE042D6EA6642ACC6454174C42AC272453BC125668841B62E48414CB607C2CC278DC2507CBCC060E826C0D44D2DC230311740BE37814162B72A41CFC503C212CD1E42FA855742C8C512C390778BC24AC209422C9DFD420CD49C41EC67AB420B460E430CCF16429BADF7C2DC11AD42E07F3F40BCD205C3A473F8423A19EB428C4980C2F4058BC2995D2843A242BFC25DE0E5C15C2CCD40D614E9C26EAB724240A24741BC03ACC1CFD29C422E0A31C20B628141D63C0EC29998E741F4308DC1FFC088C26939B4C2D3E88CC28AFC76C2EA806842A004B4BF417F42C2CABABAC27A921E42F276B0C2AF5E47C223A016C39DB5E7C18869D9425902BAC1E76451421BA6A242587849425195AEC2EEEE0E42FC723B41955AA1C1DB233EC21D7A8742965B7F428C6027C2E8BBCFC2AC148242699706C313B442C39E8B1542FE380D43617F90C2ABE19142FB5CDD41D8E262C24EF84A425871A3C03F1904C3"> : tensor<2x3x6x6xf32>
    return %0 : tensor<2x3x6x6xf32>
  }
}

