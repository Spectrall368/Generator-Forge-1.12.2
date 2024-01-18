<#include "aiconditions.java.ftl">
this.tasks.addTask(${customBlockIndex+1}, new EntityAIWander(this, ${field$speed}, 40)<@conditionCode field$condition/>);
