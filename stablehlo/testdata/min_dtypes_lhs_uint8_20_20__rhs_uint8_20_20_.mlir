// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<20x20xui8>, tensor<20x20xui8>)
    %1 = call @expected() : () -> tensor<20x20xui8>
    %2 = stablehlo.minimum %0#0, %0#1 : tensor<20x20xui8>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xui8>, tensor<20x20xui8>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<20x20xui8>, tensor<20x20xui8>) {
    %0 = stablehlo.constant dense<"0x01000002020106070000000202020703010401020201000002040106000400030200000103010304030305030300030402050103000404060202060003010101020200000100000007020300020001050001020302030205000102030103000104030401000105030700010402050100040202040101010401050000050100010200010203000004030100000301020000010103050300020700020300000303010203040200020405020201040000030104000200030401010406010303010101070202020104020301010107010100000302000107020001010500000302010002000203020103050302020200000002010001000205030101040302030700000204000100020602000204030004030200020100020100010001010202030302000201000204000001000200000501000003010100030103060405030000010603000204000301010204020000050301010201020003010001010202000202020000000207000804010303050005020105000401000300000005020302000501020103010003010103030700020201"> : tensor<20x20xui8>
    %1 = stablehlo.constant dense<"0x01060400000203020004040001010100020206020501030107090403030002020003020005040104000002010401000006050002020202020301020201010000000802010503050100020401000002020205010100040104030000030000030200000101000003030000010504000101010402010401000001010105000101040100000504020202050005060000010001010203050002000403000001020101010104050302030000010000040400000201040201050105000401000001020102040100000102020104010102030303050007020402000300020201000704030001000301000200040601000201020200000501030002000202060003010300030301020604000301050004020100020102000404010103010301020302000002010301050100010400010001000106020A00030300020101060001050300020302000400010602050101020201010305040100010200050001010200030401060304070102040401030304020000030505040103020101030401000400020104010700030200010101000100000602"> : tensor<20x20xui8>
    return %0, %1 : tensor<20x20xui8>, tensor<20x20xui8>
  }
  func.func private @expected() -> tensor<20x20xui8> {
    %0 = stablehlo.constant dense<"0x01000000000103020000000001010100010201020201000002040103000000020000000003010104000002010300000002050002000202020201020001010000000200000100000000020300000001020001010100030104000000030000000100000101000003030000010402000100010202010101000001010000000100010100000203000002030000000000010000010103050000000400000000000101010103040200020000010000040000000101000200030101000401000001010101040100000102020101010102010100000002000102000000010200000302010001000201000100040301000200000000000001000002000101040002010300000201000100000301000004020000020100000100010100010001010202000002000201000100000000000000000101000000010100020101060001030000010302000200000301010101020000010301010100010000010001010200000201020000000102000401010303020000020105000101000100000001000300000101010100010000010101000100000201"> : tensor<20x20xui8>
    return %0 : tensor<20x20xui8>
  }
}
