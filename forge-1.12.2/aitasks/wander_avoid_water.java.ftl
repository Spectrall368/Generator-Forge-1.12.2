<#include "aiconditions.java.ftl">
this.tasks.addTask(${customBlockIndex+1}, new EntityAIWanderAvoidWater(this, ${field$speed})<@conditionCode field$condition/>);
