<#include "mcitems.ftl">
<#include "aiconditions.java.ftl">
this.tasks.addTask(${customBlockIndex+1}, new EntityAITempt(this, ${field$speed}, ${mappedMCItemToItem(input$item)}, ${field$scared?lower_case})<@conditionCode field$condition/>);
