<#if data.breedable>
<#include "aiconditions.java.ftl">
this.tasks.addTask(${customBlockIndex+1}, new EntityAIMate(this, ${field$speed})<@conditionCode field$condition/>);
</#if>
