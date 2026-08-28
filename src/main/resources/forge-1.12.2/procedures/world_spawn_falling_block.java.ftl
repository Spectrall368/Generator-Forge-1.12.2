<#include "mcitems.ftl">
{
    EntityFallingBlock blockToSpawn = new EntityFallingBlock(world, ${input$x}, ${input$y}, ${input$z}, ${mappedBlockToBlockStateCode(input$block)});
    blockToSpawn.fallTime = 1;
    world.spawnEntity(blockToSpawn);
}