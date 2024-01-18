<#include "aiconditions.java.ftl">
this.tasks.addTask(${customBlockIndex+1}, new EntityAIWander(this, ${field$speed})<@conditionCode field$condition/>);
