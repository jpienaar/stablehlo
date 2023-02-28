// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0, 1], [2, 3]], [[4, 0], [1, 2]]]> : tensor<2x2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xf32>, tensor<5x2x2xf32>)
    %2 = call @expected() : () -> tensor<5x6x7xf32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f32>, %arg1: tensor<f32>):
      stablehlo.return %arg1 : tensor<f32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1, 2], scatter_dims_to_operand_dims = [1, 2], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xf32>, tensor<2x2x2xi32>, tensor<5x2x2xf32>) -> tensor<5x6x7xf32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xf32>, tensor<5x6x7xf32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xf32>, tensor<5x2x2xf32>) {
    %0 = stablehlo.constant dense<"0x708411C06B43FCBF6E5499408F8EAD3FDD562C3FA8C4B53F4BA581BD507E83400BE64EBF53B1AD3F51430B4013A685405DB373C08805BBBFD806EABFD06D5DBF2DCD74C0268986C08C03BEBF07BBC93F677DD83FA3557940171E50BEF275534083F0054060160BBF0F1FA9BF66F2CD40355A283FB5899840061AC740079745C0330E0140C768F540743C13C05CBA85BD763813C060BCEC3F4591A6C0911299C09D3A1040681E00C0BF5523C0FD8B07409F6D2D40831090BFFF7C0DC06BF751C0C5C9833F69FB303F577B1A3F6FEB55BF2D1F0DC0C00805BEF58E7EBEE42E74BF92CBCD40B1B705C09A6F89C07038CFBF7B538840B8A900C0EE59CE3EB1430DC0809A6DC09368B4402DDAD13EDABE86C0B0502BBE94F98ABF372FAABF37446FBF3B9341C06B7E63404B38DEBF507305C00FD03F3DE86B3EBF7261FC3FDB4E573FC6FA863FD1DF89BF6E47223F41D588C0F2CC97C08D56E2BFC59CAA3DB5BD663F420DEA40A6DC01401CC22840170AC5BF8B5D73C0189899BF57CB9C3FECEB9A40916C81C0CDEDB73F19D8BE3F0949B33E2829084091ED7CC0CC979540E2CE8E4070EE513F1351B03FA4F1F3BEABA34740A723FA3FB274B8C0D2AA194024EB26C004AC114107078AC06E79D53F507B5340AEB8DA3FCD0574BF168095BC5B3C9BC085BE15C02E84AFC0F7FA0BC0316734C0DAC39CC0F2B905C0FE59993FAFBC883F7E7A7A40305B01BF18AE2540DFC20DC0CDFE5940573F183F43E6C5C0CC9BBDBEB3DA2DC03B3FFABF84BEFC3F42A350C007AD4940D8674B40401DCEBF22ECA3C0EC3A9D403CBD8A3FC36077BF9AE955C0C1A5AC3F7F30D8C079755840914F3540A0454CC0DF102640820568BFC059A6BD9D7E03BDFB03443FF2EACCC058A8FF3FDCB3F93EBCED133E3FB5C1C0AE596640CBBCA53F5FD6A6BF1C7B4AC09DDB723F9DBA2B3EC362AD3F3E3D81BE1196E43E0817B6BFB7EC1D40DB5BC83FF28011400C9E63403D0B78BFD0AE8040C8C884C0ADF59040F4B1D9C09BA28E406F86AE3FB11FC7BF1009BDC0669880BF6CB47AC0C407883F7A2542BF8561A740B8FF3440AF4A2340C028B0BE845B4ABFBA35F33E385E38C01DE853BD78C989BF173CA4BFF528994054A701C15C880E3FBA2526C1B1D1B4BFE0437D40BDA072C0E74C7C4008EA15C07BC62940"> : tensor<5x6x7xf32>
    %1 = stablehlo.constant dense<[[[3.14010954, -1.90304768], [-0.578306675, -1.5111382]], [[3.42037559, -1.00669348], [0.374146432, 0.262333512]], [[-1.590760e+00, -2.20000315], [-0.657454491, 0.313102305]], [[-0.817360579, 1.67433298], [2.74968648, 1.50294268]], [[-0.595725596, -0.0344120562], [5.76967239, 5.10947418]]]> : tensor<5x2x2xf32>
    return %0, %1 : tensor<5x6x7xf32>, tensor<5x2x2xf32>
  }
  func.func private @expected() -> tensor<5x6x7xf32> {
    %0 = stablehlo.constant dense<"0x708411C08EF748406E5499408F8EAD3FDD562C3FA8C4B53F4BA581BD507E83400BE64EBFFA6CC1BF51430B4013A685405DB373C08805BBBFD806EABFD06D5DBF2DCD74C01197F3BF8C03BEBF07BBC93F677DD83FA3557940171E50BEF275534083F0054060160BBF0F1FA9BF66F2CD40E80B14BFB5899840061AC740079745C0330E0140C768F540743C13C05CBA85BD763813C060BCEC3F4591A6C0911299C09D3A1040681E00C0BF5523C06FE75A409F6D2D40831090BFFF7C0DC06BF751C0C5C9833F69FB303F577B1A3F9450863E2D1F0DC0C00805BEF58E7EBEE42E74BF92CBCD40B1B705C09A6F89C055DB80BF7B538840B8A900C0EE59CE3EB1430DC0809A6DC09368B4402DDAD13EDABE86C0B0502BBE94F98ABF1F90BF3E37446FBF3B9341C06B7E63404B38DEBF507305C00FD03F3DE86B3EBF7261FC3FDB4E573FC6FA863FD1DF89BF6E47223F41D588C0F2CC97C0069ECBBFC59CAA3DB5BD663F420DEA40A6DC01401CC22840170AC5BF8B5D73C0F24EA03E57CB9C3FECEB9A40916C81C0CDEDB73F19D8BE3F0949B33E28290840DACC0CC0CC979540E2CE8E4070EE513F1351B03FA4F1F3BEABA34740A723FA3FB274B8C0D2AA194024EB26C0F04E28BF07078AC06E79D53F507B5340AEB8DA3FCD0574BF168095BC5B3C9BC085BE15C02E84AFC0F7FA0BC0316734C0DAC39CC0F2B905C0FE59993F8B3E51BF7E7A7A40305B01BF18AE2540DFC20DC0CDFE5940573F183F43E6C5C06D60C03FB3DA2DC03B3FFABF84BEFC3F42A350C007AD4940D8674B40401DCEBF8B50D63FEC3A9D403CBD8A3FC36077BF9AE955C0C1A5AC3F7F30D8C079755840914F3540A0454CC0DF102640DDFA2F40C059A6BD9D7E03BDFB03443FF2EACCC058A8FF3FDCB3F93EBCED133E3FB5C1C0AE596640CBBCA53F5FD6A6BF1C7B4AC09DDB723F9DBA2B3E798118BF3E3D81BE1196E43E0817B6BFB7EC1D40DB5BC83FF28011400C9E6340D080A340D0AE8040C8C884C0ADF59040F4B1D9C09BA28E406F86AE3FB11FC7BFA8F30CBD669880BF6CB47AC0C407883F7A2542BF8561A740B8FF3440AF4A2340C028B0BE845B4ABFBA35F33E28A1B8401DE853BD78C989BF173CA4BFF528994054A701C15C880E3FBA2526C1B1D1B4BFE0437D40BDA072C0E74C7C4008EA15C07BC62940"> : tensor<5x6x7xf32>
    return %0 : tensor<5x6x7xf32>
  }
}

