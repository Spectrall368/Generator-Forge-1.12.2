<#if (data.tameable && data.breedable && (!data.waterMob || data.flyingMob))>
<#include "aiconditions.java.ftl">
this.tasks.addTask(${customBlockIndex+1}, new EntityAIFollowOwner(this, ${field$speed}, (float) ${field$min_distance}, (float) ${field$max_distance}, false)<@conditionCode field$condition/>);
</#if>
