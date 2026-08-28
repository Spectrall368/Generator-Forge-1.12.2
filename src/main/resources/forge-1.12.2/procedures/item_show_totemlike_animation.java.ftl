<#include "mcitems.ftl">
if(world.isRemote)
    Minecraft.getMinecraft().entityRenderer.displayItemActivation(${mappedMCItemToItemStackCode(input$item, 1)});