// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<1> : tensor<2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<3x5x40xui8>, tensor<3x5x2xui8>)
    %2 = call @expected() : () -> tensor<3x5x40xui8>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<ui8>, %arg1: tensor<ui8>):
      %5 = stablehlo.minimum %arg0, %arg1 : tensor<ui8>
      stablehlo.return %5 : tensor<ui8>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [2], scatter_dims_to_operand_dims = [2], index_vector_dim = 1>} : (tensor<3x5x40xui8>, tensor<2x1xi32>, tensor<3x5x2xui8>) -> tensor<3x5x40xui8>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<3x5x40xui8>, tensor<3x5x40xui8>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<3x5x40xui8>, tensor<3x5x2xui8>) {
    %0 = stablehlo.constant dense<"0x0301030402060205000301030300010203000001030402000201030302050001040002020103000101010200070301000003030502030004010201030203000200010203000501010200040202040100010100010103020204080500000202000301020802010001010101030501020101030304020101030400000404000201020000020200030500040302050001010303040000020202010401000602020300040101000000000403030102000001000101000006010101000200000301010200030500060401000000000000010001050000010304030600050000010206010202020203050401030002000000000200000601020001020100020402020301040000010501000000030401030001020104030600030203030101000103030200010302020101050300020001040101030000000402000103020300010500060002000002030102010000020002000101020103020101010103010001020100000301050405000102020101010001000100020100030100040103000304010303000400030002020000010303060101060207010100050101010501000000000605010000030202040603010A0200040405020104030100000800010106020004000502010702010001040200050102010504020402000102000100020503050502010006020401010301010200000100010404030201050502010401010001050401010004050202020200020102050000010207000006000600010204030101020600010000050605000300040404000303050004020003020101020504010002040101030100030104000104000400030100080001"> : tensor<3x5x40xui8>
    %1 = stablehlo.constant dense<[[[2, 4], [0, 1], [1, 7], [5, 1], [3, 3]], [[3, 3], [2, 1], [0, 0], [2, 3], [0, 0]], [[3, 1], [3, 1], [0, 0], [0, 0], [8, 0]]]> : tensor<3x5x2xui8>
    return %0, %1 : tensor<3x5x40xui8>, tensor<3x5x2xui8>
  }
  func.func private @expected() -> tensor<3x5x40xui8> {
    %0 = stablehlo.constant dense<"0x0301030402060205000301030300010203000001030402000201030302050001040002020103000101000200070301000003030502030004010201030203000200010203000501010200040202040100010100010103020204080500000202000301020802010001010101030501020101030304020101030400000404000201020000020200030500040302050001010303040000020202010401000602020300030101000000000403030102000001000101000006010101000200000301010200030500060401000000000000010001050000010304030600050000010206010202020203050401030002000000000200000601020001020100020402020301040000010501000000030401030001020104030600030203000101000103030200010302020101050300020001040101030000000402000103020300010500060002000002030102010000020002000101020103020101010103010001020100000301050405000100020101010001000100020100030100040103000304010303000400030002020000010303060101010207010100050101010501000000000605010000030202040603010A0200040405020104030100000800010106020004000502010702010001040200050102010504020402000102000100020503050002010006020401010301010200000100010404030201050502010401010001050401010004050200020200020102050000010207000006000600010204030101020600010000050605000300040404000303050004020003020101020504010002040101030100030104000104000400030100080001"> : tensor<3x5x40xui8>
    return %0 : tensor<3x5x40xui8>
  }
}

