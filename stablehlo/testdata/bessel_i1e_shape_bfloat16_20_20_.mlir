// RUN: echo "skipping CHLO test (see #1233 for details)"

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x20xbf16>
    %1 = call @expected() : () -> tensor<20x20xbf16>
    %2 = chlo.bessel_i1e %0 : tensor<20x20xbf16> -> tensor<20x20xbf16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xbf16>, tensor<20x20xbf16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x20xbf16> {
    %0 = stablehlo.constant dense<"0x99C08A3F29C00D3C253F903F1BC0263E463FE23EC2BE65BFD3BF82406AC08640AEC023C0BABF873F86BFC03F733F3AC076C091BF2C3FFC3F0EC0534036C0344050403940CB3E67403CC07ABF0AC023408540B23F37BFAE4098C06FBFCFBF2340323FDDBF34404CC0173F3AC0373F1840AEBF9DC055C07AC08F40FFBF0940E43C1E40E5BEFCBF9D40143F594055C0134048406CBDA8BFEFBE734029BE17C02540593F69C033BF3CC01FC0BCBF7FBF85BF9EBF7940E03F354085BF7C3F86402F405AC0A1BF8C40A73F27C0A93FF2BE8D3F4EBFCA3FA7C006C0C640BBBF47C09540BC3F3DC0A740C9405E3F9340D4C083404F3FD63F45407DBF15C1283FBDBFF43F55C0DD3F9AC085C0A03FBFBF42C0BC400940893F45401B3E42BFFCBF864032C07F3F1640D1BFC0BFA5C04340CD3F3DBE7F402B3F5F3F58C0AEBFA6BFF03F08BFD23E203F334052BE8B3E5CC015C0ADC04CBF433F47C01D402A4056BF01C0953FDABE8DC0B13FD4408E40754017C07540A640C3BF6AC03C40DF3F2BC09340C43F27C0F1C0ADC0CB3EA93F30408140C03D9A4090BF943F64C0073D4D3E523FE3BF2CBFA8C0F1BF77BE1A4008C072C033408640A8401AC091BF11C034C051C00CC1E73E34C03B408ABF6F3FC2BF3640053F1EBEFB3FA7BF82C0EA3EFBBFF13F55C0623F77C0993FB1BD18C00D4005404A400D4016C091BF8840DF3FC83F36C02EBF7DC06A4051408FC01DC00EBF27BF5AC022C04ABF2C3F0840AEC028BE3540FE3EFABE393FB84038C0623D07BF84C05BC05E3E19C0073F58C01CC04A40D63E923FB43E72C08F40044035C0D73F37C02A407C4036BF963FB63F0C40A74019BF40C030BF693D44C027BE61408D4035C0B0BED33FDAC09BC029BF333FE4BF06BFE73F93C091BF47BF033F50BDF33F0F4033C0A9406A4092BF2E400A3FDE3F90BE124033C0063FB4BF9EBE83BFFB3FC3BF7BBF59C081403EC0C3BF54C09540233F0840264060C056400E407DC0D83F3E40653F48BFDCBBA94016C06540CF4017C08D3E28BF95BFC83E8FBE9D3D87402540DF3FBAC06D400240A83F3C4070C014409DC001409240FF3FF0BF1840913FC9409E3F17C0683F993F463F29408C3F17C01140"> : tensor<20x20xbf16>
    return %0 : tensor<20x20xbf16>
  }
  func.func private @expected() -> tensor<20x20xbf16> {
    %0 = stablehlo.constant dense<"0x2BBE583E51BE8C3B363E5A3E55BE8E3D453E153E07BE4FBE60BE363E3DBE343E22BE53BE60BE573E57BE603E523E4BBE3ABE5ABE3A3E5D3E59BE443E4DBE4D3E453E4C3E0B3E3E3E4BBE54BE5ABE533E343E603E3FBE223E2BBE51BE60BE533E3D3E60BE4D3E46BE2F3E4BBE3F3E563E5FBE29BE43BE39BE303E5DBE5A3E5E3C543E16BE5DBE293E2D3E423E43BE573E473EDFBC5FBE1ABE3B3E90BD56BE523E4B3E3DBE3DBE4BBE54BE60BE55BE57BE5DBE393E5F3E4D3E57BE543E343E4F3E42BE5EBE313E5F3E51BE5F3E1BBE593E48BE603E25BE5BBE1A3E60BE47BE2D3E603E4ABE253E193E4D3E2E3E15BE353E483E603E483E54BE00BE383E60BE5E3E43BE603E2ABE34BE5E3E60BE49BE1D3E5A3E583E483E863D43BE5DBE343E4EBE553E573E60BE60BE26BE493E603E9EBD373E393E4D3E42BE5FBE5EBE5E3E26BE0E3E343E4E3EACBDD63D41BE57BE23BE47BE443E47BE543E503E4ABE5CBE5B3E12BE30BE603E153E303E3A3E56BE3A3E253E60BE3DBE4B3E5F3E50BE2E3E603E51BE0DBE23BE0B3E5F3E4F3E373E2F3D2A3E5ABE5B3E3FBE833CA93D493E5FBE3ABE25BE5EBEC3BD553E5ABE3BBE4E3E343E253E55BE5ABE58BE4DBE44BE04BE173E4DBE4B3E58BE513E60BE4D3E243E88BD5D3E5FBE36BE183E5DBE5E3E43BE4E3E39BE5C3E22BD56BE593E5B3E463E593E57BE5ABE333E5F3E603E4DBE3BBE38BE3D3E443E30BE54BE29BE37BE42BE53BE46BE3A3E5A3E22BE8FBD4D3E1F3E1EBE403E1F3E4CBED63C25BE35BE41BEB43D56BE253E42BE55BE463E103E5B3E013E3BBE303E5B3E4DBE603E4CBE503E383E3EBE5C3E603E593E253E30BE4ABE3CBEDC3C48BE8EBD403E303E4DBEFDBD603E13BE2ABE38BE3D3E5FBE24BE5F3E2EBE5ABE45BE223EC6BC5E3E593E4EBE243E3D3E5BBE4F3E273E603EDCBD583E4EBE243E60BEEBBD56BE5D3E60BE54BE42BE373E4ABE60BE43BE2D3E353E5A3E523E40BE433E593E38BE603E4A3E4F3E45BE5BBB243E57BE3E3E173E56BED83D38BE5BBE0A3EDABD123D333E523E5F3E1EBE3C3E5C3E5F3E4B3E3BBE573E29BE5C3E2E3E5D3E5EBE563E5A3E193E5D3E56BE4F3E5C3E453E513E593E56BE583E"> : tensor<20x20xbf16>
    return %0 : tensor<20x20xbf16>
  }
}
