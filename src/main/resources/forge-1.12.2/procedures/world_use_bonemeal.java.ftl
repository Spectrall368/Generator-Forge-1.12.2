<#include "mcelements.ftl">
{
    BlockPos _bp = ${toBlockPos(input$x,input$y,input$z)};
    if (ItemDye.applyBonemeal(new ItemStack(Items.BONE_MEAL), world, _bp)) {
    if(!world.isRemote)
    	world.playEvent(2005, _bp, 0);
    }
}