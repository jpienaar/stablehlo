// RUN: echo "skipping CHLO test (see #1233 for details)"

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x20xbf16>
    %1 = call @expected() : () -> tensor<20x20xbf16>
    %2 = chlo.acosh %0 : tensor<20x20xbf16> -> tensor<20x20xbf16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xbf16>, tensor<20x20xbf16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x20xbf16> {
    %0 = stablehlo.constant dense<"0x3DC0BFC059402EBF4940F43F21C03F40DABFED3F2D3FAFBFE53E25BF7ABF44C0A43FA4BE8ABF9D40E1BF9740F33FDC3E464017C04DBE7BBE1DC0A6BF50408BBF2AC056BE01C0DCC0863FB93F9240CEBF3F401CBF0D405BBF0AC184BF363E84C0A0C00DC0BE3E7140763FB94091401A401E40DDBE223FFA3F274073C0C03FBB3ECFC0774062C003C0A4BE5F3FA1BFB73EB4406BBF2F3F23409EBF1C40F73F483DC7BF10BFA040D5BF8FC0213FCC3F4DC01E4026C0144046BF07BF853E8E3E87401FC008408E3F313F80BF8640673FE3BF28C0D3BF51C0FDBF20C092C01140603FBC409BC05A3F0E408A40B84037BEBCC08CC0AFBEC7BF26C04EC07C3D8DC068BE7AC008C068408ABE663F0AC0793FE8BFD63F4EC0BEBF2340523F26C03A407E3F953F5AC0434006BF0240D040FDC094403E3F49403C40BAC0F3BE073EC440A1401A40E2BFFB3D5B4084409FBF4F403FBF0B40A6C0D6BFD23F33C005C06BC014406F40383F1EBF85C0523FFF3FA33EDDBF56C06DC0393E2EC0143E30C06340BC40733F3EBF43BF38C034C0E640D33FE9BE8DC076C03040173EECBF52C09640B23F7DC06BBFC53F91BF983F97401FC0713D46402940C4BFA1BFC2BFA43E9F3F32BF7AC0E53D29C0BF40034017C03840773F363D12BF9040CBBFAABF354094C0174082405B3FF3BF15C03FC04CC0624019400EC0CD3F803FA5BF32BDA13EC8403EC01240274003BC03C00C3F8DC001C083C0BDC06D40334086BF5D3FB63F604080C0B33FC3BD96BDB94096BF13BCC9BFAAC0E63E1740DA3F56409AC0BE408DC0A34003C105C142C088407F4002C1D9C0E53FA6BFB4401FBFED3E8DC009C098BF3940BCBFC2C02340DCBF33C0D3BFBD3FA83E283FCDBF3DC0A03F0A400D40A93FB2C0553FDFBF844009C1C6BE05C0C7405F40AC3F8240A84096C05940D53F383F913FF4BF8CC0FE3FA6BFA8C000C1333FBF4080C042BF3CBF1CBE8D3F4DC01E4053408440DF3E2540D8BF66BDA4C0623F2ABEC93EAC3F4DC03EC0C7C0184130403DC00EBF28403E3EF8BFA4BFB140BA3F883EA5BF233E2F3F96BC00C0253F07407FBFEBBF1FC0FA3F2C3F9EBF4BC0BD3EC7BF5EC0B53FEAC0513E3DC025C026C0C0BF"> : tensor<20x20xbf16>
    return %0 : tensor<20x20xbf16>
  }
  func.func private @expected() -> tensor<20x20xbf16> {
    %0 = stablehlo.constant dense<"0xC07FC07FF23FFFFFE83FA13FC07FE13FC07F9D3FFFFFC07FFFFFFFFFFFFFC07F3B3FFFFFC07F1240C07F0F40A13FFFFFE53FC07FFFFFFFFFC07FC07FEC3FC07FC07FFFFFC07FC07F9D3E693F0D40C07FE13FFFFFB63FFFFFC07FC07FFFFFC07FC07FC07FFFFF0040FFFF1C400C40C33FC73FFFFFFFFFA53FCE3FC07F773FFFFFC07F0240C07FC07FFFFFFFFFC07FFFFF1A40FFFFFFFFCB3FC07FC53FA43FFFFFC07FFFFF1340C07FC07FFFFF863FC07FC73FC07FBD3FFFFFFFFFFFFFFFFF0840C07FB13FEF3EFFFFFFFF0740FFFFC07FC07FC07FC07FC07FC07FC07FBB3FFFFF1D40C07FFFFFB73F09401C40FFFFC07FC07FFFFFC07FC07FC07FFFFFC07FFFFFC07FC07FFB3FFFFFFFFFC07FFFFFC07F8D3FC07FC07FCB3FFFFFC07FDD3FFFFF103FC07FE43FFFFFAB3F2440C07F0E40FFFFE83FDE3FC07FFFFFFFFF20401340C33FC07FFFFFF33F0640C07FEC3FFFFFB43FC07FC07F8A3FC07FC07FC07FBD3FFF3FFFFFFFFFC07FFFFFA83FFFFFC07FC07FC07FFFFFC07FFFFFC07FF83F1D40FFFFFFFFFFFFC07FC07F2A408B3FFFFFC07FC07FD63FFFFFC07FC07F0E405C3FC07FFFFF803FC07F1A3F0F40C07FFFFFE53FD03FC07FC07FC07FFFFF2F3FFFFFC07FFFFFC07F1E40AC3FC07FDC3FFFFFFFFFFFFF0C40C07FC07FD93FC07FC13F0540FFFFC07FC07FC07FC07FF83FC23FC07F863F0000C07FFFFFFFFF2140C07FBB3FCE3FFFFFC07FFFFFC07FC07FC07FC07FFE3FD83FC07FFFFF643FF73FC07F5D3FFFFFFFFF1C40C07FFFFFC07FC07FFFFFC13F903FF03FC07F1E40C07F1440C07FC07FC07F08400440C07FC07F973FC07F1A40FFFFFFFFC07FC07FC07FDC3FC07FC07FCB3FC07FC07FC07F713FFFFFFFFFC07FC07F313FB33FB63F483FC07FFFFFC07F0640C07FFFFFC07F2140F63F503F05401640C07FF23F8D3FFFFF023FC07FC07FA73FC07FC07FC07FFFFF1E40C07FFFFFFFFFFFFFE43EC07FC73FEE3F0640FFFFCC3FC07FFFFFC07FFFFFFFFFFFFF503FC07FC07FC07F3C40D63FC07FFFFFD03FFFFFC07FC07F19406B3FFFFFC07FFFFFFFFFFFFFC07FFFFFB03FFFFFC07FC07FA53FFFFFC07FC07FFFFFC07FC07F613FC07FFFFFC07FC07FC07FC07F"> : tensor<20x20xbf16>
    return %0 : tensor<20x20xbf16>
  }
}
