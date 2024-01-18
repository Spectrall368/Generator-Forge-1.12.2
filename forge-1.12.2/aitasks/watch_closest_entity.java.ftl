<#include "aiconditions.java.ftl">
this.tasks.addTask(${customBlockIndex+1}, new EntityAIWatchClosest(this, ${generator.map(field$entity, "entities")}.class,(float)${field$radius})<@conditionCode field$condition/>);
