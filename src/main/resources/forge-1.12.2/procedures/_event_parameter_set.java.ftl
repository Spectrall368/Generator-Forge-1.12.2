<#assign floatParameters = ["FALL_DISTANCE", "FALL_DAMAGE_MULTIPLIER", "CRITICAL_DAMAGE_MULTIPLIER"]>
<#assign intParameters = ["DROPPED_EXPERIENCE"]>
if (event instanceof ${eventClass}) {
	<#if floatParameters?seq_contains(fieldParameterName)>
		((${eventClass}) event).${method}(${opt.toFloat(inputValue)});
    <#elseif intParameters?seq_contains(fieldParameterName)>
		((${eventClass}) event).${method}(${opt.toInt(inputValue)});
    <#else>
		((${eventClass}) event).${method}(${inputValue});
    </#if>
}