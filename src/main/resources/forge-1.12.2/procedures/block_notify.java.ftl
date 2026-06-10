<#include "mcelements.ftl">
world.notifyNeighborsOfStateChange(${toBlockPos(input$x,input$y,input$z)}, world.getBlockState(${toBlockPos(input$x,input$y,input$z)}, true).getBlock());