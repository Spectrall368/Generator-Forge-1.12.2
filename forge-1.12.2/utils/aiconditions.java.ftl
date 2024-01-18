<#include "procedures.java.ftl">
<#-- @formatter:off -->
<#macro conditionCode conditionfield="" includeBractets=true>
    <#if conditionfield?has_content>
        <#assign conditions = generator.procedureNamesToObjects(conditionfield)>
        <#if hasProcedure(conditions[0]) || hasProcedure(conditions[1])>
			<#if includeBractets>{</#if>
                <#if hasProcedure(conditions[0])>
                @Override public boolean shouldExecute() {
                		double x = Entity${name}.this.posX;
			        double y = Entity${name}.this.posY;
			        double z = Entity${name}.this.posZ;
			        Entity entity = Entity${name}.this;
					World world = Entity${name}.this.world;
                	return super.shouldExecute() && <@procedureOBJToConditionCode conditions[0]/>;
                }
                </#if>
                <#if hasProcedure(conditions[1])>
                @Override public boolean shouldContinueExecuting() {
                		double x = Entity${name}.this.posX;
			        double y = Entity${name}.this.posY;
			        double z = Entity${name}.this.posZ;
			        Entity entity = Entity${name}.this;
			        World world = Entity${name}.this.world;
                	return super.shouldContinueExecuting() && <@procedureOBJToConditionCode conditions[0]/>;
                }
                </#if>
			<#if includeBractets>}</#if>
        </#if>
    </#if>
</#macro>
<#-- @formatter:on -->
