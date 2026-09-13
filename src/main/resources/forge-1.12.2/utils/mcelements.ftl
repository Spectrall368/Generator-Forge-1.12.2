<#function toResourceLocation string>
    <#if string?matches('"[^+]*"')>
        <#return "new ResourceLocation(" + string?lower_case + ")">
    <#else>
        <#return "new ResourceLocation((" + string + ").toLowerCase(java.util.Locale.ENGLISH))">
    </#if>
</#function>

<#function toArmorSlot slot>
    <#if slot == "/*@int*/0">
        <#return "EntityEquipmentSlot.FEET">
    <#elseif slot == "/*@int*/1">
        <#return "EntityEquipmentSlot.LEGS">
    <#elseif slot == "/*@int*/2">
        <#return "EntityEquipmentSlot.CHEST">
    <#elseif slot == "/*@int*/3">
        <#return "EntityEquipmentSlot.HEAD">
    <#else>
        <#return "EntityEquipmentSlot.func_220318_a(EntityEquipmentSlot.Type.ARMOR, ${opt.toInt(slot)})">
    </#if>
</#function>

<#function toAxis direction>
    <#if (direction == "EnumFacing.EAST") || (direction == "EnumFacing.WEST")>
        <#return "EnumFacing.Axis.X">
    <#elseif (direction == "EnumFacing.UP") || (direction == "EnumFacing.DOWN")>
        <#return "EnumFacing.Axis.Y">
    <#elseif (direction == "EnumFacing.NORTH") || (direction == "EnumFacing.SOUTH")>
        <#return "EnumFacing.Axis.Z">
    <#else>
        <#return direction + ".getAxis()">
    </#if>
</#function>

<#function toBlockPos x y z>
    <#return "new BlockPos(" + opt.removeParentheses(x) + "," + opt.removeParentheses(y) + "," + opt.removeParentheses(z) +")">
</#function>