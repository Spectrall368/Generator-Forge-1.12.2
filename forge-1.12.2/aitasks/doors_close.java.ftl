<#if !data.flyingMob && !data.waterMob>
<#include "aiconditions.java.ftl">
this.tasks.addTask(${customBlockIndex+1}, new EntityAIOpenDoor(this, false)<@conditionCode field$condition/>);
this.getNavigator().getNodeProcessor().setCanOpenDoors(true);
</#if>
