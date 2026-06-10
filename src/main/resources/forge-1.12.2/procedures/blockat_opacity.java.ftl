<#include "mcelements.ftl">
/*@int*/(world.getBlockState(${toBlockPos(input$x,input$y,input$z)}).getLightOpacity(world, ${toBlockPos(input$x,input$y,input$z)}))