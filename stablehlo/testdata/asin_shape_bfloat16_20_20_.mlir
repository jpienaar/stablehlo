// RUN: echo "skipping CHLO test (see #1233 for details)"

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x20xbf16>
    %1 = call @expected() : () -> tensor<20x20xbf16>
    %2 = chlo.asin %0 : tensor<20x20xbf16> -> tensor<20x20xbf16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xbf16>, tensor<20x20xbf16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x20xbf16> {
    %0 = stablehlo.constant dense<"0x1340D9C014409040E33F03BFB0BF5E3F653FA03F8ABF31400040BFBF1C40073F11BFD23ED63E873F1DC07A3F8EBE2B3F8C40CDBFCEBF8340CE3F0FC00DC0A5BF9DC02EC007401BC039407C3FCF3F86BFB3C096C005C0AB3F56C0BE40CFBE244044BE8C40C8407EC0963FDD403EC01B400F3FF13F56C09DBFAFBF93C08A40E5BE943F81C00740E03BD7BF87C093C01A406040F64087C03B40583FB4BF7EBF71C0B33F73BFD93CA9BF77BE8540A1BEFF3F93408DC0BEBF6940753F24C0B5BFF3BF5A409C3FC6402E40353FDAC0F63F23C0EA3D98C0863F853F7340C4BF5840063F2740464019402B4076BF1FC0C93FD6BF55403FBF4C40A0C0E53F38C0773EFDBFB0BFE13F6C40A63FE23F9CC01BC00FC0E6C00DBF9BBF75C078409CC084BF943F9BBFB1C01F4039C02AC08F3F82BFC3BFB3C0594001C09CBF9FBE08BF6D3E0CBF8ABF16C0B3C0173F83C01840B03F01C0794052C0E2C0713F39C0C53F274022C0983ED13EB640393F09407BC0784075C07D3F98409BC01FC08340F6BEF93FF13F8E409CC0CCBF31BF1BBF7FBF8140A6403D406A4089C0A440D3BFA43F8DBFCBBF46407B402D4095C066C0B4BFE13FE93F743F83C0993F90C022BE8740C2C045C0F3407E3FE63F25BF63408E3F1F3F604082C08F3F88C05B4034402B4086BFB5C03CC0AC406E406DBE6FC06F40A8C0E63F9A3F163FCEBE2340993FBAC055BF09BE26C0B0BE0541B93E51C081405BC00ABF08BF873FDFBFA1BDB2BFCB3F1EBE0FBFC63F38C0C53F5A40903FA440FFBF73C037400F4092408340F63E89C083C05EC043C022BF98C0A13FF93F8D3D54C036C0124058C027BF273E3E4079BF0B40033FF73F80C0DABE9E3D883EB13F8FBFFF3F2DC0253FC5BE1FC088402FC00FBF4FBF8C40503FC83F1E40A03F67BE053F843FCF3D8DBF96C097C0AA3F2240BFC0FCBF3140AABF574075C0EA3F48BF95BF53409FBFE23FFDBE853FF8BF35C0A04058C078BEC8BD63BF4ABEA73F723F0B3F82409540DC3F944005C0A7404DC02440823F81BEA13F0940F9BF194051C0014098403D4061C014C0E6BF333FA83FA0BF5EBDD73E5BC05940A140B5BF0ABF27C0414076404B3FBB3F683E01400440B640013F"> : tensor<20x20xbf16>
    return %0 : tensor<20x20xbf16>
  }
  func.func private @expected() -> tensor<20x20xbf16> {
    %0 = stablehlo.constant dense<"0xC0FFC0FFC0FFC0FFC0FF0ABFC0FF863F8E3FC0FFC0FFC0FFC0FFC0FFC0FF0E3F1ABFD83EDD3EC0FFC0FFAD3F90BE3B3FC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFB23FC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFD5BEC0FF45BEC0FFC0FFC0FFC0FFC0FFC0FFC0FF183FC0FFC0FFC0FFC0FFC0FFC0FFEEBEC0FFC0FFC0FFE03BC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FF803FC0FFB9BFC0FFC0FFA0BFD93CC0FF7ABEC0FFA3BEC0FFC0FFC0FFC0FFC0FFA33FC0FFC0FFC0FFC0FFC0FFC0FFC0FF493FC0FFC0FFC0FFEB3DC0FFC0FFC0FFC0FFC0FFC0FF0D3FC0FFC0FFC0FFC0FFA5BFC0FFC0FFC0FFC0FF58BFC0FFC0FFC0FFC0FF7A3EC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FF16BFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFA1BE10BF703E14BFC0FFC0FFC0FF213FC0FFC0FFC0FFC0FFC0FFC0FFC0FF9D3FC0FFC0FFC0FFC0FF9A3ED73EC0FF4F3FC0FFC0FFC0FFC0FFB53FC0FFC0FFC0FFC0FF00BFC0FFC0FFC0FFC0FFC0FF44BF26BFBEBFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFA23FC0FFC0FFC0FF23BEC0FFC0FFC0FFC0FFB93FC0FF33BFC0FFC0FF2C3FC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FF70BEC0FFC0FFC0FFC0FFC0FF203FD4BEC0FFC0FFC0FF7CBF0ABEC0FFB4BEC0FFBE3EC0FFC0FFC0FF12BF10BFC0FFC0FFA1BDC0FFC0FF1FBE18BFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FF003FC0FFC0FFC0FFC0FF2FBFC0FFC0FFC0FF8D3DC0FFC0FFC0FFC0FF36BF283EC0FFABBFC0FF0A3FC0FFC0FFE1BE9E3D893EC0FFC0FFC0FFC0FF333FCABEC0FFC0FFC0FF18BF70BFC0FF733FC0FFC0FFC0FF6ABE0C3FC0FFD03DC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FF65BFC0FFC0FFC0FFC0FF04BFC0FFC0FFC0FFC0FFC0FF7BBEC8BD8CBF4BBEC0FF9E3F133FC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FF82BEC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FF463FC0FFC0FF5EBDDE3EC0FFC0FFC0FFC0FF12BFC0FFC0FFC0FF6A3FC0FF6B3EC0FFC0FFC0FF083F"> : tensor<20x20xbf16>
    return %0 : tensor<20x20xbf16>
  }
}
