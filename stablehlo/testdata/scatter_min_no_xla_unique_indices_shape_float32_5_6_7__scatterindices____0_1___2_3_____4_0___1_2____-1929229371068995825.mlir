// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0, 1], [2, 3]], [[4, 0], [1, 2]]]> : tensor<2x2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xf32>, tensor<5x2x2xf32>)
    %2 = call @expected() : () -> tensor<5x6x7xf32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f32>, %arg1: tensor<f32>):
      %5 = stablehlo.minimum %arg0, %arg1 : tensor<f32>
      stablehlo.return %5 : tensor<f32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1, 2], scatter_dims_to_operand_dims = [1, 2], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xf32>, tensor<2x2x2xi32>, tensor<5x2x2xf32>) -> tensor<5x6x7xf32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xf32>, tensor<5x6x7xf32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xf32>, tensor<5x2x2xf32>) {
    %0 = stablehlo.constant dense<"0x516A3A4046C5B23FCC1B8940888C584012E560C09748843F9445F93F169B7A3FD974CABFFC8812BEEB304CC04F61683FC92A9AC024E509400500693EEE8C3DC05A4E7CBF39E3A340D8B39C40206479C0F8FBE03F10F924C07E67BC3FB063C3BF2B14893F94EEAA3F583F1340CC3708C06E06A840FA1384C03201F83F0512B640140A28407B30E3BE14D1EC3F8E571240823A2840DFF02DC06C50A5BFB0F819C060C2B6C0EC3B8BC056B4503FB20E163FD53B4EC0F2140740C5491E3F049A6BBFD3FD66BCE84191BFD1C59EC0911BD5BF71214AC090798DBF25A050C012104140B085CE3F199618C0FB6812C0B4C97340723C45C06F44B0BF76AD97C001EC8AC0C44014C079BEBF3E008CB7C0863479C0DE0267400FEC9A40392B79C028D3293E7C30E940F1912740FFD2F5BF9085CB409989C3407101A63FE2F60B40CC3B9D40202464BF7A3BC94066D9EEBF407EED3DEF317E3FAEFAB93DEB20884042C1B1BF45E30FC06AFBE2BEAB6CAC3DA40B10400477773F2ED37240F2E225C0B0908EBEFDEAE74041E473C067DDA8C0E1A78740D535B2BFCBD2BFBF490D9ABF5DFB8BBFFD416240DA8046401E4E523FDD8C8DC0E0BAA240DAEC204025BE4FBF033ABEBEC08507BF1DA758C0934C9C40BB6EE1BF5CBFE23FE80152C06B86DF3FE2BB42C0A112144039EA48BE25CC6540F1B837C08FB6C4BEE6584C40AFEF64C0857A22C00CEA693FC2B20B41B96A6E40294268BF54B87040DA68A8C0DB069A3F5E3E4A3E026905401BC99F3F6BBBB840B2C8E8BF82E70FC0037AE13F2A8282C001C384BEE7BD08408A15B23F9D9F76BE439F263F9370DFBFF876A93F449ADBBFF3A02AC09C5E393F5A0D9DC060B5EEBF5910193FE3C96DC0DC66BD3FE915C7BF2999373F1BA5883EE3572940C5BB773FD029E83F50620AC066778ABF75C395BFFD5489408B505C4049B3004015077A3F05BC96BF07651F3F70917A404FB664C080F2BBBF9D76A5C05138D43F877B8EC06952B8BF0B97893DAF48C03F934319C0DE41D6BE558F9BBE1B0305C006DC883FB96CE53FB5F2A5C0EEF184C04F4214C0C709FDBE819D94BFA292D23E20E208C015F2BF3F9C7996C05D3B794050B1BABF468C863F30AD8B3FB9C0A3BFCBE3A040CD53D0BED2B21640A5A02C3FB3AC95BF80DB18C0B9130540987912C0"> : tensor<5x6x7xf32>
    %1 = stablehlo.constant dense<[[[0.282547712, 1.21097386], [0.164277151, -3.5761683]], [[0.349376023, 1.97441816], [1.61137021, -1.26073551]], [[-3.75636697, 1.80225968], [-7.20570755, 1.23007429]], [[-2.29820848, -2.214780e+00], [1.94503427, -4.65454435]], [[2.52524233, -1.0758779], [0.63784492, -0.224428773]]]> : tensor<5x2x2xf32>
    return %0, %1 : tensor<5x6x7xf32>, tensor<5x2x2xf32>
  }
  func.func private @expected() -> tensor<5x6x7xf32> {
    %0 = stablehlo.constant dense<"0x516A3A4018AA903ECC1B8940888C584012E560C09748843F9445F93F169B7A3FD974CABFF1DF64C0EB304CC04F61683FC92A9AC024E509400500693EEE8C3DC05A4E7CBF31019B3FD8B39C40206479C0F8FBE03F10F924C07E67BC3FB063C3BF2B14893F94EEAA3F583F1340CC3708C04538283EFA1384C03201F83F0512B640140A28407B30E3BE14D1EC3F8E571240823A2840DFF02DC06C50A5BFB0F819C060C2B6C0EC3B8BC056B4503F6AE1B23ED53B4EC0F2140740C5491E3F049A6BBFD3FD66BCE84191BFD1C59EC0911BD5BF71214AC090798DBF25A050C012104140B085CE3F199618C0FB6812C0BCB9FC3F723C45C06F44B0BF76AD97C001EC8AC0C44014C079BEBF3E008CB7C0863479C0DE0267400FEC9A40392B79C028D3293E7C30E940F1912740FFD2F5BF9085CB409989C3407101A63FE2F60B40CC3B9D40202464BF7A3BC94066D9EEBF407EED3DEF317E3F516870C0EB20884042C1B1BF45E30FC06AFBE2BEAB6CAC3DA40B10400477773F13739D3FF2E225C0B0908EBEFDEAE74041E473C067DDA8C0E1A78740D535B2BFCBD2BFBF490D9ABF5DFB8BBFFD416240DA8046401E4E523FDD8C8DC0E0BAA240DAEC204025BE4FBF033ABEBE2895E6C01DA758C0934C9C40BB6EE1BF5CBFE23FE80152C06B86DF3FE2BB42C0A112144039EA48BE25CC6540F1B837C08FB6C4BEE6584C40AFEF64C0857A22C00CEA693FC2B20B41B96A6E40294268BF54B87040DA68A8C0DB069A3F07F294C0026905401BC99F3F6BBBB840B2C8E8BF82E70FC0037AE13F2A8282C0F5BE0DC0E7BD08408A15B23F9D9F76BE439F263F9370DFBFF876A93F449ADBBFF3A02AC09C5E393F5A0D9DC060B5EEBF5910193FE3C96DC0DC66BD3FE915C7BF2999373F1BA5883EE3572940C5BB773FD029E83F50620AC066778ABF75C395BFFD5489408B505C4049B3004015077A3F05BC96BF07651F3F70917A404FB664C080F2BBBF9D76A5C0A8D065BE877B8EC06952B8BF0B97893DAF48C03F934319C0DE41D6BE558F9BBE1B0305C006DC883FB96CE53FB5F2A5C0EEF184C04F4214C0C709FDBE819D94BFA292D23E20E208C015F2BF3F9C7996C05D3B794050B1BABF468C863F30AD8B3FB9C0A3BFCBE3A040CD53D0BED2B21640A5A02C3FB3AC95BF80DB18C0B9130540987912C0"> : tensor<5x6x7xf32>
    return %0 : tensor<5x6x7xf32>
  }
}

