<#include "mcelements.ftl">
(world instanceof WorldServer && world.getVillageCollection().getNearestVillage(${toBlockPos(input$x,input$y,input$z)}, 1) != null)