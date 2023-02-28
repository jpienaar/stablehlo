// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<20x20xi8>, tensor<20x20xi8>)
    %1 = call @expected() : () -> tensor<20x20xi8>
    %2 = stablehlo.add %0#0, %0#1 : tensor<20x20xi8>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xi8>, tensor<20x20xi8>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<20x20xi8>, tensor<20x20xi8>) {
    %0 = stablehlo.constant dense<"0x00020000010501FE000300000702FFFD04FBFD03FD000103FFFF040302FC02FE0100FC0202FCFF010605FD0300FE0000FDFD0001FE0107FB040002FF010100FFFD04FE0200FE04FE03080203FEFC0200010004FFFBFB01FC0203FFFA030600FF02000100FBFEFF00FF03FCFEFCFFFAFF00FDFDFE00030102FF0301020101FE02FE0000FCFE00FB01FF00010000FE0601F8FE05030100FDFF0100030202FF01FEFBFF000001FF04FE00FE0100FF01FFFFFB0002FF02F8FD0302FC01FE02000000060102FDFCFF08FCFFFE0303FB010100FF00000100000000010004FE0203FEFA01FFFD04FD040001000002FFFEFF00050300FFFF01FF0302000100FFFF0103FCFF02000000FB0002000000020000FE00000100FF00F8040100FD00FF000200FD0001FC01FC010201FF0202020005FF020100FE00010000FCFF040400FCFFFBFFFFFD02FFFFFEFDFE0103FC020100010002FF0300010001FC0001FC00FE0403FD02FE07FE030102FF00020400FF03FE00020000000200FDFF03000001030000FFF8FD00000202FCFE0300030000F901FF"> : tensor<20x20xi8>
    %1 = stablehlo.constant dense<"0xFFF8FCF9000000010000FFFDFFFFFC05FA0000FB03FC0400FF00F900FD00000304000000F7FF0001FFFEFBFD0000040000000002000103000100000600FFFD0102FEFDFD000005FDFE00000100FF00FF0004FD040000FBFEFFFCFB000201FE00FE00FD01FFFC0200FCFF00FF0101FCFD02040000020000000300000003010000FF00040100FC00FDFD010204000300FE0000FE02FFFCF90300FDFF04000500FE0001FE01000300FEFEFE01FE0902FDFE0301FAFF00FFFFFE00000001000001FEFD010301FC030305FCFDFE01FFFE000602FA04FF04010102FC01040300FA0000FE03000004040000FC03FD01FF00030200FE010100FF000400FD00FF04FFFC0002FF050102010301030201FD0007FEFB01FEFF010301FCFDFB030002000003FDFFFE000201FC0000FE0701FF030001FBFDFF030300FEFCFC0300FE000000040001FCFF02FE0002FD01FE01000002000000FE0004FCFC0200FB03FE00FBFF03FE00FBFC04FFFB020201FF03000000FE0000FE0102FDFCFF0002FFFC03000104FFFE0001FD02FFFCFF0004000102FCFBFE"> : tensor<20x20xi8>
    return %0, %1 : tensor<20x20xi8>, tensor<20x20xi8>
  }
  func.func private @expected() -> tensor<20x20xi8> {
    %0 = stablehlo.constant dense<"0xFFFAFCF9010501FF0003FFFD0601FB02FEFBFDFE00FC0503FEFFFD03FFFC02010500FC02F9FBFF020503F80000FE0400FDFD0003FE020AFB050002050100FD00FF02FBFF00FE09FB01080204FEFB02FF01040103FBFBFCFA01FFFAFA0507FEFF0000FE01FAFA0100FB02FCFDFD00F6FC0201FDFE02030102020301020402FE02FD0004FDFEFCFBFEFC010304000106FFF8FE030500FCF60201FD0206020401FCFB00FE01010204FCFEFC02FE0803FCFDFE01FCFE02F7FC0102FC01FF020001FE030205FEF8020B01FBFB0104FAFF010601FA040004010102FD01080102FDFEFAFF02FD0401080001FC03FF00FDFF030703FE000001FE030600FE00FE0300FFFC0101050102FC0303030201FF0007FCFB01FFFF0003F900FEFB000001000203FAFFFFFC03FDFD0201FD090301030500FDFEFF010301FEFCF802040200FCFFFFFF00F90101FDFEFFFB0201FD020102010002FD0304FDFC03FCFB04FA00F90306FB02F9030202FC040101010700FF03FC0002FE0102FFFCFCFF05FFFC04030104FEF6FD01FD0401F8FD0304030102F5FCFD"> : tensor<20x20xi8>
    return %0 : tensor<20x20xi8>
  }
}
