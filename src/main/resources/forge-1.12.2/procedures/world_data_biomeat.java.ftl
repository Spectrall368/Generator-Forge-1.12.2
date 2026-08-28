<#include "mcelements.ftl">
(ForgeRegistries.BIOMES.getKey(world.getBiome(${toBlockPos(input$x,input$y,input$z)})).equals(new ResourceLocation("${generator.map(field$biome, "biomes")}")))