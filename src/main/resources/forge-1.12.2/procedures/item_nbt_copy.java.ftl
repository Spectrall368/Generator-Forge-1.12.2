<#include "mcitems.ftl">
{
    CompoundNBT _nbtTag = ${mappedMCItemToItemStackCode(input$a, 1)}.getTagCompound();
    if (_nbtTag != null)
        ${mappedMCItemToItemStackCode(input$b, 1)}.setTagCompound(_nbtTag.copy());
}