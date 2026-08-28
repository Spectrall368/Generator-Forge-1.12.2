<#include "mcitems.ftl">
/*@int*/(EnchantmentHelper.getEnchantmentLevel(${generator.map(field$enhancement, "enchantments")}, ${mappedMCItemToItemStackCode(input$item, 1)}))