<#include "aiconditions.java.ftl">
this.tasks.addTask(${customBlockIndex+1}, new EntityAILeapAtTarget(this, (float)${field$speed})<@conditionCode field$condition/>);
