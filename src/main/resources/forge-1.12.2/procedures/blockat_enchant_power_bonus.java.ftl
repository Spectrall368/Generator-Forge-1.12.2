<#include "mcelements.ftl">
/*@float*/(world.getBlockState(${toBlockPos(input$x,input$y,input$z)}).getBlock().getEnchantPowerBonus(world, ${toBlockPos(input$x,input$y,input$z)}))
