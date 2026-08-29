<#include "mcelements.ftl">
if(${input$entity} instanceof EntityPlayer) ((EntityPlayer) ${input$entity}).setSpawnPoint(${toBlockPos(input$x,input$y,input$z)}, true);