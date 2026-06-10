<#include "mcelements.ftl">
if(${input$entity} instanceof EntityPlayerMP) ((EntityPlayerMP) ${input$entity}).unlockRecipes(new ResourceLocation[]{${toResourceLocation(input$recipe)}});