package com.miser.moneyTracker.common

import java.math.BigDecimal
import java.math.RoundingMode

internal val HUNDRED: BigDecimal = BigDecimal.valueOf(100)

internal fun BigDecimal.money(): BigDecimal = setScale(2, RoundingMode.HALF_UP)

internal fun BigDecimal.percentOf(total: BigDecimal): BigDecimal =
    if (total.signum() == 0) BigDecimal.ZERO
    else multiply(HUNDRED).divide(total, 1, RoundingMode.HALF_UP)

internal fun Iterable<BigDecimal>.sum(): BigDecimal = fold(BigDecimal.ZERO, BigDecimal::add)
