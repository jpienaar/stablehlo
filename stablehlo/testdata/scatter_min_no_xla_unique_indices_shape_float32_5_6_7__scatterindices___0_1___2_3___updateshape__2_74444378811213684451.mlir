// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[0, 1], [2, 3]]> : tensor<2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xf32>, tensor<2x7xf32>)
    %2 = call @expected() : () -> tensor<5x6x7xf32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f32>, %arg1: tensor<f32>):
      %5 = stablehlo.minimum %arg0, %arg1 : tensor<f32>
      stablehlo.return %5 : tensor<f32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [1], inserted_window_dims = [0, 1], scatter_dims_to_operand_dims = [0, 1], index_vector_dim = 1>, unique_indices = true} : (tensor<5x6x7xf32>, tensor<2x2xi32>, tensor<2x7xf32>) -> tensor<5x6x7xf32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xf32>, tensor<5x6x7xf32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xf32>, tensor<2x7xf32>) {
    %0 = stablehlo.constant dense<"0x32DE8F3F136D0B40A9163A406EC69ABD158F0E402860C24087A38A3F5394D6BEBD651CC08DDC703F531978C0F97718BF6FDA3240F83491BE4E7058C0918D9CC0EB200EBF54462C3E6A4CECBFCD56C0BEE2EC0EC0DCB1CA3F78BA07BF987173402BDA60401486E23F4D4BCD3F8B2C043D997E6A40027FA3BF4041C44018BD1E3FB4F3FC3F449EE73F6C111440BCCA0DC064E985BFB62B953F0A1F2E40CF6B87BFEF0C97BF234D74C07362F5BEE5283B40D3D00041E2AFB3BF10640E40DDCB603FF4C5F1BEC5BF443F2874E6BFEE076E407FBAC5408918D13F00F49BC03E990B410FCB26BFF0009E4015AB834081769EBE58E8A13FE3CF2D40154A3BC029C12E400DED45BF4F1CEA3FB92772C02638BC40C92074BFEE3DC23F2BAB12C0FFF4B840A5D04FBF74351FC031851540E5A54CBFD40407BFC41BC93DBE0DD040F5A76C3FC5DDD3BFF7C910C0648906C07FB55F40BFDD2FC01BB7E13E4657E7BF84B61BC029B41540EBBFA5C09A8F3FBF6AFBAF3FF0498740C1699C40BA0442BF39E0753F2D100C3FB9FAEF3F77A0F83E86FDE8BFE70D09C0EFEE43C03D9D7040A538223E7AC74B4015D1E2BE8D56E2BF28E36940F0276A4007C596BFD053933E561F42C07CDD6CC08CE983400BE7FD3FECAC0A40DB70F8BF6F5A15BFBE769FC009D896C01FCA41BFAD2169BFC498A93F9D4258400F576840C17B58408F748E40EF16DB3FA32325C0EF0095BEEC5972BFBF1033C082C0DDBF7B8FA440F10733C0665F7EC0466B2A3F25581FC0EE1B89BF0EDEE53B8FB38ABF23B870BFA8A4C73D7BE9AB3F49FE86C053F8ACBF5BB59F3E6F2A8EC003475D40F2D66AC0105E903F67DC90407C3D834034354540F5CDE6BFC48DA240DFEB09C05F1B58C00AEF573F16DEE43F688044C09F11E140618102BE2E3D4AC0A7A694C0DB9C4C406685FE3EBC10F1BF0A884DBF96CE4CBFE5AC393FBD93174051386B3EAD0504C052F83640FA7F8D402426DABFAF07F1BF5A57BA404589A7402F8610C081899D3FE0A69ABF7DD31B40739F86C017D00D40B71278C0711385BEAF5F773F0DD722403D33763FEF359B405CA6C5BFE6F8D3BFE8427E3FE96F4940E269BFBF9DF586BECD9F5B40557BB2BFB0E3A13E1056AEBFCE6590409F73B73EADF53A3FB01DF5BFC2768340FBF6993F13FE62407C923E3D"> : tensor<5x6x7xf32>
    %1 = stablehlo.constant dense<[[0.259121209, 0.843054831, 0.669577837, 2.22349977, 1.33449864, 1.71097517, 1.27590156], [0.451356411, 4.13842058, -0.795877873, -6.21704149, 3.96128941, 5.8985219, -1.17092741]]> : tensor<2x7xf32>
    return %0, %1 : tensor<5x6x7xf32>, tensor<2x7xf32>
  }
  func.func private @expected() -> tensor<5x6x7xf32> {
    %0 = stablehlo.constant dense<"0x32DE8F3F136D0B40A9163A406EC69ABD158F0E402860C24087A38A3F5394D6BEBD651CC074692B3F531978C0F97718BF3C01DB3FF83491BE4E7058C0918D9CC0EB200EBF54462C3E6A4CECBFCD56C0BEE2EC0EC0DCB1CA3F78BA07BF987173402BDA60401486E23F4D4BCD3F8B2C043D997E6A40027FA3BF4041C44018BD1E3FB4F3FC3F449EE73F6C111440BCCA0DC064E985BFB62B953F0A1F2E40CF6B87BFEF0C97BF234D74C07362F5BEE5283B40D3D00041E2AFB3BF10640E40DDCB603FF4C5F1BEC5BF443F2874E6BFEE076E407FBAC5408918D13F00F49BC03E990B410FCB26BFF0009E4015AB834081769EBE58E8A13FE3CF2D40154A3BC029C12E400DED45BF4F1CEA3FB92772C02638BC40C92074BFEE3DC23F2BAB12C0FFF4B840A5D04FBF74351FC031851540E5A54CBFD40407BFC41BC93DBE0DD040F5A76C3FC5DDD3BFF7C910C0648906C07FB55F40BFDD2FC01BB7E13E4657E7BF84B61BC029B41540EBBFA5C09A8F3FBF6AFBAF3FF0498740C1699C40BA0442BF39E0753F2D100C3FB9FAEF3F77A0F83E86FDE8BFE70D09C0EFEE43C03D9D7040A538223E7AC74B4015D1E2BE8D56E2BFA7BE4BBF01F2C6C007C596BFD053933E561F42C07CDD6CC08CE983400BE7FD3FECAC0A40DB70F8BF6F5A15BFBE769FC009D896C01FCA41BFAD2169BFC498A93F9D4258400F576840C17B58408F748E40EF16DB3FA32325C0EF0095BEEC5972BFBF1033C082C0DDBF7B8FA440F10733C0665F7EC0466B2A3F25581FC0EE1B89BF0EDEE53B8FB38ABF23B870BFA8A4C73D7BE9AB3F49FE86C053F8ACBF5BB59F3E6F2A8EC003475D40F2D66AC0105E903F67DC90407C3D834034354540F5CDE6BFC48DA240DFEB09C05F1B58C00AEF573F16DEE43F688044C09F11E140618102BE2E3D4AC0A7A694C0DB9C4C406685FE3EBC10F1BF0A884DBF96CE4CBFE5AC393FBD93174051386B3EAD0504C052F83640FA7F8D402426DABFAF07F1BF5A57BA404589A7402F8610C081899D3FE0A69ABF7DD31B40739F86C017D00D40B71278C0711385BEAF5F773F0DD722403D33763FEF359B405CA6C5BFE6F8D3BFE8427E3FE96F4940E269BFBF9DF586BECD9F5B40557BB2BFB0E3A13E1056AEBFCE6590409F73B73EADF53A3FB01DF5BFC2768340FBF6993F13FE62407C923E3D"> : tensor<5x6x7xf32>
    return %0 : tensor<5x6x7xf32>
  }
}

