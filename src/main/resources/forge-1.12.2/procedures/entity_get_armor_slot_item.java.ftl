<#include "mcelements.ftl">
/*@ItemStack*/(${input$entity} instanceof EntityLivingBase ? ((EntityLivingBase) ${input$entity}).getItemStackFromSlot(${toArmorSlot(input$slotid)}) : ItemStack.EMPTY)