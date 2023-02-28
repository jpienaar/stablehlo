// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x30xui16>
    %1 = call @expected() : () -> tensor<20x30xui16>
    %2 = stablehlo.multiply %0, %0 : tensor<20x30xui16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x30xui16>, tensor<20x30xui16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x30xui16> {
    %0 = stablehlo.constant dense<"0x050000000300020001000200000000000500020001000100030001000100010000000400040001000100000000000800020000000500020003000000040003000000030001000300020000000400020001000000000001000400040003000000010000000100030003000400010006000100050001000000000002000400000001000200000002000300020003000400020003000000010002000100030002000000020001000400000007000000010001000100010000000000020003000000050002000100030002000100020002000300030002000100040000000300020002000000020002000000020005000300000002000200010002000300010001000100020001000400030001000200000001000200050000000100060007000000000000000200060002000000000002000700010003000300060002000300000006000000010000000000010001000400050003000200010005000000000001000700000000000200000001000200030006000500020003000100030006000100040001000000000001000000020004000000040002000200020002000100050005000200010002000200040006000700030000000000030000000100010000000100020000000400040002000100000003000100000000000200000002000100000003000000020002000200010001000100010001000100000000000300010000000200020003000400040001000100000000000200020003000300030000000100010001000200020000000100010003000300020004000400020001000100020001000500010003000200000002000000050002000100010001000200010003000000060004000100010004000100000003000200000000000000040001000200050003000100000004000200010001000000030003000000000006000200010000000000010000000100020001000000040000000000030005000000010000000000020000000000000001000000000003000300050000000000060001000200000001000100030000000100010000000000030001000200020003000500070000000400070000000500050000000700000003000100010005000000020002000500010000000100000003000000020005000200000002000000000003000300020004000000010006000700060001000000010002000400030000000000000001000000000001000300040002000300010001000400020000000300020007000000020000000000060005000300020002000100010004000300020001000100010004000100020001000200000000000400020002000500050000000600020002000700010000000000040001000000010002000200010001000300050000000000000006000200030001000000010002000100020004000100030001000200060001000300010001000100000005000400010002000200000000000500010002000200030001000000010000000000010005000A00040005000000030002000000010001000000020002000400030004000200000000000100020000000000000001000100020005000100030000000100000003000100040000000200000005000200000002000000000002000400010002000200000002000300020001000000010003000200010002000300"> : tensor<20x30xui16>
    return %0 : tensor<20x30xui16>
  }
  func.func private @expected() -> tensor<20x30xui16> {
    %0 = stablehlo.constant dense<"0x190000000900040001000400000000001900040001000100090001000100010000001000100001000100000000004000040000001900040009000000100009000000090001000900040000001000040001000000000001001000100009000000010000000100090009001000010024000100190001000000000004001000000001000400000004000900040009001000040009000000010004000100090004000000040001001000000031000000010001000100010000000000040009000000190004000100090004000100040004000900090004000100100000000900040004000000040004000000040019000900000004000400010004000900010001000100040001001000090001000400000001000400190000000100240031000000000000000400240004000000000004003100010009000900240004000900000024000000010000000000010001001000190009000400010019000000000001003100000000000400000001000400090024001900040009000100090024000100100001000000000001000000040010000000100004000400040004000100190019000400010004000400100024003100090000000000090000000100010000000100040000001000100004000100000009000100000000000400000004000100000009000000040004000400010001000100010001000100000000000900010000000400040009001000100001000100000000000400040009000900090000000100010001000400040000000100010009000900040010001000040001000100040001001900010009000400000004000000190004000100010001000400010009000000240010000100010010000100000009000400000000000000100001000400190009000100000010000400010001000000090009000000000024000400010000000000010000000100040001000000100000000000090019000000010000000000040000000000000001000000000009000900190000000000240001000400000001000100090000000100010000000000090001000400040009001900310000001000310000001900190000003100000009000100010019000000040004001900010000000100000009000000040019000400000004000000000009000900040010000000010024003100240001000000010004001000090000000000000001000000000001000900100004000900010001001000040000000900040031000000040000000000240019000900040004000100010010000900040001000100010010000100040001000400000000001000040004001900190000002400040004003100010000000000100001000000010004000400010001000900190000000000000024000400090001000000010004000100040010000100090001000400240001000900010001000100000019001000010004000400000000001900010004000400090001000000010000000000010019006400100019000000090004000000010001000000040004001000090010000400000000000100040000000000000001000100040019000100090000000100000009000100100000000400000019000400000004000000000004001000010004000400000004000900040001000000010009000400010004000900"> : tensor<20x30xui16>
    return %0 : tensor<20x30xui16>
  }
}
