<#if !data.flyingMob && !data.waterMob>
<#include "aiconditions.java.ftl">
this.tasks.addTask(${customBlockIndex+1}, new EntityAIOpenDoor(this, true)<@conditionCode field$condition/>);
this.getNavigator().getNodeProcessor().setCanOpenDoors(true);
</#if>
