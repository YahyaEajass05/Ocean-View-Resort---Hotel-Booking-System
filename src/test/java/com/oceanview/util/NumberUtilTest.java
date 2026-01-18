package com.oceanview.util;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;

import java.math.BigDecimal;

import static org.assertj.core.api.Assertions.*;

/**
 * Unit tests for NumberUtil
 */
@DisplayName("NumberUtil Tests")
class NumberUtilTest {
    
    @Test
    @DisplayName("Should format currency correctly")
    void testFormatCurrency() {
        BigDecimal amount = new BigDecimal("1234.56");
        String formatted = NumberUtil.formatCurrency(amount);
        
        assertThat(formatted).isEqualTo("$1,234.56");
    }
    
    @Test
    @DisplayName("Should format currency with custom symbol")
    void testFormatCurrencyWithSymbol() {
        BigDecimal amount = new BigDecimal("1234.56");
        String formatted = NumberUtil.formatCurrency(amount, "€");
        
        assertThat(formatted).isEqualTo("€1,234.56");
    }
    
    @Test
    @DisplayName("Should handle null amount in currency formatting")
    void testFormatNullCurrency() {
        String formatted = NumberUtil.formatCurrency(null);
        
        assertThat(formatted).isEqualTo("$0.00");
    }
    
    @Test
    @DisplayName("Should round BigDecimal correctly")
    void testRoundBigDecimal() {
        BigDecimal amount = new BigDecimal("123.456");
        BigDecimal rounded = NumberUtil.round(amount);
        
        assertThat(rounded).isEqualByComparingTo(new BigDecimal("123.46"));
    }
    
    @Test
    @DisplayName("Should round double correctly")
    void testRoundDouble() {
        double value = 123.456;
        double rounded = NumberUtil.round(value);
        
        assertThat(rounded).isEqualTo(123.46);
    }
    
    @Test
    @DisplayName("Should calculate percentage correctly")
    void testCalculatePercentage() {
        double percentage = NumberUtil.calculatePercentage(25, 100);
        
        assertThat(percentage).isEqualTo(25.0);
    }
    
    @Test
    @DisplayName("Should handle division by zero in percentage")
    void testCalculatePercentageWithZeroTotal() {
        double percentage = NumberUtil.calculatePercentage(25, 0);
        
        assertThat(percentage).isEqualTo(0.0);
    }
    
    @Test
    @DisplayName("Should calculate discount amount")
    void testCalculateDiscount() {
        BigDecimal amount = new BigDecimal("100.00");
        BigDecimal discount = NumberUtil.calculateDiscount(amount, 10.0);
        
        assertThat(discount).isEqualByComparingTo(new BigDecimal("10.00"));
    }
    
    @Test
    @DisplayName("Should apply discount to amount")
    void testApplyDiscount() {
        BigDecimal amount = new BigDecimal("100.00");
        BigDecimal discounted = NumberUtil.applyDiscount(amount, 10.0);
        
        assertThat(discounted).isEqualByComparingTo(new BigDecimal("90.00"));
    }
    
    @Test
    @DisplayName("Should calculate tax")
    void testCalculateTax() {
        BigDecimal amount = new BigDecimal("100.00");
        BigDecimal tax = NumberUtil.calculateTax(amount, 10.0);
        
        assertThat(tax).isEqualByComparingTo(new BigDecimal("10.00"));
    }
    
    @Test
    @DisplayName("Should calculate total with tax")
    void testCalculateTotalWithTax() {
        BigDecimal amount = new BigDecimal("100.00");
        BigDecimal total = NumberUtil.calculateTotalWithTax(amount, 10.0);
        
        assertThat(total).isEqualByComparingTo(new BigDecimal("110.00"));
    }
    
    @Test
    @DisplayName("Should check if amount is positive")
    void testIsPositive() {
        assertThat(NumberUtil.isPositive(new BigDecimal("10.00"))).isTrue();
        assertThat(NumberUtil.isPositive(new BigDecimal("0.00"))).isFalse();
        assertThat(NumberUtil.isPositive(new BigDecimal("-10.00"))).isFalse();
        assertThat(NumberUtil.isPositive(null)).isFalse();
    }
    
    @Test
    @DisplayName("Should check if amount is zero")
    void testIsZero() {
        assertThat(NumberUtil.isZero(new BigDecimal("0.00"))).isTrue();
        assertThat(NumberUtil.isZero(BigDecimal.ZERO)).isTrue();
        assertThat(NumberUtil.isZero(new BigDecimal("10.00"))).isFalse();
        assertThat(NumberUtil.isZero(null)).isTrue();
    }
    
    @Test
    @DisplayName("Should get max value")
    void testMax() {
        BigDecimal a = new BigDecimal("100.00");
        BigDecimal b = new BigDecimal("200.00");
        
        assertThat(NumberUtil.max(a, b)).isEqualByComparingTo(b);
        assertThat(NumberUtil.max(b, a)).isEqualByComparingTo(b);
        assertThat(NumberUtil.max(null, b)).isEqualByComparingTo(b);
        assertThat(NumberUtil.max(a, null)).isEqualByComparingTo(a);
    }
    
    @Test
    @DisplayName("Should get min value")
    void testMin() {
        BigDecimal a = new BigDecimal("100.00");
        BigDecimal b = new BigDecimal("200.00");
        
        assertThat(NumberUtil.min(a, b)).isEqualByComparingTo(a);
        assertThat(NumberUtil.min(b, a)).isEqualByComparingTo(a);
        assertThat(NumberUtil.min(null, b)).isEqualByComparingTo(b);
        assertThat(NumberUtil.min(a, null)).isEqualByComparingTo(a);
    }
    
    @Test
    @DisplayName("Should safely convert string to BigDecimal")
    void testSafeBigDecimal() {
        assertThat(NumberUtil.safeBigDecimal("123.45"))
            .isEqualByComparingTo(new BigDecimal("123.45"));
        
        assertThat(NumberUtil.safeBigDecimal("invalid"))
            .isEqualByComparingTo(BigDecimal.ZERO);
        
        assertThat(NumberUtil.safeBigDecimal(null))
            .isEqualByComparingTo(BigDecimal.ZERO);
        
        assertThat(NumberUtil.safeBigDecimal(""))
            .isEqualByComparingTo(BigDecimal.ZERO);
    }
    
    @Test
    @DisplayName("Should format percentage")
    void testFormatPercentage() {
        String formatted = NumberUtil.formatPercentage(0.15);
        
        assertThat(formatted).isEqualTo("15.0%");
    }
}
