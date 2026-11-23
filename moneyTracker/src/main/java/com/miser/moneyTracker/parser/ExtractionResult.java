package com.miser.moneyTracker.parser;

import java.util.List;

/**
 * @param transactions parsed rows, in statement order
 * @param issuer       detected (or hinted) issuer code such as "HDFC", or null
 * @param layout       id of the layout/parser that produced the rows
 */
public record ExtractionResult(List<RawTransaction> transactions, String issuer, String layout) {}
