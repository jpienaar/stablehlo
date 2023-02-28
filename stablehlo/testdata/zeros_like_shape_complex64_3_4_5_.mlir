// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<3x4x5xcomplex<f32>>
    %1 = call @expected() : () -> tensor<3x4x5xcomplex<f32>>
    %2 = stablehlo.constant dense<(0.000000e+00,0.000000e+00)> : tensor<complex<f32>>
    %3 = stablehlo.broadcast_in_dim %2, dims = [] : (tensor<complex<f32>>) -> tensor<3x4x5xcomplex<f32>>
    %4 = stablehlo.custom_call @check.eq(%3, %1) : (tensor<3x4x5xcomplex<f32>>, tensor<3x4x5xcomplex<f32>>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> tensor<3x4x5xcomplex<f32>> {
    %0 = stablehlo.constant dense<[[[(-1.8476944,6.608480e-01), (2.30718565,-3.3366859), (3.96255565,2.31899405), (-1.05774271,-2.99820375), (1.78074729,0.0737678632)], [(-1.22867727,-4.25917101), (0.0974928438,4.12224579), (6.02427626,-2.6119678), (1.37462902,-4.99993086), (-1.27903044,0.503221631)], [(2.24354219,-0.0258989427), (1.62095606,2.24348211), (6.30881929,1.19026732), (-0.788741409,7.72573519), (-4.34217215,-3.44085383)], [(-2.3669467,0.59207195), (2.7068522,0.72201389), (-5.72046232,-1.68954504), (-0.817109465,-2.43884254), (2.12641716,-0.224107116)]], [[(-2.39961433,-1.55842173), (-4.58822441,5.58338261), (-2.46650743,-4.61054754), (-3.19888902,1.39856148), (-3.60681772,1.5897392)], [(1.20864606,-2.28255224), (-4.10135412,1.01742673), (0.606658279,-2.47849178), (0.530755818,0.475663632), (4.40989923,-1.79087746)], [(1.76853693,-1.08287132), (-2.50653243,2.57089376), (2.89955354,-5.79114819), (5.63796377,2.65848374), (-3.228420e+00,2.79415369)], [(2.47631359,-8.30685806), (1.85714388,-7.11418343), (1.52769566,-6.20857573), (0.121585302,-0.17617619), (-5.07113266,-3.9986546)]], [[(-5.57613468,1.29458058), (0.383943111,3.79235411), (-3.19078279,-0.849788248), (-9.30307769,-3.57834601), (3.05756187,-3.70364237)], [(-4.35320377,-3.82077241), (1.59937179,-1.06858659), (1.92036581,-6.88630152), (2.39236975,-2.4712491), (1.64115965,-2.32817674)], [(2.8281765,2.41708326), (-3.29567599,-8.07255554), (0.0557877831,-0.675997197), (-2.5710218,-1.64465749), (2.22492766,0.658355474)], [(-2.78019738,-3.01595569), (-3.40291977,-1.42372382), (5.604910e+00,6.72183418), (3.64416122,2.09646249), (-0.928863883,2.14125443)]]]> : tensor<3x4x5xcomplex<f32>>
    return %0 : tensor<3x4x5xcomplex<f32>>
  }
  func.func private @expected() -> tensor<3x4x5xcomplex<f32>> {
    %0 = stablehlo.constant dense<(0.000000e+00,0.000000e+00)> : tensor<3x4x5xcomplex<f32>>
    return %0 : tensor<3x4x5xcomplex<f32>>
  }
}
