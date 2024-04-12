<#include "procedures.java.ftl">
<#-- @formatter:off -->
<#macro conditionCode conditionfield="" includeBractets=true>
    <#if conditionfield?has_content>
        <#assign conditions = generator.procedureNamesToObjects(conditionfield)>
        <#if hasCondition(conditions[0]) || hasCondition(conditions[1])>
			<#if includeBractets>{</#if>
                <#if hasCondition(conditions[0])>
                @Override public boolean shouldExecute() {
                		double x = EntityCustom.this.posX;
			        double y = EntityCustom.this.posY;
			        double z = EntityCustom.this.posZ;
			        Entity entity = EntityCustom.this;
                	return super.shouldExecute() && <@procedureOBJToConditionCode conditions[0]/>;
                }
                </#if>
                <#if hasCondition(conditions[1])>
                @Override public boolean shouldContinueExecuting() {
                	double x = EntityCustom.this.posX;
			        double y = EntityCustom.this.posY;
			        double z = EntityCustom.this.posZ;
			        Entity entity = EntityCustom.this;
                	return super.shouldContinueExecuting() && <@procedureOBJToConditionCode conditions[0]/>;
                }
                </#if>
			<#if includeBractets>}</#if>
        </#if>
    </#if>
</#macro>
<#-- @formatter:on -->
