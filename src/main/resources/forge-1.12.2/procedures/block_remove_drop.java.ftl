<#include "mcelements.ftl">
{
    BlockPos _pos = ${toBlockPos(input$x,input$y,input$z)};
    world.getBlockState(_pos).getBlock().dropBlockAsItem(world, ${toBlockPos(input$x2,input$y2,input$z2)}, world.getBlockState(_pos), 1);
    world.destroyBlock(_pos, false);
}