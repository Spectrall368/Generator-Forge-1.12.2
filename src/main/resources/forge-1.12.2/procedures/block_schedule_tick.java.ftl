<#include "mcelements.ftl">
world.scheduleUpdate(${toBlockPos(input$x,input$y,input$z)}, world.getBlockState(${toBlockPos(input$x,input$y,input$z)}).getBlock(), ${opt.toInt(input$ticks)});