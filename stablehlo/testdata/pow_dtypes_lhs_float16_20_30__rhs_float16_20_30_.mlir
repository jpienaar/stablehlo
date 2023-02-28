// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<20x30xf16>, tensor<20x30xf16>)
    %1 = call @expected() : () -> tensor<20x30xf16>
    %2 = stablehlo.power %0#0, %0#1 : tensor<20x30xf16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x30xf16>, tensor<20x30xf16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<20x30xf16>, tensor<20x30xf16>) {
    %0 = stablehlo.constant dense<"0x7B42463047BAE2C4192EC6395D39A440163860378FB3E24478BA57BA2BC08C44F443E9B945345E4669BF4DC1FEC44D43B2C401C1BDC2303050C42EC179330D446533144426C0FBC129C6043C7D42E4C0B340E5C20A3D5DC49541D0C5A33D6A392C406846DDBCF3434DC2B53FECB83239BE4502C2CCC313C28C432CB715C552451D41604207C2E84151BA5F32D1370FB69BC072BCDDC38044E4B4233FA244DDB925420F42BC41E6C3D0C46C29A9C1A4C4DA4082C1503CB6449A385B40933D07C446BD8EC6CD2CA738E7B87C3A1BC22839B7C0953EB83F014203C151C247C3D4B9C93E6F3EADBB5ABA41AB2E3ECE40DFB537413A438FB8323605C4A6BF77AF42B3DFBEA2428EC2173A5D41453B4338BF4476C30A3CF5B439BE08B42BBB9BC14D44A8C6C2BD0DBFCB40B03E0DC149C8B3BC83386DBC1EBE70B75F42533DA4BC77C27BC356330BC1E03DAFBDA1C3B5C3BDC0A240C63B27C5CE40743093B9142D1FC4D94029BC4940123914BEF4BF94B1AF42A5BD0244A0BEA39F354331C0333F47436045EBBFB2C57FBF83BEFEBDFFB888422AC539C47939CFC123C1C3C6A1430BBED63E1CC60440243850BAB4375D36B0C089C6603A593758C083C3474266C11DB9BAC5D6A4F1430645D5C48D3058C3A53EF5C4373C98C609C69ABCECC035C495BB77402D41B1BCC6BB56425D434544D940EF3F424195478FC108355BB72BB10A42BB44004593402BBE6C42D0BC283FDB4169434EBDF6BC7B44C6C43D45353A834326BEC23D99C4D0BE3E3D12BB864076BB78C095405D42C9C2F1C192C103BE9B431B454FC1DEC409C6CE3AD6451BBC31C0363B6346BFC1C8B99A3B1343043693391F3D722DC54199B2AC419E32B1A6F93D3FAD16BC1CC0CBBEBFC11FC1B04469B83ABC25C03C3602339D3C593C3040AAC2A8BD253D13C1ED3D5A37993E6344DEC0EE39B1C05A3C96BC604318C5F7B40ABA95C4D44505C63BC1004137B7943E54C3C24840412DC1153E063C9C3E064277BDA7C1AA3A62B8FC3E9B448A40B1C341BFDDBA9AC2B3C15FBCF8B99EBF2E46B54332C049C15EBE0BBEABC651C09D418A44D9C1F7BCD13B213D4F4445B8A9C190C7F8BCAEBA7FBDB8BF8CBF923C72B8F044B4C16F36343F67C4C242134428C3944098413344ADC510BEE6B9612D6DC211C41445842F8C3ECDC629B8974281C532BE81C442B9EF402244A2AC80C8E9C5A9BF9C4664C539C487C3E845634883C3823CAABF05C55141AB314D4266BC10C199421145D6C295C21F41F2C136321BBC983E31BEEF44AD3F3FBD1142BAC21041D8C261BC7842494461427D40163D1FC3C243EAC294447CC2E743CEC267BC5BC24541264033C4E33D1FBAB631A33590393B4424BFAFB88D34E641E43DF8B7D8B030440644B9C0D1C3CA37E942093D423E4EB8FC44F7408C43D9BB5CC44E4007C0473F374240C3E6C5D241303F2D388A3A84B75F3E2A3F67BBABB034BEE4BDD4B7D7B0983E43C021C3214001BE723ACF3E0E3C35C0B5B8F8C0F5418CC19AC28334523C463C874391C626C236BA61481C44F0C5E5BE52409BB8213EA24434C7263EFD2A9444E942C9427B46C845BAC0F93FE6C1F033D439093C6E3C84C45DBA504006C3E2BF36429DB14040FB454DC5C54468C1823AACC4E4BD97B511C46036894429C2CAB833C02BC1FA3013C22C4048C2BDC0"> : tensor<20x30xf16>
    %1 = stablehlo.constant dense<"0x44395440A4BE0F40D23E673D17386944CFB50FC4CD3DBB30DF4168BD1C4335C51F3E2B3F4BB15643E8C147C5064255332FBFECC2843A89BC71C13E3C0731CD3A2CC416C40A422DB54C3CCAC5813FE1B8BDBE30B518358740C5C23AC51E381AC57C39553298C042B845C0644250C593420CC0EDC3913C97C445BC58351E4120B503327AC07DC22740D54142409E3DD5420AAF09B85EAEF136C641DEC368449FB560B8EC4242419DC27E3BD8C07A3C662685479641204472BC7CC26D38F4C242B71FC3EC3BD5BDAAC316B9F34247441E41E8C1A8BD11BC1B3851C06EB89DB3F136E545543645B967C57CB9C43D93444940BEC2DEC23E3DFFBD15BDA441DCBC23360DC7B33F6E3D1040EA40ABC541C28DBFCEBE22BE5841253A3DB6BBC474C4FEAB8F38F2BB8235293E7CB3A3BB3AC2FAC15D3CDAC448C605C025C180443A3DD1C24E42693127C3C438D83C8FC1F22AAC4400BC7D3D7F4105C7502D85C447C1943D09B6FAC02CC1C83EAABCDA4266403C3F6CC079C4B9C5EB3B73AEE1BC38427037F1B8FD3CE7439230FBBC3048383D26BD9C35F04379410DC55C40DEBF5AC0A841B5C14246403E1ABDE746E63F6EBC8BBDBAC1FFAF5F40E5B5813C6C3842434AC5F8C342B05F3C17C05D46364420B53544504296BDE1B7553E683B4F3DBD3E35479EB9F5C4964230B5B63C6735BCB7D5B91C421BC3FF3C6BC40BC49FC29CBA1DBD60BCA1BD1BBFB34462A123BC20BC3AAA113F7CC23DBA1B4324BE903282424636BF361744463CE0C101C04CBD78C052BD76BD2FB9B44366B951C6443622C61EC57B3CF23A53C4CFBA90447CBC73C613BB2D408644E9BA3AC38AB3B4BE0FC1A63C0B4047414C44DDC016BF31BFF33E333248C89BBD89C390C58E3CCDC0B142E0C110437A46B5B91DC10E40CBB7743BE53B8E412DC02AB516C7A14110BD74C0E34264BD294128414F3E9B4594450DBC02B494C5B5C47A42C9387B44E63C3A392FC082C1D8C469C03A389EC484B9BBBC07C427B86EBAF6321DC664C351C4383FB3B18FC4613AF43EC4BCCB369C39F9441EC19F3530423A3841BFE9C20039D43FAAB6323E06B9443AD03E8744AA405B40B9BBAB4069BF6240383B1FC1B83A1D3EEDC548C1FEC1993E3346EA41983813C4383173C5E1424145013709BCDDA81024984619450FC1C7C490C4203D2FC4C5BED5BD1D3D2735FF4697381C3AC9C2033ACE44B2C4B3C0E3B80DC4E1351A44E6C05D450743C5C1E82D71BDDD3D33BD9B447F411E3D20C57BBC523D69BFF63F6B3A643954BC784570B98341A0BF4ABFDCBD7642E1C18A1CC039ECC3523A7FC048425FBD0ABC312CBEC042B9F0BEDCBD9BBCFEC22EBBACC49E4542C3B9C1133CB4BDF93E36B0CDBF4D3EC845B83A4DBAB4BA9E42FD38FB3C4AA6D5429BC1B33CA0BDE13E03BE1043F2348EBC513668C44342B94415BF99BF68AE37BB54C0EB47E6B960BD3F3F32C227C4C3C024B73E4256C669C1ABBEE9B96DC3A4C665441CC192C049BE83BC174258BCD13838C06FC54F413AC5983EC5C0693A643C10411C38B9BEA94119A2C33948C238C724A42FC14744D33E2A33A241E8BF6E3F1EBDCB4160C52C45B5C30F42C5C35DBE2C408DC7AA43BB3C7AB51238213EC6C2F6C0CCC019B77BC323BFBA32133D7EC6F3C1A03419C4133B5A41C0C5DDA8393499C5E13D5C3C8537"> : tensor<20x30xf16>
    return %0, %1 : tensor<20x30xf16>, tensor<20x30xf16>
  }
  func.func private @expected() -> tensor<20x30xf16> {
    %0 = stablehlo.constant dense<"0x5640902200FE00FEA6242639853A1E511B3DCC4D00FE0F3D00FE00FE00FE290E224800FEFA3CF26200FE00FE00FE623D00FE00FE00FE044900FE00FE5E3A92420D5F901A00FE00FE00FED23B8C4800FE973300FE4E3C00FEEF2700FEC63C54479F3EC73D00FEAD3700FE114800FEBE33742700FE00FE00FEC13300FE00FEAF38C53CC72C00FEBC4800FE1F28DA3500FE00FE00FE00FEAE3F00FE902EB66200FE5538CB51F94B00FE00FE226800FE00FE1F6200FE753DB7310246273E0C3500FE00FE00FE7551FB4700FEB63700FE333500FEE9371A38083F00FE00FE00FE00FEA24DD43C00FE00FE00FE7D3FE35200FE0F29382200FE264400FE00FE00FE00FE00FE064900FE9938A549E23E2A47C52A00FEE23B00FE00FE00FE00FE00FE4E3B00FE00FE00FEAF43183B00FE00FE00FE483800FE00FE00FE802A3E4300FE00FE00FE3D3A00FE083D00FE00FE00FE00FEE836B13B00FE5C18CB3A00FE436200FEBB3900FE7630633700FE00FE00FE6F4800FE1E1800FE00FE083B00FE38464B3FAA3500FE00FE00FE00FE00FE00FEFA3200FE00FEA93500FE00FE00FEF42A00FEEF3200FEF241A24000FE8E338D4100FE00FE1D3CD73100FE00FE873F00FE00FE00FE00FE8344B82800FE710C00FE3B4800FE703B00FE00FE00FE00FE00FE00FE8D38982000FE00FEC743363EEF3732380D482128474A00FEB85600FE00FECB33D931A52E5C3300FEE73B00FE6438983B0E4900FE00FE705A00FE9E3D0237B83E00FE704400FE00FEA83800FE2B3100FE00FEAD38655500FE00FE00FE00FE6814364600FE00FE00FEA5376E3000FE00FE713A4A6C00FE00FE0C3CB42FF0494239973E2516EE5500FE0D31404C00FE533C00FE00FE00FE00FE00FE00FE7E5900FE00FE00FED63F1252573DAF3BF63F00FE00FEBB3800FEE72B2C2F3F38C22800FEFD3D00FEF83C00FEDE6500FE00FE00FE00FE150C00FE00FE955300FE893D00FE2318C72000FEFE3CC93BA939583400FE00FEA23C00FE3D28401B722700FE00FE00FE00FE00FE00FE00FE00FE30700F2800FE00FE00FE00FE00FE00FE8947433800FE00FEDB3B1C3ED16100FE00FE00FE00FE00FE00FE00FE00FE793C00FE180500FEAA4B474100FE94507B4000FE943C8A1B595800FE00FE00FE653C00FE00FEBB6B0B5B152E00FE00FEFB1E00FE00FE00FE00FE5460844000FE00FE00FE00FE9E0800FE00FE00FEAF3F376F00FE983F00FE00FE613C4449604500FE00FEA54EF94700FE00FEFC4200FEE62800FE9A3D00FE086E233900FEB82F00FE1B3400FE00FE053CB1412D21933FAA3800FE2F3100FE6B3C00FE7C3600FE00FE00FE5428283800FE624800FE54588735B73E2E4A00FE00FE6B300F60893D00FE00FE2457C44000FE00FE792DED273E3D433800FEB92D334E083E00FE00FE5E2800FE394C4D3000FE00FE1B368034F41DA43C00FEA640433100FE00FE00FE00FE00FE00FEF43600FE00FE282000FEF23EBF34D53B00FE00FE00FEB73F00FE00FE72285939763C6D2900FE00FE00FE1942F42D00FE00FEF73E00FEE129CE3B00FE4A462D1FA03D1B50B92D0650C82E00FE492600FEBB5A2136BC3BCD3A00FE00FEC04C00FE00FE1F3F00FEFC2C102200FE003800FEC83D00FE00FE00FE00FE223A2D1800FE00FE00FE00FEE53800FEE54100FE00FE"> : tensor<20x30xf16>
    return %0 : tensor<20x30xf16>
  }
}
