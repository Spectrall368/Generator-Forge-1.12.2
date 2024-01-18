<#include "aiconditions.java.ftl">
this.tasks.addTask(${customBlockIndex+1}, new EntityAIAvoidEntity(this, ${generator.map(field$entity, "entities")}.class, (float)${field$radius}, ${field$farspeed}, ${field$nearspeed})<@conditionCode field$condition/>);
